
const cds = require('@sap/cds')
const prio_descr = ["low", "medium", "high"];

/**
 * Implementation for Risk Management service defined in ./risk-service.cds
*/
module.exports = cds.service.impl(function () {
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
});