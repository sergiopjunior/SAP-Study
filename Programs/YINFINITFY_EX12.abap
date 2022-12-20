*&---------------------------------------------------------------------*
*& Report ZPG_SP_EX12                                                  *
*&                                                                     *
*& Faça uma rotina que receba uma workarea contendo 5 tipos de dados   *
*& diferentes e conte quantos campos não estão preenchidos. Imprimir   *
*& resultado.                                                          *
*&---------------------------------------------------------------------*

REPORT yinfinitfy_ex12.

TYPES: BEGIN OF ty_pessoas,
         registro TYPE numc10,                              "1234567890
         nome     TYPE char20, "Sérgio
         peso     TYPE p DECIMALS 2, "63.65
         idade    TYPE i, "17
         data     TYPE dats, "YYYYMMDD
       END OF ty_pessoas.

DATA: it_pessoas      TYPE TABLE OF ty_pessoas,
      wa_pessoas      LIKE LINE OF it_pessoas,
      lro_structdescr TYPE REF TO cl_abap_structdescr,
      lt_components   TYPE cl_abap_structdescr=>component_table.

FIELD-SYMBOLS: <ls_comp>  LIKE LINE OF lt_components,
               <fs_field> TYPE any.


START-OF-SELECTION.
  PERFORM inserir_pessoa USING '' 'Sérgio' '64.5' 24 '00000000' wa_pessoas.
  PERFORM inserir_pessoa USING '4264586241' 'Cristina' '' 17 '20220715' wa_pessoas.
  PERFORM inserir_pessoa USING '' 'Vera' '53.42' '' '00000000'  wa_pessoas.

  PERFORM count_empty_fields USING wa_pessoas.

FORM inserir_pessoa USING p_registro p_nome p_peso  p_idade p_data wa_pessoas TYPE ty_pessoas.

  wa_pessoas-registro = p_registro.
  wa_pessoas-nome = p_nome.
  wa_pessoas-peso = p_peso.
  wa_pessoas-idade = p_idade.
  wa_pessoas-data = p_data.
  APPEND wa_pessoas TO it_pessoas.

ENDFORM.

FORM count_empty_fields USING wa_pessoas TYPE ty_pessoas.

  LOOP AT it_pessoas INTO wa_pessoas.
    DATA(null_fields) = 0.
    IF lt_components IS INITIAL.  "get columns' names only once.
      lro_structdescr ?= cl_abap_typedescr=>describe_by_data( wa_pessoas ).
      lt_components = lro_structdescr->get_components( ).
    ENDIF.

    DO. "iterate all columns in the row
      ASSIGN COMPONENT sy-index OF STRUCTURE wa_pessoas TO <fs_field>.
      IF sy-subrc <> 0.
        EXIT.
      ENDIF.

      READ TABLE lt_components ASSIGNING <ls_comp> INDEX sy-index.


      IF <fs_field> IS INITIAL.
        ADD 1 TO null_fields.
      ENDIF.
      WRITE: <ls_comp>-name, <fs_field>, /.
    ENDDO.
    WRITE: 'Número de campos vazios:', null_fields, /.
    ULINE.

  ENDLOOP.


ENDFORM.