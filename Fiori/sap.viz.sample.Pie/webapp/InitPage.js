sap.ui.define([
    "sap/ui/Device", 
    "sap/ui/core/Lib", 
    "sap/ui/VersionInfo"
], function(Device, Lib, VersionInfo) {
    "use strict";

    return {
        async initPageSettings(oView) {
            // Hide Settings Panel for phone
            if (Device.system.phone) {
                const oSettingsPanel = oView.byId("settingsPanel");
                oSettingsPanel?.setExpanded(false);
            }

            // to avoid 404s, check if sap.suite.ui.commons is available before using it
            // (sap.suite.ui.commons is available in sapui5, but not in openui5).
            const libInfo = await VersionInfo.load({
                library: "sap.suite.ui.commons"
            });
            if (libInfo != null) {
                await Lib.load("sap.suite.ui.commons");
                return new Promise((resolve, reject) => {
                    sap.ui.require([
                        "sap/suite/ui/commons/ChartContainer",
                        "sap/suite/ui/commons/ChartContainerContent"
                    ], (ChartContainer, ChartContainerContent) => {
                        const vizframe = oView.byId("idVizFrame");
                        const oChartContainerContent = new ChartContainerContent({
                            icon : "sap-icon://pie-chart",
                            title : "vizFrame Pie Chart Sample",
                            content : [ vizframe ]
                        });
                        const oChartContainer = new ChartContainer({
                            content : [ oChartContainerContent ]
                        });
                        oChartContainer.setShowFullScreen(true);
                        oChartContainer.setAutoAdjustHeight(true);
                        oView.byId("chartFixFlex").setFlexContent(oChartContainer);
                        resolve(oView);
                    }, reject);
                });
            }
        }
    };
});