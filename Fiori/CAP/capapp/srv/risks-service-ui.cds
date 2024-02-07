using RiskService from './risk-service';

annotate RiskService.Risks with {
    title       @title: 'Título';
    prio        @title: 'Prioridade';
    descr       @title: 'Descrição';
    miti        @title: 'Mitigação';
    impact      @title: 'Impacto';
    status      @title: 'Status';
    bp          @title: 'Parceiro';
    criticality @title: 'Criticidade';
    prio_descr  @title: 'Descrição Prioridade';
}

annotate RiskService.Mitigations with {
    ID          @(
        UI.Hidden,
        Common: {Text: owner}
    );
    owner       @(
        title              : 'Author',
        Common.FieldControl: #ReadOnly
    );
    description @title: 'Descrição';
    timeline    @(
        title              : 'Timeline',
        Common.FieldControl: #ReadOnly
    );
    risks       @title: 'Riscos';
}

annotate RiskService.Risks with @(UI: {
    // Cabeçalho da tabela
    HeaderInfo                        : {
        TypeName      : 'Risco',
        TypeNamePlural: 'Riscos',
        Title         : {
            $Type: 'UI.DataField',
            Value: title
        },
        Description   : {
            $Type: 'UI.DataField',
            Value: descr
        }
    },
    // Campos padrões para o filtro
    SelectionFields                   : [
        prio,
        bp_BusinessPartner,
        criticality
    ],
    LineItem                          : [
        {
            Value                : title,
            ![@HTML5.CssDefaults]: {width: '30%'}
        },
        {
            Value                : descr,
            ![@HTML5.CssDefaults]: {width: '43%'}
        },
        {
            Value                : bp_BusinessPartner,
            ![@HTML5.CssDefaults]: {width: '10%'}
        },
        {
            Value                : prio,
            Criticality          : criticality,
            ![@UI.Importance]    : #High,
            ![@HTML5.CssDefaults]: {width: '5%'}
        },
        {
            Value                : impact,
            Criticality          : criticality,
            ![@HTML5.CssDefaults]: {width: '7%'}
        },
        {
            Value                : status,
            Criticality          : status,
            ![@HTML5.CssDefaults]: {width: '5%'}
        }
    ],
    Facets                            : [
        {
            $Type : 'UI.CollectionFacet',
            Label : 'Risco',
            ID    : 'Risk',
            Facets: [{
                $Type : 'UI.ReferenceFacet',
                Label : 'Detalhes',
                ID    : 'RiskDetails',
                Target: '@UI.FieldGroup#RiskDetails',
            }]
        },
        {
            $Type : 'UI.CollectionFacet',
            Label : 'Mitigação',
            ID    : 'Mitigation',
            Facets: [{
                $Type : 'UI.ReferenceFacet',
                Label : 'Mitigação',
                ID    : 'Mitigacao',
                Target: '@UI.FieldGroup#Main'
            }]
        }
    ],
    FieldGroup #Main                  : {
        $Type: 'UI.FieldGroupType',
        Label: 'Mitigação',
        Data : [
            {
                $Type: 'UI.DataField',
                Value: miti_ID,
                Label: 'ID'
            },
            // Conflit com a annotation miti
            // {
            //     $Type: 'UI.DataField',
            //     Value: miti.description,
            //     Label: '{i18n>Descrio}'
            // },
            {
                $Type: 'UI.DataField',
                Value: miti.owner,
                Label: '{i18n>Author}',
            },
            {
                $Type: 'UI.DataField',
                Value: miti.timeline,
                Label: '{i18n>Timeline}',
            }
        ]
    },
    FieldGroup #RiskDetails           : {
        $Type: 'UI.FieldGroupType',
        Label: 'Detalhes',
        Data : [
            {
                $Type: 'UI.DataField',
                Value: bp_BusinessPartner,
                Label: '{i18n>BusinessPartner}',
            },
            {
                $Type: 'UI.DataField',
                Value: title,
                Label: '{i18n>Ttulo}',
            },
            {
                $Type: 'UI.DataField',
                Value: descr,
                Label: '{i18n>Descrio}',
            },
            {
                $Type: 'UI.DataField',
                Value: prio,
                Criticality: prio,
                Label: '{i18n>Prioridade}',
            },
            {
                $Type: 'UI.DataField',
                Value: impact,
                Label: '{i18n>Impacto}',
            },
            {
                $Type: 'UI.DataField',
                Value: criticality,
                Criticality: criticality,
                Label: '{i18n>Criticidade}}',
            },
            {
                $Type: 'UI.DataField',
                Value: status,
                Criticality: status,
                Label: '{i18n>Status}',
            }
        ],
    },
    PresentationVariant #vh_Risks_prio: {
        $Type    : 'UI.PresentationVariantType',
        SortOrder: [{
            $Type     : 'Common.SortOrderType',
            Property  : prio,
            Descending: true,
        }, ],
    }
});

annotate RiskService.Risks with {
    miti @(Common: {
        //show text, not id for mitigation in the context of risks
        Text           : miti.description,
        TextArrangement: #TextOnly,
        ValueList      : {
            Label         : 'Mitigations',
            CollectionPath: 'Mitigations',
            Parameters    : [
                {
                    $Type            : 'Common.ValueListParameterInOut',
                    LocalDataProperty: miti_ID,
                    ValueListProperty: 'ID'
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'description'
                }
            ]
        }
    });
}

annotate RiskService.Risks with {
    bp @(Common: {
        //show text, not id for mitigation in the context of risks
        Text           : bp.FullName,
        TextArrangement: #TextOnly,
        ValueList      : {
            Label         : 'BusinessPartner',
            CollectionPath: 'BusinessPartners',
            Parameters    : [
                {
                    $Type            : 'Common.ValueListParameterInOut',
                    LocalDataProperty: bp_BusinessPartner,
                    ValueListProperty: 'BusinessPartner'
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'FullName'
                }
            ]
        }
    });
}

annotate RiskService.Risks with {
    prio @(Common: {
        Text                    : prio_descr,
        TextArrangement         : #TextOnly,
        ValueListWithFixedValues: true,
        ValueList               : {
            Label                       : 'Prioridade VH',
            CollectionPath              : 'Risks',
            Parameters                  : [{
                $Type            : 'Common.ValueListParameterInOut',
                LocalDataProperty: prio,
                ValueListProperty: 'prio'
            }],
            PresentationVariantQualifier: 'vh_Risks_prio',
        },
    });
};

// annotate RiskService.Risks with {
//     prio @(Common.ValueList : {
//             $Type : 'Common.ValueListType',
//             CollectionPath : 'Risks',
//             Parameters : [
//                 {
//                     $Type : 'Common.ValueListParameterInOut',
//                     LocalDataProperty : prio,
//                     ValueListProperty : 'prio',
//                 },
//             ],
//             Label : 'Prioridade Value Help',
//             PresentationVariantQualifier : 'vh_Risks_prio',
//         },
//         Common.ValueListWithFixedValues : true,
//         Common.Text : {
//             $value : descr,
//             ![@UI.TextArrangement] : #TextSeparate,
//         }
// )};
// annotate RiskService.Risks with @(
//     UI.PresentationVariant #vh_Risks_prio : {
//         $Type : 'UI.PresentationVariantType',
//         SortOrder : [
//             {
//                 $Type : 'Common.SortOrderType',
//                 Property : prio,
//                 Descending : false,
//             },
//         ],
//     }
// );
