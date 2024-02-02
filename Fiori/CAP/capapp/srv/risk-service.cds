using {sap.ui.riskmanagement as rm} from '../db/schema';

service RiskService @(path: '/risks') {
    entity Risks       as select from rm.Risks;
    annotate Risks with @odata.draft.enabled;
    entity Mitigations as select from rm.Mitigations;
    annotate Mitigations with @odata.draft.enabled;
}
