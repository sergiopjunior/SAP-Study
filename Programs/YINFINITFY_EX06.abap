*&---------------------------------------------------------------------*
*& Report ZPG_SP_EX06                                                  *
*& Exercício 6 da Apostila-ABAP:                                       *
*& Faça uma rotina (FORM) que imprima o username de todas as pessoas   *
*& de do treinamento (Veja a tabela USR04 na SE11 e seu conteúdo)      *
*&---------------------------------------------------------------------*

REPORT YINFINITFY_EX06.

TYPES: BEGIN OF ty_usr04,
         bname TYPE xubname,
       END OF ty_usr04.

DATA: it_users    TYPE TABLE OF ty_usr04,
      it_fieldcat TYPE lvc_t_fcat.

DATA: wa_usr04    TYPE usr04,
      wa_fieldcat TYPE lvc_s_fcat.

START-OF-SELECTION.
  PERFORM get_dados.

END-of-SELECTION.
  IF it_users IS NOT INITIAL.
    PERFORM: feed_fieldcat,
              display_data.
  ENDIF.

FORM get_dados.

  SELECT bname FROM usr04 INTO TABLE it_users.
  SORT: it_users BY bname.

ENDFORM.

FORM feed_fieldcat.

  CLEAR: wa_fieldcat.
  wa_fieldcat-fieldname = 'bname'.
  wa_fieldcat-scrtext_m = 'Usuarios'.
  APPEND wa_fieldcat TO it_fieldcat.

ENDFORM.

FORM display_data.
  DATA: wa_layout TYPE lvc_s_layo,
        wa_vari   TYPE disvariant.

  wa_layout-zebra = abap_true.
  wa_layout-cwidth_opt = abap_true.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY_LVC'
    EXPORTING
      i_callback_program = sy-repid
      is_layout_lvc      = wa_layout
      it_fieldcat_lvc    = it_fieldcat
    TABLES
      t_outtab           = it_users
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
  IF sy-subrc NE 0.
    MESSAGE s208(00) DISPLAY LIKE sy-abcde+4(1) WITH TEXT-003.
  ENDIF.

ENDFORM.