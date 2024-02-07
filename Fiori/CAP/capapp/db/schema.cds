namespace sap.ui.riskmanagement;
using {managed} from '@sap/cds/common';
// using an external service from SAP S/4HANA Cloud
using { API_BUSINESS_PARTNER as external } from '../srv/external/API_BUSINESS_PARTNER.csn';

entity Risks : managed {
  key ID          : UUID @(Core.Computed: true);
      title       : String(100);
      prio        : Integer;
      descr       : String;
      miti        : Association to Mitigations;
      impact      : Integer;
      status      : Integer;
      bp          : Association to BusinessPartners;
      criticality : Integer;
      prio_descr  : String(6);
}

entity Mitigations : managed {
  key ID          : UUID @(Core.Computed: true);
      owner       : String;
      description : String;
      timeline    : String;
      risks       : Association to many Risks
                      on risks.miti = $self;
}

entity BusinessPartners as projection on external.A_BusinessPartner {
   key BusinessPartner,
   BusinessPartnerFullName as FullName,
}
