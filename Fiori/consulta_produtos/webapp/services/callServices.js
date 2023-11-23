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
            return new Promise(async (resolve) => {
                let parameters = {
                    url: "http://localhost:5000/materials",
                    method: "GET",
                    async: false,
                    crossDomain: true
                };

                $.ajax(parameters).done(function (response) {
                    resolve(response)      
                }.bind(this)).fail(function(){
                    MessageBox("Erro ao recuperar lista de materiais.")
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