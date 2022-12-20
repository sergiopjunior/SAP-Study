sap.ui.define([
	"sap/ui/core/ComponentContainer"
], function (ComponentContainer) {
	"use strict";

	new ComponentContainer({
		name: "sap.ui.demo.walkthrough",
		settings : {
			id : "walkthrough"
		},
		async: true
	}).placeAt("content");

    // new Text({
	// 	text: "SAP UI5! 2"
	// }).placeAt("content");

	// XMLView.create({
	// 	viewName: "sap.ui.demo.walkthrough.view.App"
	// }).then(function (oView) {
	// 	oView.placeAt("content");
	// });

    //alert("UI5 is ready to go!");
});