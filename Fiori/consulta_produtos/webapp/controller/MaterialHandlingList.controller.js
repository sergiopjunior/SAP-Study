sap.ui.define([
    'sap/ui/core/mvc/Controller',
    'sap/ui/model/json/JSONModel',
    'consultaprodutos/services/callServices'
], function(Controller, JSONModel, callServices) {
"use strict"
var oCallServices = new callServices()
var oRouter

return Controller.extend("consultaprodutos.controller.MaterialHandlingList", {

    onInit : function () {
        this.oModel = this.getOwnerComponent().getModel("mainService")
        this.oRouter = sap.ui.core.UIComponent.getRouterFor(this)

        this.oRouter.getRoute("RouteMaterialHandlingPage").attachMatched(this._onRouteMatched, this)   
    },

    _onRouteMatched: function (oEvent) {
        let material = oEvent.getParameter("arguments").material
        let warehouse = oEvent.getParameter("arguments").warehouse

        this.getHandlingList(material, warehouse)
    },

    getHandlingList: async function (material, warehouse) {
        sap.ui.core.BusyIndicator.show()
    
        let response = await oCallServices.getMaterialHandlingList(this.oModel, material, warehouse)
        if (response) {
            let listModel = new JSONModel({
                d: {
                    results: []
                }
            });
            let matItem = response.d.results[0]
            let filteredHandlingItems = warehouse !== "0" 
                                      ? matItem.to_handling.results.filter(handlingItem => handlingItem.whnr === warehouse) 
                                      : matItem.to_handling.results

            let totalQuantity = filteredHandlingItems.reduce(
                (total, handlingItem) => total + handlingItem.quantity, 0
                ) 

                let transformedJson = {
                    "d": {
                        "total": filteredHandlingItems.length,
                        "results": {
                                    "active": matItem.active,
                                    "brandnr": matItem.brandnr,
                                    "maktx": matItem.maktx,
                                    "matkl": matItem.matkl,
                                    "matnr": matItem.matnr,
                                    "matty": matItem.matty,
                                    "mbrsh": matItem.mbrsh,
                                    "quantity": totalQuantity,
                                    "price": parseFloat(matItem.price * totalQuantity),
                                    "to_handling": filteredHandlingItems.map(handlingItem => {
                                        return {
                                            "movnr": handlingItem.movnr,
                                            "whnr": handlingItem.whnr,
                                            "docnr": handlingItem.docnr,
                                            "doctype": handlingItem.doctype,
                                            "entrytime": handlingItem.entrytime,
                                            "erdat": handlingItem.erdat,
                                            "ernam": handlingItem.ernam,
                                            "movtyp": handlingItem.movtyp,
                                            "quantity": handlingItem.quantity,
                                            "price": parseFloat(matItem.price * handlingItem.quantity)
                                        }
                                    })
                                }
                        }
                    }
    
            listModel.oData = transformedJson
            console.log(listModel.oData)
            this.getView().setModel(listModel)
        }
    
        sap.ui.core.BusyIndicator.hide()
    },

    handlingDetails: function(oEvent) {
        alert("Test")
    },

    handleNavigationBack: function () {
        var oRouter = sap.ui.core.UIComponent.getRouterFor(this)
        oRouter.navTo("RouteMain")
    }
})

})