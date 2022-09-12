*&---------------------------------------------------------------------*
*& Report ZPG_SP_EX14
*&                                                                     *
*& Faça uma rotina que receba uma workarea com 3 campos string ou      *
*& caracteres e 3 campos numéricos (usar 3 tipos numéricos diferentes) *
*& e limpe o conteúdo de seus campos de acordo com as seguintes        *
*& regras:                                                             *
*& A. Limpar somente os campos texto caso a soma dos campos            *
*& numéricos for ímpar (desconsiderar possíveis casas decimais);       *
*& B. Limpar somente campos numéricos caso a soma de vogais dos 3      *
*& campos texto for par;                                               *
*&---------------------------------------------------------------------*

REPORT yinfinitfy_ex14.

TYPES: BEGIN OF ty_pessoas,
         registro  TYPE numc10,                             "1234567890
         nome      TYPE char20, "Sérgio
         sobrenome TYPE char64,
         email     TYPE char40,
         peso      TYPE p DECIMALS 2, "63.65
         idade     TYPE i, "17
       END OF ty_pessoas.

DATA: it_pessoas                TYPE TABLE OF ty_pessoas,
      wa_pessoas                LIKE LINE OF it_pessoas,
      lro_structdescr           TYPE REF TO cl_abap_structdescr,
      lt_components             TYPE cl_abap_structdescr=>component_table,
      descr_ref                 TYPE REF TO cl_abap_typedescr,
      v_num_fields_sum          TYPE i VALUE 0,
      v_txt_fields_vowels_count TYPE i VALUE 0,
      go_alv                    TYPE REF TO  cl_salv_table,
      gx_salv_msg               TYPE REF TO  cx_salv_msg.

FIELD-SYMBOLS: <ls_comp>  LIKE LINE OF lt_components,
               <fs_field> TYPE any.


START-OF-SELECTION.
  PERFORM inserir_pessoa USING '0000000011' 'Sérgio' 'Pontes' 'test@gmail.com' '63.65' 24 wa_pessoas.

  PERFORM sum_fields USING wa_pessoas CHANGING v_num_fields_sum v_txt_fields_vowels_count.

  PERFORM clear_fields USING v_num_fields_sum v_txt_fields_vowels_count CHANGING wa_pessoas.

  PERFORM exibir_dados USING wa_pessoas.


FORM exibir_dados USING wa_pessoas TYPE ty_pessoas.
  TRY.
      cl_salv_table=>factory(
      IMPORTING
        r_salv_table = go_alv
      CHANGING
        t_table = it_pessoas ).
    CATCH cx_salv_msg INTO gx_salv_msg.
      MESSAGE 'error' TYPE 'E'.
  ENDTRY.

  go_alv->display( ).
ENDFORM.


FORM inserir_pessoa USING p_registro p_nome p_sobrenome p_email p_peso p_idade wa_pessoas TYPE ty_pessoas.

  wa_pessoas-registro = p_registro.
  wa_pessoas-nome = p_nome.
  wa_pessoas-sobrenome = p_sobrenome.
  wa_pessoas-email = p_email.
  wa_pessoas-peso = p_peso.
  wa_pessoas-idade = p_idade.
  APPEND wa_pessoas TO it_pessoas.

ENDFORM.

FORM sum_fields USING wa_pessoas TYPE ty_pessoas CHANGING v_num_fields_sum v_txt_fields_vowels_count.

  LOOP AT it_pessoas INTO wa_pessoas.

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
        v_num_fields_sum = v_num_fields_sum + <fs_field>.

      ELSE.
        DATA(len) = strlen( <fs_field> ).

        WHILE sy-index <= len.
          DATA(index) = sy-index - 1.

          DATA temp TYPE char255.
          temp = <fs_field>.
          TRANSLATE temp TO UPPER CASE.

          IF temp+index(1)  CA'AEIOUÉÃ'.
            ADD 1 TO v_txt_fields_vowels_count.
          ENDIF.

        ENDWHILE.

      ENDIF.

      PERFORM print_field_data USING <ls_comp>-name <fs_field> descr_ref->type_kind.
      ULINE.

    ENDDO.

    WRITE: 'Soma dos campos números:', v_num_fields_sum, /.
    WRITE: 'Soma das vogais dos campos texto:', v_txt_fields_vowels_count, /.
    ULINE.

  ENDLOOP.

ENDFORM.

FORM clear_fields USING p_num_sum p_vowel_sum wa_pessoas TYPE ty_pessoas.

  LOOP AT it_pessoas INTO wa_pessoas.

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

      IF p_num_sum MOD 2 <> 0 AND descr_ref->type_kind NA 'IPN'.
        WRITE: 'Limpando campo texto', <ls_comp>-name, /.
        wa_pessoas-nome = ''.
        wa_pessoas-sobrenome = ''.
        wa_pessoas-email = ''.
      ELSEIF p_vowel_sum MOD 2 = 0 AND descr_ref->type_kind CA 'IPN'.
        WRITE: 'Limpando campo numérico', <ls_comp>-name, /.
        wa_pessoas-registro = ''.
        wa_pessoas-peso = ''.
        wa_pessoas-idade = 0.
      ELSE.
        WRITE: 'None', <ls_comp>-name, /.
      ENDIF.

    ENDDO.

    MODIFY it_pessoas FROM wa_pessoas.
  ENDLOOP.

ENDFORM.

FORM print_field_data USING p_ls_comp p_fs_field p_type_kind.

  DATA: msg  TYPE string,
        temp TYPE string.

  CONCATENATE 'Field:' p_ls_comp INTO msg SEPARATED BY space.

  MOVE p_fs_field TO temp.
  CONCATENATE '|' 'Value:' temp INTO temp SEPARATED BY space.
  CONCATENATE msg temp INTO msg SEPARATED BY space.

  CONCATENATE '|' 'Type:' p_type_kind INTO temp SEPARATED BY space.
  CONCATENATE msg temp INTO msg SEPARATED BY space.

  WRITE: msg.

ENDFORM.