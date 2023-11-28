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
            let query = "?$select=matnr,matty,mbrsh,price,maktx&$format=json"

            return new Promise(async (resolve) => {
                let parameters = {
                    url: oModel.sServiceUrl + resource + query,
                    method: "GET",
                    async: true,
                    crossDomain: true,
                    headers: {
                        'Authorization': 'Basic U01FTEdFUzpJbmZpbml0QDAx',
                    }
                };

                $.ajax(parameters).done(function (response) {
                    resolve(response)      
                }.bind(this)).fail(function(){
                    resolve(null) 
                })
            })
        },

		getMaterialHandlingList: function (oModel) {
			return new Promise(async (resolve) => {
                let data = { 
                                MaterialHandlingList: [
                                    {
                                        "ProductId": "HT-1000",
                                        "Description": "Notebook Basic 15 with 2,80 GHz quad core, 15\" LCD, 4 GB DDR3 RAM, 500 GB Hard Disc, Windows 8 Pro",
                                        "Name": "Notebook Basic 15",
                                        "ProductPicUrl": "https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1000.jpg",
                                    }
                                ]
                            }

				resolve(data)
			});
		}

	});
});