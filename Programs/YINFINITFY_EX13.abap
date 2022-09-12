*&---------------------------------------------------------------------*
*& Report ZPG_SP_EX13                                                  *
*&                                                                     *
*& Faça uma rotina que receba uma workarea e some todos os seus campos *
*& numéricos (a workarea deve conter no mínimo 3 campos deste tipo)    *
*&---------------------------------------------------------------------*

REPORT yinfinitfy_ex13.

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
      lt_components   TYPE cl_abap_structdescr=>component_table,
      descr_ref       TYPE REF TO cl_abap_typedescr.

FIELD-SYMBOLS: <ls_comp>  LIKE LINE OF lt_components,
               <fs_field> TYPE any.


START-OF-SELECTION.
  PERFORM inserir_pessoa USING '0000000001' 'Sérgio' '64.5' 24 '00000000' wa_pessoas.

  PERFORM sum_numeric_fields USING wa_pessoas.

FORM inserir_pessoa USING p_registro p_nome p_peso  p_idade p_data wa_pessoas TYPE ty_pessoas.

  wa_pessoas-registro = p_registro.
  wa_pessoas-nome = p_nome.
  wa_pessoas-peso = p_peso.
  wa_pessoas-idade = p_idade.
  wa_pessoas-data = p_data.
  APPEND wa_pessoas TO it_pessoas.

ENDFORM.

FORM sum_numeric_fields USING wa_pessoas TYPE ty_pessoas.

  LOOP AT it_pessoas INTO wa_pessoas.
    DATA null_fields TYPE p DECIMALS 2.

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

      descr_ref = cl_abap_typedescr=>describe_by_data( <fs_field> ).

      IF descr_ref->type_kind CA 'IPN'.
        null_fields = null_fields + <fs_field>.
      ENDIF.

      WRITE: / 'Field name:', <ls_comp>-name.

      WRITE: / 'Value:', <fs_field>.

      WRITE: / 'Typename:', descr_ref->absolute_name.

      WRITE: / 'Kind:', descr_ref->type_kind.

      WRITE: / 'Length:', descr_ref->length.

      WRITE: / 'Decimals:', descr_ref->decimals.

      ULINE.
    ENDDO.

    WRITE: 'Soma dos campos números:', null_fields, /.
    ULINE.

  ENDLOOP.

ENDFORM.