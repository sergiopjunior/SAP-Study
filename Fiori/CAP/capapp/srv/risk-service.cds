using {sap.ui.riskmanagement as rm} from '../db/schema';

service RiskService @(path: '/risks') {
    entity Risks @(restrict: [
        {
            grant: ['READ'],
            to   : ['RiskViewer']
        },
        {
            grant: ['*'],
            to   : ['RiskManager']
        }
    ])                      as projection on rm.Risks;

    annotate Risks with @odata.draft.enabled;

    entity Mitigations @(restrict: [
        {
            grant: ['READ'],
            to   : ['RiskViewer']
        },
        {
            grant: ['*'],
            to   : ['RiskManager']
        }
    ])                      as projection on rm.Mitigations;

    annotate Mitigations with @odata.draft.enabled;

    // BusinessPartner
    @readonly
    entity BusinessPartners as projection on rm.BusinessPartners;
}

//annotate RiskService with @(requires: 'authenticated-user');
