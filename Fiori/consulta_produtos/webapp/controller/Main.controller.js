sap.ui.define([
    "sap/ui/core/mvc/Controller",
    'sap/ui/model/Filter',
    "sap/m/library",
    'sap/ui/model/FilterOperator',
    "sap/ui/model/json/JSONModel"
],
    /**
     * @param {typeof sap.ui.core.mvc.Controller} Controller
     */
    function (Controller, Filter, FilterOperator, library, JSONModel) {
        "use strict";

        var urlObject = library.URLHelper;
        var url = "http://localhost:5000/products"
        return Controller.extend("consultaprodutos.controller.Main", {
            onInit: function () {
                this.oFilterBar = this.getView().byId("filterbar");
                this.getProducts();
            },

            getProducts: async function () {
                //sap.ui.core.BusyIndicator.show();
                let productModel = new JSONModel({ products: [] });
                let parameters = {
                    url: url,
                    method: "GET",
                    async: false,
                    crossDomain: true
                };

                $.ajax(parameters).done(function (response) {
                    productModel.oData = response;       
                    this.getView().setModel(productModel);        
                }.bind(this)).fail(function(){
                    //alert("Erro!");
                });

                //sap.ui.getCore().setModel(productModel, 'productmodel');       
                sap.ui.core.BusyIndicator.hide();
            },

            onSelectionChange: function (oEvent) {
                this.oFilterBar.fireFilterChange(oEvent);
            },

            onSearch: function () {
                let aTableFilters = this.oFilterBar.getFilterGroupItems().reduce(function (aResult, oFilterGroupItem) {
                    let oControl = oFilterGroupItem.getControl(),
                        aSelectedKeys = oControl.getSelectedKeys(),
                        aFilters = aSelectedKeys.map(function (sSelectedKey) {
                            return new Filter({
                                path: oFilterGroupItem.getName(),
                                operator: FilterOperator.Contains,
                                value1: sSelectedKey
                            });
                        });

                    if (aSelectedKeys.length > 0) {
                        aResult.push(new Filter({
                            filters: aFilters,
                            and: false
                        }));
                    }

                    return aResult;
                }, []);

                this.getView().byId("tbl_products").getBinding("rows").filter(aTableFilters);
            },

            onCollapseAll: function () {
                let oTreeTable = this.byId("tbl_products");
                oTreeTable.collapseAll();
            },

            onCollapseSelection: function () {
                let oTreeTable = this.byId("tbl_products");
                oTreeTable.collapse(oTreeTable.getSelectedIndices());
            },

            onExpandFirstLevel: function () {
                let oTreeTable = this.byId("tbl_products");
                oTreeTable.expandToLevel(1);
            },

            onExpandSelection: function () {
                let oTreeTable = this.byId("tbl_products");
                oTreeTable.expand(oTreeTable.getSelectedIndices());
            },

            formatAmount: function (amount, currencyCode) {
                let currencySymbols = {
                    "BRL": "R$",
                    "EUR": "€",
                };

                return `${amount} ${currencySymbols[currencyCode] || currencyCode}`;
            },

            formatAmountLink: function (amount) {
                let url = "#";
                return url;
            },

            openDetails: function(){
                alert("Test");
            }
        });
    });
