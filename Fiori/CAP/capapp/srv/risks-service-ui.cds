using RiskService from './risk-service';

annotate RiskService.Risks with {
    title  @title: 'Título';
    prio   @title: 'Prioridade';
    descr  @title: 'Descrição';
    miti   @title: 'Mitigação';
    impact @title: 'Impacto';
    status @title: 'Status';
    criticality @title: 'Criticidade';
    prio_descr @title: 'Descrição';
}

annotate RiskService.Mitigations with {
    ID          @(
        UI.Hidden,
        Common: {Text: owner}
    );
    owner       @title: 'Author';
    description @title: 'Descrição';   
    timeline    @title: 'Timeline';
    risks       @title: 'Riscos';
}

annotate RiskService.Risks with @(UI: {
    // Cabeçalho da tabela
    HeaderInfo      : {
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
    SelectionFields : [
        prio,
        impact,
        criticality
    ],
    LineItem        : [
        {
            Value                : title,
            ![@HTML5.CssDefaults]: {width: '30%'}
        },
        {
            Value                : descr,
            ![@HTML5.CssDefaults]: {width: '53%'}
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
    Facets          : [{
        $Type : 'UI.ReferenceFacet',
        Label : 'Mitigação',
        Target: '@UI.FieldGroup#Main'
    }],
    FieldGroup #Main: {
        $Type: 'UI.FieldGroupType',
        Label: 'Mitigação',
        Data : [
            {Value: miti_ID},
            {
                Value      : prio,
                Criticality: criticality,
            },
            {
                Value      : impact,
                Criticality: criticality,
            },
            {
                Value      : status,
                Criticality: status,
            }
        ]
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
    prio @(Common: {
        Text: prio_descr,
        TextArrangement: #TextOnly,
        ValueListWithFixedValues : true,
        ValueList: {
            Label: 'Prioridade VH',
            CollectionPath: 'Risks',
            Parameters: [
                {
                    $Type: 'Common.ValueListParameterInOut',
                    LocalDataProperty: prio,
                    ValueListProperty: 'prio'
                }
            ]
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

