sap.ui.define([
    "sap/ui/base/Object",
    "sap/ui/model/json/JSONModel"
    
], function (BaseObject, JSONModel) {
    "use strict";
    
    // Use a função fetch para carregar o arquivo JSON
    getProducts = function() {
        fetch("mockdata\\products.json")
            .then(function (response) {
                if (!response.ok) {
                    throw new Error("Network response was not ok");
                }
                return response.json();
            }).catch(function (error) {
                // Lida com erros de carregamento do arquivo JSON
                return {
                    ProductCollection: [],
                    ProductCollectionStats: {}
                };
            });
    }
});
