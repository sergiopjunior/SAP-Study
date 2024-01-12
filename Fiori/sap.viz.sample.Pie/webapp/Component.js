sap.ui.define(['sap/ui/core/UIComponent', "./InitPage"],
    function(UIComponent, InitPage) {
    "use strict";

    var Component = UIComponent.extend("sap.viz.sample.Pie.Component", {
        metadata : {
            manifest: "json",

            interfaces: [
                "sap.ui.core.IAsyncContentCreation"
            ]
        },

        async createContent() {
            // let the base class load the view as configured in the manifest
            const view = await UIComponent.prototype.createContent.call(this);
            // decorate the chart with the ChartContainer, if available
            await InitPage.initPageSettings(view);
            return view;
        }
    });

    return Component;

});
