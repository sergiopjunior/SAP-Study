sap.ui.define([
    'sap/ui/core/mvc/Controller',
    'sap/ui/model/json/JSONModel',
], function(Controller, JSONModel, callServices) {
"use strict";

var ListController = Controller.extend("consultaprodutos.controller.List", {

    onInit : function (evt) {
        var oModel = this.getOwnerComponent().getModel("products");
        this.getView().setModel(oModel);
    }
});


return ListController;

});