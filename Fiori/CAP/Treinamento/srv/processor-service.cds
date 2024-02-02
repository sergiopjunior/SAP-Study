using { sap.capire.incidents as my } from '../db/schema';

service ProcessorService { 
    entity Incidents as projection on my.Incidents;

    @readonly
    entity Customers as projection on my.Customers;

    entity Conversations as projection on my.Conversations;
}
extend projection ProcessorService.Customers with {
    firstName || ' ' || lastName as name: String
}