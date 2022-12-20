*&---------------------------------------------------------------------*
*& Report YINFINITFY_PROVA
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT YINFINITFY_PROVA.

**************************************************************************************************************
***	TABELAS	***
**************************************************************************************************************
TABLES: ekko,
        ekpo,
        makt.

**************************************************************************************************************
***	TYPES	***
**************************************************************************************************************
TYPES: BEGIN OF ty_ekko,
         ebeln TYPE ekko-ebeln,
         bukrs TYPE ekko-bukrs,
         aedat TYPE ekko-aedat,
         ernam TYPE ekko-ernam,
       END OF ty_ekko,

       BEGIN OF ty_ekpo,
         ebeln TYPE ekpo-ebeln,
         ebelp TYPE ekpo-ebelp,
         matnr TYPE ekpo-matnr,
         werks TYPE ekpo-werks,
         lgort TYPE ekpo-lgort,
         netpr TYPE ekpo-netpr,
       END OF ty_ekpo,

       BEGIN OF ty_makt,
         matnr TYPE makt-matnr,
         maktx TYPE makt-maktx,
       END OF ty_makt,

       BEGIN OF ty_saida,
         ebeln TYPE ekko-ebeln,
         bukrs TYPE ekko-bukrs,
         aedat TYPE ekko-aedat,
         ernam TYPE ekko-ernam,
         ebelp TYPE ekpo-ebelp,
         matnr TYPE ekpo-matnr,
         lgort TYPE ekpo-lgort,
         netpr TYPE ekpo-netpr,
         maktx TYPE makt-maktx,
       END OF ty_saida.

**************************************************************************************************************
DATA: it_ekko     TYPE TABLE OF ty_ekko,
      it_ekpo     TYPE TABLE OF ty_ekpo,
      it_makt     TYPE TABLE OF ty_makt,
      it_saida    TYPE TABLE OF ty_saida,
      it_fieldcat TYPE lvc_t_fcat.

**************************************************************************************************************
*** WORK AREAS  ***
**************************************************************************************************************
DATA: wa_ekko     TYPE ty_ekko,
      wa_ekpo     TYPE ty_ekpo,
      wa_makt     TYPE ty_makt,
      wa_saida    TYPE ty_saida,
      wa_fieldcat TYPE lvc_s_fcat.


**************************************************************************************************************
*** PARAMETROS DE SELEÇÃO DE DADOS  ***
**************************************************************************************************************
SELECTION-SCREEN: BEGIN OF BLOCK b_main WITH FRAME TITLE TEXT-001.

  SELECT-OPTIONS: so_ebeln FOR ekko-ebeln,
                    so_matnr FOR ekpo-matnr.

SELECTION-SCREEN: END OF BLOCK b_main.

* START-OF-SELECTION
START-OF-SELECTION.
  PERFORM: z_selecionar_dados,
            z_processar_dados.

* END-OF-SELECTION
ENd-OF-SELECTION.
  IF it_saida IS NOT INITIAL.
    PERFORM: z_preencher_fieldcat,
              z_exibir_relatorio.
  ELSE.
    MESSAGE s208(00) DISPLAY LIKE sy-abcde+4(1) WITH TEXT-002. "Seleção de dados falhou
  ENDIF.

*&---------------------------------------------------------------------*
*&      Form  Z_SELECIONA_DADOS
*&---------------------------------------------------------------------*
*   SELECIONA OS DADOS A SEREM EXIBIDOS PELO RELATÓRIO
*----------------------------------------------------------------------*
FORM z_selecionar_dados.

  IF so_ebeln[] IS NOT INITIAL AND so_matnr[] IS NOT INITIAL.

    SELECT ebeln
            bukrs
            aedat
            ernam
      FROM ekko
      INTO TABLE it_ekko
      WHERE ebeln IN so_EBELN.
    IF sy-subrc EQ 0.

      SELECT ebeln
              ebelp
              matnr
              werks
              lgort
              netpr
        FROM ekpo
        INTO TABLE it_ekpo
        FOR ALL ENTRIES IN it_ekko
        WHERE ebeln EQ it_ekko-ebeln AND matnr IN so_matnr.
      IF sy-subrc EQ 0.

        SELECT matnr
                maktx
          FROM makt
          INTO TABLE it_makt
          FOR ALL ENTRIES IN it_ekpo
          WHERE matnr EQ it_ekpo-matnr.

      ENDIF.

    ENDIF.


  ENDIF.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  Z_PROCESSA_DADOS
*&---------------------------------------------------------------------*
*   FORMA INFORMAÇÕES PARA RELATÓRIO
*---------------------------I-------------------------------------------*
FORM z_processar_dados.

  SORT: it_ekko BY ebeln,
         it_ekpo BY ebeln ebelp,
         it_makt BY matnr.

  LOOP AT it_ekko INTO wa_ekko.

    LOOP AT it_ekpo INTO wa_ekpo.

      CLEAR: wa_saida.

      wa_saida-ebeln = wa_ekko-ebeln.
      wa_saida-bukrs = wa_ekko-bukrs.
      wa_saida-aedat = wa_ekko-aedat.
      wa_saida-ernam = wa_ekko-ernam.

      IF wa_ekpo-ebeln EQ wa_ekko-ebeln.

        wa_saida-ebelp = wa_ekpo-ebelp.
        wa_saida-matnr = wa_ekpo-matnr.
        wa_saida-lgort = wa_ekpo-lgort.
        wa_saida-netpr = wa_ekpo-netpr.

        READ TABLE it_makt INTO wa_makt WITH KEY matnr = wa_ekpo-matnr
                                                     BINARY SEARCH.

        IF sy-subrc EQ 0.

          wa_saida-maktx = wa_makt-maktx.

          APPEND wa_saida TO it_saida.
          CLEAR: wa_makt.
        ENDIF.

        CLEAR: wa_ekpo.

      ENDIF.

    ENDLOOP.

    CLEAR: wa_ekko.

  ENDLOOP.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  Z_PREENCHE_FIELDCAT
*&---------------------------------------------------------------------*
*   PREENCHE TABELA DE FIELDCAT PARA RELATÓRIO
*----------------------------------------------------------------------*
FORM z_preencher_fieldcat.

* Campos da tabela ekko.
  CLEAR: wa_fieldcat.
  wa_fieldcat-fieldname = 'EBELN'.
  wa_fieldcat-scrtext_m = 'Nº do documento de compras'.
  APPEND wa_fieldcat TO it_fieldcat.

  CLEAR: wa_fieldcat.
  wa_fieldcat-fieldname = 'BUKRS'.
  wa_fieldcat-scrtext_m = 'Empresa'.
  APPEND wa_fieldcat TO it_fieldcat.

  CLEAR: wa_fieldcat.
  wa_fieldcat-fieldname = 'AEDAT'.
  wa_fieldcat-scrtext_m = 'Data de criação do registro'.
  APPEND wa_fieldcat TO it_fieldcat.

  CLEAR: wa_fieldcat.
  wa_fieldcat-fieldname = 'ERNAM'.
  wa_fieldcat-scrtext_m = 'Nome do responsável que criou o objeto'.
  APPEND wa_fieldcat TO it_fieldcat.

* Campos da tabela ekpo.
  CLEAR: wa_fieldcat.
  wa_fieldcat-fieldname = 'EBELP'.
  wa_fieldcat-scrtext_m = 'Nº item do documento de compra'.
  APPEND wa_fieldcat TO it_fieldcat.

  CLEAR: wa_fieldcat.
  wa_fieldcat-fieldname = 'MATNR'.
  wa_fieldcat-scrtext_m = 'Nº do material'.
  APPEND wa_fieldcat TO it_fieldcat.

  CLEAR: wa_fieldcat.
  wa_fieldcat-fieldname = 'WERKS'.
  wa_fieldcat-scrtext_m = 'Centro'.
  APPEND wa_fieldcat TO it_fieldcat.

  CLEAR: wa_fieldcat.
  wa_fieldcat-fieldname = 'LGORT'.
  wa_fieldcat-scrtext_m = 'Depósito'.
  APPEND wa_fieldcat TO it_fieldcat.

  CLEAR: wa_fieldcat.
  wa_fieldcat-fieldname = 'NETPR'.
  wa_fieldcat-scrtext_m = 'Preço líquido no documento de compra na moeda do documento'.
  APPEND wa_fieldcat TO it_fieldcat.

* Campos da tabela makt.
  CLEAR: wa_fieldcat.
  wa_fieldcat-fieldname = 'MAKTX'.
  wa_fieldcat-scrtext_m = 'Texto breve de material'.
  APPEND wa_fieldcat TO it_fieldcat.

ENDFORM.

FORM z_exibir_relatorio.

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
      t_outtab           = it_saida
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
  IF sy-subrc NE 0.
    MESSAGE s208(00) DISPLAY LIKE sy-abcde+4(1) WITH TEXT-003. "Exibição de dados falhou
  ENDIF.

ENDFORM.