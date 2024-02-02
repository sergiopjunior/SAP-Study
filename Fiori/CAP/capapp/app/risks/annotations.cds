using from '../../srv/risks-service-ui';
annotate RiskService.Risks with @(
    UI.LineItem : [
        {
            $Type : 'UI.DataField',
            Value : title,
            Label : '{i18n>Ttulo}',
            ![@HTML5.CssDefaults] : {
                width : '30%',
            },
        },
        {
            $Type : 'UI.DataField',
            Value : descr,
            Label : '{i18n>Descrio}',
            ![@HTML5.CssDefaults] : {
                width : '53%',
            },
        },
        {
            $Type : 'UI.DataField',
            Value : prio,
            Criticality : criticality,
            Label : '{i18n>Prioridade}',
            ![@UI.Importance] : #High,
            ![@HTML5.CssDefaults] : {
                width : '5%',
            },
        },
        {
            $Type : 'UI.DataField',
            Value : impact,
            Criticality : criticality,
            Label : '{i18n>Impacto}',
            ![@HTML5.CssDefaults] : {
                width : '7%',
            },
        },
        {
            $Type : 'UI.DataField',
            Value : status,
            Criticality : status,
            Label : '{i18n>Status}',
            ![@HTML5.CssDefaults] : {
                width : '5%',
            },
        },
    ]
);
annotate RiskService.Risks with {
    prio @(Common.ValueList : {
            Label : '{i18n>PrioridadeVh}',
            CollectionPath : 'Risks',
            Parameters : [
                {
                    $Type : 'Common.ValueListParameterInOut',
                    LocalDataProperty : prio,
                    ValueListProperty : 'prio',
                },
            ],
        },
        Common.Label : '{i18n>Prioridade}'
)};
annotate RiskService.Risks with {
    impact @Common.Label : '{i18n>Impacto}'
};
annotate RiskService.Risks with {
    criticality @Common.Label : '{i18n>Criticidade}'
};
annotate RiskService.Risks with @(
    UI.Facets : [
        {
            $Type : 'UI.ReferenceFacet',
            Label : '{i18n>Mitigao}',
            Target : '@UI.FieldGroup#Main',
        },
    ],
    UI.FieldGroup #Main : {
        $Type : 'UI.FieldGroupType',
        Label : 'Mitigação',
        Data : [
            {
                $Type : 'UI.DataField',
                Value : miti_ID,
                Label : '{i18n>Mitigao}',
            },
            {
                $Type : 'UI.DataField',
                Value : prio,
                Criticality : criticality,
                Label : '{i18n>Prioridade}',
            },
            {
                $Type : 'UI.DataField',
                Value : impact,
                Criticality : criticality,
                Label : '{i18n>Impacto}',
            },
            {
                $Type : 'UI.DataField',
                Value : status,
                Criticality : status,
                Label : '{i18n>Status}',
            },
        ],
    },
    UI.HeaderInfo : {
        TypeName : '{i18n>Risco}',
        TypeNamePlural : '{i18n>Riscos}',
        Title : {
            $Type : 'UI.DataField',
            Value : title,
        },
        Description : {
            $Type : 'UI.DataField',
            Value : descr,
        },
        TypeImageUrl : 'sap-icon://alert',
    }
);
annotate RiskService.Risks with {
    miti @Common.ValueList : {
        Label : '{i18n>Mitigations}',
        CollectionPath : 'Mitigations',
        Parameters : [
            {
                $Type : 'Common.ValueListParameterInOut',
                LocalDataProperty : miti_ID,
                ValueListProperty : 'ID',
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'description',
            },
        ],
    }
};
