sap.ui.define([
	"sap/ui/base/Object",
	"sap/ui/model/json/JSONModel"

], function (
	BaseObject,
	JSONModel
) {
	"use strict";

	return BaseObject.extend("consultaprodutos.services.sapGWService", {
		/**
		* 
		* @returns 
		*/

        getMaterialList: function (oModel) { 
            let resource = "/sap/opu/odata/sap/ZCDS_SP_MATERIAL_CDS/ZCDS_SP_MATERIAL"
            let query = "?$expand=to_stock&$format=json"

            return new Promise(async (resolve) => {
                let parameters = {
                    url: oModel.sServiceUrl + resource + query,
                    method: "GET",
                    async: true,
                    crossDomain: true,
                    headers: {
                        'Authorization': 'Basic REVWRUxPUEVSOjcyNDU2OTgxeGRA',
                    }
                };

                $.ajax(parameters).done(function (response) {
                    resolve(response)      
                }.bind(this)).fail(function(){
                    resolve(null) 
                })
            })
        },

		getMaterialHandlingList: function (oModel, material, warehouse) {
			let resource = "/sap/opu/odata/sap/ZCDS_SP_MATERIAL_CDS/ZCDS_SP_MATERIAL"
            let filter_wh = warehouse !== "0" ? `and whnr eq '${warehouse}'` : ""
            let query = `?$filter=matnr eq '${material}'&$expand=to_handling&$format=json`

            return new Promise(async (resolve) => {
                let parameters = {
                    url: oModel.sServiceUrl + resource + query,
                    method: "GET",
                    async: true,
                    crossDomain: true,
                    headers: {
                        'Authorization': 'Basic REVWRUxPUEVSOjcyNDU2OTgxeGRA',
                    }
                };

                $.ajax(parameters).done(function (response) {
                    resolve(response)      
                }.bind(this)).fail(function(){
                    resolve(null) 
                })
            })
		}

	});
});