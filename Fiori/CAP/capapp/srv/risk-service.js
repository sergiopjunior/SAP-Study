
const cds = require('@sap/cds')
const prio_descr = ["low", "medium", "high"];

/**
 * Implementation for Risk Management service defined in ./risk-service.cds
*/
module.exports = cds.service.impl(async function () {
    /**
     * Event-handler for read-events on the BusinessPartners entity.
     * Each request to the API Business Hub requires the apikey in the header.
     */
    this.on("READ", 'BusinessPartners', async (req) => {
        // connect to remote service
        const BPsrv = await cds.connect.to("API_BUSINESS_PARTNER");
        // The API Sandbox returns alot of business partners with empty names.
        // We don't want them in our application
        req.query.where("LastName <> '' and FirstName <> '' ");

        return await BPsrv.transaction(req).send({
            query: req.query,
            headers: {
                apikey: process.env.apikey,
            },
        });
    });


    // Business Logic
    this.after('READ', 'Risks', risksData => {
        const risks = Array.isArray(risksData) ? risksData : [risksData];
        risks.forEach(risk => {
            if (risk.impact >= 100000) {
                risk.criticality = 1;
            } else {
                risk.criticality = 2;
            }
            risk.status = risk.status === 0 ? 3 : 2;
            risk.prio_descr = prio_descr[risk.prio - 1];
        });
    });


    // Risks?$expand=bp (Expand on BusinessPartner)
    this.on("READ", 'Risks', async (req, next) => {
        // connect to remote service
        const BPsrv = await cds.connect.to("API_BUSINESS_PARTNER");
        /*
         Check whether the request wants an "expand" of the business partner
         As this is not possible, the risk entity and the business partner entity are in different systems (SAP BTP and S/4 HANA Cloud), 
         if there is such an expand, remove it
       */
        if (!req.query.SELECT.columns) return next()

        const expandIndex = req.query.SELECT.columns.findIndex(
            ({ expand, ref }) => expand && ref[0] === "bp"
        );

        if (expandIndex < 0) return next();

        const risks = await next();
        // Remove expand from query
        //req.query.SELECT.columns.splice(expandIndex, 1);

        // try {
        //     // Make sure bp_BusinessPartner (ID) will be returned
        //     if (!req.query.SELECT.columns.find((column) =>
        //         column.ref.find((ref) => ref == "bp_BusinessPartner"))
        //     ) {
        //         req.query.SELECT.columns.push({ ref: ["bp_BusinessPartner"] });
        //     }
        // }
        // catch (TypeError) {
        //     console.log(req.query.SELECT.columns)

        //     return risks
        // }

        // lambda
        const asArray = x => Array.isArray(x) ? x : [x];

        // Request all associated BusinessPartners
        const bpIDs = asArray(risks).map(risk => risk.bp_BusinessPartner);
        try {
            const busienssPartners = await BPsrv.transaction(req).send({
                query: SELECT.from(this.entities.BusinessPartners).where({ BusinessPartner: bpIDs }),
                headers: {
                    apikey: process.env.apikey,
                }
            });

            // Convert in a map for easier lookup
            const bpMap = {};
            for (const businessPartner of busienssPartners) {
                bpMap[businessPartner.BusinessPartner] = businessPartner;
            }

            // Add BusinessPartners to result
            for (const note of asArray(risks)) {
                note.bp = bpMap[note.bp_BusinessPartner];
            }
            return risks;
        }
        catch (error) {
            console.log(error)

            return risks
        }
    });


    // Error handling
    this.on("error", (err, req) => {
        switch (err.message) {
            case "UNIQUE_CONSTRAINT_VIOLATION":
                err.message = "The entry already exists.";
                break;

            default:
                err.message = "An error occured. Please retry. Technical error message: " + err.message;
                break;
        }
    });

    // Request Response
    // this.on("submitOrder", async (req) => {
    //     const { book, amount } = req.data;
    //     let { stock } = awaitdb.read(Books, book, (b) => b.stock);
    //     if (stock >= amount) {
    //         awaitdb.update(Books, book).with({ stock: (stock -= amount) });
    //         awaitthis.emit("OrderedBook", { book, amount, buyer: req.user.id });
    //         returnreq.reply({ stock });// <-- Normal reply
    //     } else {
    //         // Reply with error code 409 and a custom error message
    //         returnreq.error(409, `${amount} exceeds stock for book #${book}`);
    //     }
    // });
});


// cds.serve('inventory-service') .with (function(){
//     this.after('READ', '*', (devices)=>{
//       for (let each of devices) {
//         var deviceAge = calculateDeviceAgeYears(each)
//         if (deviceAge >= 4) {
//           each.eligible_for_replacement = true
//         } else {
//           each.eligible_for_replacement = false
//         }
//    }  })
//   })

/**
   * The service implementation with all service handlers
   */

// module.exports=cds.service.impl(asyncfunction(){
//   /**
//    * Custom error handler
//    *
//    * throw a new error with: throw new Error('something bad happened');
//    *
//    **/
//   this.on("error",(err,req)=>{
//     switch(err.message){
//       case"UNIQUE_CONSTRAINT_VIOLATION":
//         err.message="The entry already exists.";
//         break;

//       default:
//         err.message=
//           "An error occured. Please retry. Technical error message: "+
//           err.message;
//       break;
//     }
//   });
// });


// this.on("submitOrder",async(req)=>{
//     const{ book, amount }=req.data;
//     let{ stock }=awaitdb.read(Books,book,(b)=>b.stock);
//     if(stock >= amount){
//       awaitdb.update(Books,book).with({stock: (stock-=amount)});
//       awaitthis.emit("OrderedBook",{ book, amount,buyer: req.user.id});
//       returnreq.reply({ stock });// <-- Normal reply
//     }else{
//       // Reply with error code 409 and a custom error message
//       returnreq.error(409,`${amount} exceeds stock for book #${book}`);
//     }
//   });