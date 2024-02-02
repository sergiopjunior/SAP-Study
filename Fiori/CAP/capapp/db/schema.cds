namespace sap.ui.riskmanagement;
using {managed} from '@sap/cds/common';

entity Risks : managed {
  key ID          : UUID @(Core.Computed: true);
      title       : String(100);
      prio        : Integer;
      descr       : String;
      miti        : Association to Mitigations;
      impact      : Integer;
      status      : Integer;
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
