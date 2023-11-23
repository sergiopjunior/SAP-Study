sap.ui.define([
    'sap/ui/core/mvc/Controller',
    'sap/ui/model/json/JSONModel',
    'consultaprodutos/services/callServices'
], function(Controller, JSONModel, callServices) {
"use strict";
var oCallServices = new callServices();
var oRouter;

return Controller.extend("consultaprodutos.controller.MaterialHandlingList", {

    onInit : function () {
        this.oModel = this.getOwnerComponent().getModel()
        this.oRouter = sap.ui.core.UIComponent.getRouterFor(this);
        this.oRouter.getRoute("RouteMaterialHandlingList").attachMatched(this._onRouteMatched, this);    
    },

    _onRouteMatched: function (oEvent) {
        this.getListData()
    },

    getListData: async function () {
        sap.ui.core.BusyIndicator.show()

        let response = await oCallServices.getMaterialHandlingList(this.oModel)
        if (response) {
            let listModel = new JSONModel({ MaterialHandlingList: [] });
            listModel.oData = response
            
            this.getView().setModel(listModel);  
        }
        

        sap.ui.core.BusyIndicator.hide()
    }
});

});