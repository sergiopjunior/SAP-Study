sap.ui.define([
    "sap/ui/core/mvc/Controller",
    'sap/ui/model/Filter',
    "sap/m/library",
    'sap/ui/model/FilterOperator',
    "sap/ui/model/json/JSONModel",
    'consultaprodutos/services/callServices',
    "sap/m/MessageBox"
],
    /**
     * @param {typeof sap.ui.core.mvc.Controller} Controller
     */
    function (Controller, Filter, FilterOperator, MessageBox, JSONModel, callServices) {
        "use strict";
        var oCallServices = new callServices();

        return Controller.extend("consultaprodutos.controller.Main", {
            onInit: function () {
                this.oFilterBar = this.getView().byId("filterbar");

                let oRouter = sap.ui.core.UIComponent.getRouterFor(this);
                oRouter.getRoute("RouteMain").attachMatched(this._onRouteMatched, this);             
            },

            _onRouteMatched: function (oEvent) {
                this.getMaterials();
            },

            getMaterials: async function () {
                sap.ui.core.BusyIndicator.show();

                let response = await oCallServices.getMaterialList(this.oModel)
                if (response) {
                    let materialsModel = new JSONModel(
                        {
                            d: { 
                                results: [] 
                            }
                        }
                    );
                    materialsModel.oData = response

                    // sap.ui.getCore().setModel(materialsModel, 'materialsmodel'); 
                    this.getView().setModel(materialsModel);  
                }
                // else {
                //     MessageBox.error("Erro ao recuperar lista de materiais.")
                // }
                
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

                this.getView().byId("tbl_materials").getBinding("rows").filter(aTableFilters);
            },

            onCollapseAll: function () {
                let oTreeTable = this.byId("tbl_materials");
                oTreeTable.collapseAll();
            },

            onCollapseSelection: function () {
                let oTreeTable = this.byId("tbl_materials");
                oTreeTable.collapse(oTreeTable.getSelectedIndices());
            },

            onExpandFirstLevel: function () {
                let oTreeTable = this.byId("tbl_materials");
                oTreeTable.expandToLevel(1);
            },

            onExpandSelection: function () {
                let oTreeTable = this.byId("tbl_materials");
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
                let oRouter = sap.ui.core.UIComponent.getRouterFor(this);
                oRouter.navTo( "RouteMaterialHandlingList" )
            }
        });
    });
