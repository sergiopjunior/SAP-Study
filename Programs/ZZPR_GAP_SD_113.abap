<<<<<<< HEAD
*&---------------------------------------------------------------------------*
*&  REPORT           ZPR_GAP_SD_113.
*&---------------------------------------------------------------------------*
*& Nome: ZFM_CONSUME_BIGDATA
*& Tipo: Report
*& Objetivo: Envio dos dados dos vendedores e representantes de vendas de
*& acessórios para a PST.
*& Data/Hora: Sexta, Setembro 16, 2022 (GMT-3) - 10:15
*& Desenvolvedor: Sérgio Pontes (Grupo Real)
*&---------------------------------------------------------------------------*
*& Versão 1: Sérgio Pontes (Grupo Real) - Inicio Desenvolvimento - DS4K905250
*& Versão 2: ?
*& Versão 3: ?
*&---------------------------------------------------------------------------*
REPORT zpr_gap_sd_113.

****************
***	INCLUDES ***
****************
INCLUDE zic_exconv.

**************
***	TABLES ***
**************
TABLES:
  kna1,
  j_1bnfdoc.

***************
***	 TYPES  ***
***************
TYPES: BEGIN OF ty_clientes,
         kunnr      TYPE kna1-kunnr,
         name1      TYPE kna1-name1,
         addrnumber TYPE adrc-addrnumber,
         street     TYPE adrc-street,
         city1      TYPE adrc-city1,
         post_code1 TYPE adrc-post_code1,
         city2      TYPE adrc-city2,
         region     TYPE adrc-region,
         country    TYPE adrc-country,
         tel_number TYPE adrc-tel_number,
         stcd1      TYPE kna1-stcd1,
         stcd3      TYPE kna1-stcd3,
         stcd2      TYPE kna1-stcd2,
         house_num1 TYPE adrc-house_num1,
         house_num2 TYPE adrc-house_num2,
         txjcd      TYPE j_1bnfdoc-txjcd,
       END OF ty_clientes,

       BEGIN OF ty_fat_diario,
         stcd1    TYPE kna1-stcd1, " CNPJ
         stcd2    TYPE kna1-stcd2, " CPF
         nfenum   TYPE j_1bnfdoc-nfenum,
         series   TYPE j_1bnfdoc-series,
         docnum   TYPE j_1bnfdoc-docnum,
         nftot    TYPE j_1bnfdoc-nftot,
         taxval   TYPE j_1bnfstx-taxval,
         refkey   TYPE j_1bnflin-refkey,
         cod_repr TYPE knvp-parvw,
         cod_vend TYPE knvp-parvw,
         cod_dist TYPE knvp-parvw,
         cgc      TYPE j_1bnfdoc-cgc,
       END OF ty_fat_diario,

       BEGIN OF ty_prod_fat_nf,
         nfenum TYPE j_1bnfdoc-nfenum,
         series TYPE j_1bnfdoc-series,
         docnum TYPE j_1bnfdoc-docnum,
         credat TYPE j_1bnfdoc-credat,
         matnr  TYPE j_1bnflin-matnr,
         menge  TYPE j_1bnflin-menge,
         nftot  TYPE j_1bnfdoc-nftot,
         cgc    TYPE j_1bnfdoc-cgc,
       END OF ty_prod_fat_nf,

       BEGIN OF ty_header,
         line(50) TYPE c,
       END OF ty_header,

       BEGIN OF ty_txt,
         line(245) TYPE c,
       END OF ty_txt.

*************************
***	 INTERNAL TABLES  ***
*************************
DATA: it_clientes    TYPE TABLE OF ty_clientes ##NEEDED,
      it_fat_diario  TYPE TABLE OF ty_fat_diario ##NEEDED,
      it_prod_fat_nf TYPE TABLE OF ty_prod_fat_nf ##NEEDED,
      it_header      TYPE TABLE OF ty_header ##NEEDED,
      it_txt         TYPE TABLE OF ty_txt ##NEEDED.

***************
*  CONSTANTS  *
***************
CONSTANTS:  gc_cod_dist TYPE knvp-parvw VALUE 'P5'.

***************
*  VARIÁVEIS  *
***************
DATA: gv_path      TYPE string ##NEEDED,
      gv_sem_dados TYPE flag VALUE abap_false ##NEEDED.

***************************************
*** PARAMETROS DE SELEÇÃO DE DADOS  ***
***************************************
SELECTION-SCREEN: BEGIN OF BLOCK b_main WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS: s_kunnr FOR kna1-kunnr,
                  s_docnum FOR j_1bnfdoc-docnum.

  SELECTION-SCREEN SKIP.
  SELECTION-SCREEN: BEGIN OF BLOCK b_radiobuttons WITH FRAME TITLE TEXT-002.

    SELECTION-SCREEN BEGIN OF LINE.
      PARAMETERS: p_cli RADIOBUTTON GROUP rad1 DEFAULT 'X'.
      SELECTION-SCREEN COMMENT 3(16) TEXT-rb1.
    SELECTION-SCREEN END OF LINE.

    SELECTION-SCREEN BEGIN OF LINE.
      PARAMETERS: p_fat RADIOBUTTON GROUP rad1.
      SELECTION-SCREEN COMMENT 3(20) TEXT-rb2.
    SELECTION-SCREEN END OF LINE.

    SELECTION-SCREEN BEGIN OF LINE.
      PARAMETERS: p_not RADIOBUTTON GROUP rad1.
      SELECTION-SCREEN COMMENT 3(34) TEXT-rb3.
    SELECTION-SCREEN END OF LINE.

  SELECTION-SCREEN: END OF BLOCK b_radiobuttons.

  SELECTION-SCREEN: BEGIN OF BLOCK b_visualizacao WITH FRAME TITLE TEXT-003.

    PARAMETERS: p_file TYPE rlgrap-filename.

    SELECTION-SCREEN: SKIP.

    SELECTION-SCREEN BEGIN OF LINE.
      PARAMETERS: p_txt RADIOBUTTON GROUP rad2 DEFAULT 'X' USER-COMMAND rd2.
      SELECTION-SCREEN COMMENT 3(26) TEXT-rb4.
    SELECTION-SCREEN END OF LINE.

    SELECTION-SCREEN BEGIN OF LINE.
      PARAMETERS: p_xls RADIOBUTTON GROUP rad2.
      SELECTION-SCREEN COMMENT 3(27) TEXT-rb5.
    SELECTION-SCREEN END OF LINE.

    SELECTION-SCREEN BEGIN OF LINE.
      PARAMETERS: p_alv RADIOBUTTON GROUP rad2.
      SELECTION-SCREEN COMMENT 3(13) TEXT-rb6.
    SELECTION-SCREEN END OF LINE.

    SELECTION-SCREEN BEGIN OF LINE.
      PARAMETERS: p_txt_sv RADIOBUTTON GROUP rad2.
      SELECTION-SCREEN COMMENT 3(38) TEXT-rb7.
    SELECTION-SCREEN END OF LINE.

    SELECTION-SCREEN BEGIN OF LINE.
      PARAMETERS: p_xls_sv RADIOBUTTON GROUP rad2.
      SELECTION-SCREEN COMMENT 3(39) TEXT-rb8.
    SELECTION-SCREEN END OF LINE.

    SELECTION-SCREEN BEGIN OF LINE.
      PARAMETERS: p_cds_v RADIOBUTTON GROUP rad2.
      SELECTION-SCREEN COMMENT 3(8) TEXT-rb9.
    SELECTION-SCREEN END OF LINE.

  SELECTION-SCREEN: END OF BLOCK b_visualizacao.

SELECTION-SCREEN: END OF BLOCK b_main.

* AT SELECTION-SCREEN OUTPUT
AT SELECTION-SCREEN OUTPUT.
  LOOP AT SCREEN.
    IF screen-name EQ 'P_FILE'.
      screen-input = COND #( WHEN p_txt = abap_true OR p_xls = abap_true THEN 1 ELSE 0 ).
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.


* AT SELECTION-SCREEN
AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.
  CALL METHOD cl_gui_frontend_services=>directory_browse
    CHANGING
      selected_folder      = gv_path
    EXCEPTIONS
      cntl_error           = 1
      error_no_gui         = 2
      not_supported_by_gui = 3
      OTHERS               = 4.

  IF sy-subrc <> 0.
    CLEAR: p_file, gv_path.
  ELSE.
    p_file = gv_path.
  ENDIF.

* START-OF-SELECTION
START-OF-SELECTION.
  gv_path = COND #( WHEN gv_path IS INITIAL THEN p_file ELSE gv_path ).
  PERFORM: zf_limpar_tabelas.

  IF p_cds_v IS NOT INITIAL.
    PERFORM zf_processar_cds_view.
  ELSE.
    PERFORM zf_processar_dados.
  ENDIF.

* END-OF-SELECTION
END-OF-SELECTION.
  FIELD-SYMBOLS: <lfs_it_output> TYPE STANDARD TABLE,
                 <lfs_wa_output> TYPE any.

  IF gv_sem_dados IS INITIAL.
    IF p_cli IS NOT INITIAL.
      DATA lw_clientes TYPE ty_clientes.
      ASSIGN it_clientes TO <lfs_it_output>.
      ASSIGN lw_clientes TO <lfs_wa_output>.
    ELSEIF p_fat IS NOT INITIAL.
      DATA lw_fat_diario TYPE ty_fat_diario.
      ASSIGN it_fat_diario TO <lfs_it_output>.
      ASSIGN lw_fat_diario TO <lfs_wa_output>.
    ELSE.
      DATA lw_prod_fat_nf TYPE ty_prod_fat_nf.
      ASSIGN it_prod_fat_nf TO <lfs_it_output>.
      ASSIGN lw_prod_fat_nf TO <lfs_wa_output>.
    ENDIF.

    PERFORM zf_gerar_path.

    IF p_txt IS NOT INITIAL.
      PERFORM: zf_criar_arquivo_pst,
                zf_salvar_arquivo_local TABLES it_txt USING abap_false.

    ELSEIF p_xls IS NOT INITIAL.
      PERFORM: zf_criar_heading_excel,
               zf_salvar_arquivo_local TABLES <lfs_it_output> USING abap_true.

    ELSEIF p_txt_sv IS NOT INITIAL.
      PERFORM: zf_criar_arquivo_pst,
               zf_salvar_arquivo_servidor TABLES it_txt USING abap_false.
    ELSEIF p_xls_sv IS NOT INITIAL.
      PERFORM: zf_criar_heading_excel,
               zf_salvar_arquivo_servidor TABLES <lfs_it_output> USING abap_false.
    ELSEIF p_alv IS NOT INITIAL.
      PERFORM: zf_exibir_alv TABLES <lfs_it_output> USING <lfs_wa_output>.
    ELSEIF p_cds_v IS NOT INITIAL.

    ENDIF.
  ELSE.
    MESSAGE s208(00) DISPLAY LIKE sy-abcde+4(1) WITH TEXT-e02.
  ENDIF.


*--------------------------------------------------------*
*                Form  ZF_LIMPAR_TABELAS                 *
*--------------------------------------------------------*
*              LIMPA AS TABELAS DO REPORT                *
*--------------------------------------------------------*
FORM zf_limpar_tabelas.
  FREE: it_clientes,
        it_fat_diario,
        it_prod_fat_nf,
        it_header,
        it_txt.
ENDFORM.

*--------------------------------------------------------*
*               Form  ZF_PROCESSAR_DADOS                 *
*--------------------------------------------------------*
* SELECIONA E PROCESSA OS DADOS A SEREM EXIBIDOS PELO    *
* RELATÓRIO                                              *
*--------------------------------------------------------*
FORM zf_processar_dados.
  IF p_cli IS NOT INITIAL.
* Parte de seleção de dados
    SELECT kunnr,
           name1,
           stcd1,
           stcd2,
           stcd3,
           adrnr,
           txjcd
      FROM kna1
      INTO TABLE @DATA(it_kna1)
      WHERE kunnr IN @s_kunnr.

    IF sy-subrc EQ 0.

      SELECT  addrnumber,
              date_from,
              nation,
              street,
              city1,
              post_code1,
              city2,
              region,
              country,
              tel_number,
              house_num1,
              house_num2
        FROM adrc
        INTO TABLE @DATA(it_adrc)
        FOR ALL ENTRIES IN @it_kna1
        WHERE addrnumber EQ @it_kna1-adrnr.

    ENDIF.
* Parte de processamento de dados
    SORT: it_adrc BY addrnumber date_from nation.

    LOOP AT it_kna1 ASSIGNING FIELD-SYMBOL(<lfs_wa_kna1>).
      APPEND INITIAL LINE TO it_clientes ASSIGNING FIELD-SYMBOL(<lfs_wa_clientes>).

      <lfs_wa_clientes>-kunnr = <lfs_wa_kna1>-kunnr.
      <lfs_wa_clientes>-name1 = <lfs_wa_kna1>-name1.
      <lfs_wa_clientes>-addrnumber = <lfs_wa_kna1>-adrnr.
      <lfs_wa_clientes>-stcd1 = <lfs_wa_kna1>-stcd1.
      <lfs_wa_clientes>-stcd3 = <lfs_wa_kna1>-stcd3.
      <lfs_wa_clientes>-stcd2 = <lfs_wa_kna1>-stcd2.
      <lfs_wa_clientes>-txjcd = <lfs_wa_kna1>-txjcd.

      READ TABLE it_adrc INTO DATA(wa_adrc) WITH KEY addrnumber = <lfs_wa_kna1>-adrnr BINARY SEARCH.

      IF sy-subrc EQ 0.
        <lfs_wa_clientes>-street  =   wa_adrc-street.
        <lfs_wa_clientes>-city1  =    wa_adrc-city1.
        <lfs_wa_clientes>-post_code1 = wa_adrc-post_code1.
        <lfs_wa_clientes>-city2 = wa_adrc-city2.
        <lfs_wa_clientes>-region = wa_adrc-region.
        <lfs_wa_clientes>-country = wa_adrc-country.
        <lfs_wa_clientes>-tel_number = wa_adrc-tel_number.
        <lfs_wa_clientes>-house_num1 = wa_adrc-house_num1.
        <lfs_wa_clientes>-house_num2 = wa_adrc-house_num2.

        CLEAR: wa_adrc.
      ENDIF.

    ENDLOOP.
    gv_sem_dados = COND #( WHEN it_clientes IS INITIAL THEN abap_true ELSE abap_false ).
  ELSEIF p_fat IS NOT INITIAL.
*
* Código ´do relatório de Faturamento Diário
*
    gv_sem_dados = COND #( WHEN it_fat_diario IS INITIAL THEN abap_true ELSE abap_false ).
  ELSE.
* Parte de seleção de dados
    SELECT docnum,
           credat,
           nfenum,
           series,
           nftot,
           zterm,
           parvw,
           cgc,
           txjcd
      FROM j_1bnfdoc
      INTO TABLE @DATA(it_j_1bnfdoc)
      WHERE docnum IN @s_docnum.

    IF sy-subrc EQ 0.
      SELECT docnum,
             itmnum,
             matnr,
             menge,
             refkey
        FROM j_1bnflin
        INTO TABLE @DATA(it_j_1bnflin)
        FOR ALL ENTRIES IN @it_j_1bnfdoc
        WHERE docnum EQ @it_j_1bnfdoc-docnum.

      IF sy-subrc EQ 0.
        SELECT docnum,
               itmnum,
               taxtyp,
               taxval
          FROM j_1bnfstx
          INTO TABLE @DATA(it_j_1bnfstx)
          FOR ALL ENTRIES IN @it_j_1bnflin
          WHERE docnum EQ @it_j_1bnflin-docnum AND itmnum EQ @it_j_1bnflin-itmnum.

      ENDIF.
    ENDIF.
* Parte de processamento de dados
    SORT: it_j_1bnfdoc BY docnum,
          it_j_1bnflin BY docnum itmnum,
          it_j_1bnfstx BY docnum itmnum taxtyp.

    LOOP AT it_j_1bnflin ASSIGNING FIELD-SYMBOL(<lfs_wa_j_1bnflin>).
      APPEND INITIAL LINE TO it_prod_fat_nf ASSIGNING FIELD-SYMBOL(<lfs_wa_prod_fat_nf>).

      READ TABLE it_j_1bnfdoc INTO DATA(wa_j_1bnfdoc) WITH KEY docnum = <lfs_wa_j_1bnflin>-docnum
                                                                              BINARY SEARCH.
      IF sy-subrc EQ 0.
        <lfs_wa_prod_fat_nf>-nfenum = wa_j_1bnfdoc-nfenum.
        <lfs_wa_prod_fat_nf>-series = wa_j_1bnfdoc-series.
        <lfs_wa_prod_fat_nf>-docnum = wa_j_1bnfdoc-docnum.
        <lfs_wa_prod_fat_nf>-credat = wa_j_1bnfdoc-credat.
        <lfs_wa_prod_fat_nf>-matnr  = <lfs_wa_j_1bnflin>-matnr.
        <lfs_wa_prod_fat_nf>-menge  = <lfs_wa_j_1bnflin>-menge.
        <lfs_wa_prod_fat_nf>-nftot  = wa_j_1bnfdoc-nftot.
        <lfs_wa_prod_fat_nf>-cgc    = wa_j_1bnfdoc-cgc.
      ENDIF.
      CLEAR: wa_j_1bnfdoc.
    ENDLOOP.
    gv_sem_dados = COND #( WHEN it_prod_fat_nf IS INITIAL THEN abap_true ELSE abap_false ).
  ENDIF.

ENDFORM.

FORM zf_gerar_path.
  DATA: lv_filename TYPE string,
        lv_filetype TYPE string,
        lv_date(6)  TYPE c.

  lv_date = |{ gc_cod_dist }{ sy-datum+6(2) }{ sy-datum+4(2) }{ sy-datum+2(2) }|.

  IF p_cli IS NOT INITIAL.
* TEXT-cli = CLIE
    lv_filename = |{ TEXT-cli }{ gc_cod_dist }{ lv_date }|.
  ELSEIF p_fat IS NOT INITIAL.
* TEXT-fat = FATD
    lv_filename = |{ TEXT-fat }{ gc_cod_dist }{ lv_date }|.
  ELSE.
* TEXT-fan = FATN
    lv_filename = |{ TEXT-fan }{ gc_cod_dist }{ lv_date }|.
  ENDIF.

* TEXT-txt = .txt
* TEXT-xls = .xls
  lv_filetype = COND #( WHEN p_txt IS NOT INITIAL OR p_txt_sv IS NOT INITIAL THEN TEXT-txt ELSE TEXT-xls ).

  IF p_txt_sv IS NOT INITIAL OR p_xls_sv IS NOT INITIAL.
    gv_path = |{ TEXT-svp }{ TEXT-c03 }{ lv_filename }{ TEXT-c02 }{ TEXT-ps1 }{ lv_filetype }|.
  ELSE.
    gv_path = |{ p_file }{ TEXT-c01 }{ lv_filename }{ TEXT-c02 }{ TEXT-ps1 }{ lv_filetype }|.
  ENDIF.

ENDFORM.

*--------------------------------------------------------*
*                 Form  ZF_EXIBIR_ALV                    *
*--------------------------------------------------------*
*              EXIBE OS DADOS DOS RELATÓRIO              *
*--------------------------------------------------------*
FORM zf_exibir_alv TABLES p_in_it_output USING lw_output.
  DATA: lt_fieldcat TYPE lvc_t_fcat,
        wa_layout   TYPE lvc_s_layo.

  wa_layout-zebra = abap_true.
  wa_layout-cwidth_opt = abap_true.

* Criação da tabela de fieldcat
  CALL FUNCTION 'STRALAN_FIELDCAT_CREATE'
    EXPORTING
      is_structure = lw_output
    IMPORTING
      et_fieldcat  = lt_fieldcat.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY_LVC'
    EXPORTING
      i_callback_program = sy-repid
      is_layout_lvc      = wa_layout
      it_fieldcat_lvc    = lt_fieldcat
    TABLES
      t_outtab           = p_in_it_output
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
  IF sy-subrc NE 0.
    MESSAGE s208(00) DISPLAY LIKE sy-abcde+4(1) WITH TEXT-e01.
  ENDIF.

ENDFORM.


*--------------------------------------------------------*
*              Form  ZF_CRIAR_HEADING_EXCEL              *
*--------------------------------------------------------*
*              EXIBE OS DADOS DOS RELATÓRIO              *
*--------------------------------------------------------*
FORM zf_criar_heading_excel.
  DATA lw_header TYPE ty_header.

  IF p_cli IS NOT INITIAL.

    lw_header-line = TEXT-s02.
    APPEND lw_header TO it_header.
    lw_header-line = TEXT-s03.
    APPEND lw_header TO it_header.
    lw_header-line = TEXT-s04.
    APPEND lw_header TO it_header.
    lw_header-line = TEXT-s05.
    APPEND lw_header TO it_header.
    lw_header-line = TEXT-s06.
    APPEND lw_header TO it_header.
    lw_header-line = TEXT-s07.
    APPEND lw_header TO it_header.
    lw_header-line = TEXT-s08.
    APPEND lw_header TO it_header.
    lw_header-line = TEXT-s09.
    APPEND lw_header TO it_header.
    lw_header-line = TEXT-s10.
    APPEND lw_header TO it_header.
    lw_header-line = TEXT-s11.
    APPEND lw_header TO it_header.
    lw_header-line = TEXT-s12.
    APPEND lw_header TO it_header.
    lw_header-line = TEXT-s13.
    APPEND lw_header TO it_header.
    lw_header-line = TEXT-s14.
    APPEND lw_header TO it_header.
    lw_header-line = TEXT-s15.
    APPEND lw_header TO it_header.
    lw_header-line = TEXT-s16.
    APPEND lw_header TO it_header.
    lw_header-line = TEXT-s17.
    APPEND lw_header TO it_header.

  ELSEIF p_fat IS NOT INITIAL.

    lw_header-line = TEXT-s12.
    APPEND lw_header TO it_header.
    lw_header-line = TEXT-s14.
    APPEND lw_header TO it_header.
    lw_header-line = TEXT-s18.
    APPEND lw_header TO it_header.
    lw_header-line = TEXT-s19.
    APPEND lw_header TO it_header.
    lw_header-line = TEXT-s20.
    APPEND lw_header TO it_header.
    lw_header-line = TEXT-s21.
    APPEND lw_header TO it_header.
*   J_1BNFSTX-TAXVAL: Total da IPI
*   J_1BNFSTX-TAXVAL: Total de ICM
    lw_header-line = TEXT-s22.
    APPEND lw_header TO it_header.
    lw_header-line = TEXT-s23.
    APPEND lw_header TO it_header.
    lw_header-line = TEXT-s24.
    APPEND lw_header TO it_header.
    lw_header-line = TEXT-s25.
    APPEND lw_header TO it_header.
    lw_header-line = TEXT-s26.
    APPEND lw_header TO it_header.

  ELSE.

    lw_header-line = TEXT-s18.
    APPEND lw_header TO it_header.
    lw_header-line = TEXT-s19.
    APPEND lw_header TO it_header.
    lw_header-line = TEXT-s29.
    APPEND lw_header TO it_header.
    lw_header-line = TEXT-s20.
    APPEND lw_header TO it_header.
    lw_header-line = TEXT-s27.
    APPEND lw_header TO it_header.
    lw_header-line = TEXT-s28.
    APPEND lw_header TO it_header.
    lw_header-line = TEXT-s21.
    APPEND lw_header TO it_header.
    lw_header-line = TEXT-s26.
    APPEND lw_header TO it_header.

  ENDIF.
ENDFORM.

*--------------------------------------------------------*
*              Form  ZF_CRIAR_ARQUIVO_PST                *
*--------------------------------------------------------*
*    GERA OS ARQUIVOS .txt A SEREM ENVIADOS PARA A PST   *
*--------------------------------------------------------*
FORM zf_criar_arquivo_pst.
  DATA: lw_txt       TYPE ty_txt.

  DATA: lv_line(255)   TYPE c,
        lv_s_temp(100) TYPE c,
        lv_n_temp(40)  TYPE n,
        lv_regex(26)   TYPE c VALUE '[-(),.;:+=!@#$%&*^~,.:;/]+'.

  FIELD-SYMBOLS: <lfs_line> TYPE c,
                 <lfs_temp> TYPE n.

  IF p_cli IS NOT INITIAL.
    ASSIGN lv_line(244) TO <lfs_line>.

    LOOP AT it_clientes ASSIGNING FIELD-SYMBOL(<lfs_wa_clientes>).
      <lfs_line>+0 =  <lfs_wa_clientes>-name1+0(35).
      <lfs_line>+35 = <lfs_wa_clientes>-street+0(35).
      <lfs_line>+70 = <lfs_wa_clientes>-city1+0(35).

      lv_s_temp = CONV string( <lfs_wa_clientes>-post_code1 ).
      REPLACE ALL OCCURRENCES OF REGEX lv_regex IN lv_s_temp WITH ``.
      ASSIGN lv_n_temp(10) TO <lfs_temp>.
      <lfs_temp> = lv_s_temp+0(10).
      <lfs_line>+104 = <lfs_temp>.

      <lfs_line>+115 = <lfs_wa_clientes>-city2+0(35).
      <lfs_line>+150 = <lfs_wa_clientes>-region+0(3).
      <lfs_line>+153 = TEXT-ps1.

      lv_s_temp = CONV string( <lfs_wa_clientes>-tel_number ).
      REPLACE ALL OCCURRENCES OF REGEX lv_regex IN lv_s_temp WITH ``.
      ASSIGN lv_n_temp(16) TO <lfs_temp>.
      <lfs_temp> = lv_s_temp+0(16).
      <lfs_line>+156 = <lfs_temp>.

      lv_s_temp = CONV string( <lfs_wa_clientes>-stcd1 ).
      REPLACE ALL OCCURRENCES OF REGEX lv_regex IN lv_s_temp WITH ``.
      ASSIGN lv_n_temp(16) TO <lfs_temp>.
      <lfs_temp> = lv_s_temp+0(16).
      <lfs_line>+172 = <lfs_temp>.

      lv_s_temp = CONV string( <lfs_wa_clientes>-stcd3 ).
      REPLACE ALL OCCURRENCES OF REGEX lv_regex IN lv_s_temp WITH ``.
      ASSIGN lv_n_temp(18) TO <lfs_temp>.
      <lfs_temp> = lv_s_temp+0(18).
      <lfs_line>+188 = <lfs_temp>.

      lv_s_temp = CONV string( <lfs_wa_clientes>-stcd2 ).
      REPLACE ALL OCCURRENCES OF REGEX lv_regex IN lv_s_temp WITH ``.
      ASSIGN lv_n_temp(11) TO <lfs_temp>.
      <lfs_temp> = lv_s_temp+0(11).
      <lfs_line>+206 = <lfs_temp>.

      <lfs_line>+217 = <lfs_wa_clientes>-house_num1+0(10).
      <lfs_line>+227 = <lfs_wa_clientes>-house_num2+0(10).

      lv_s_temp = CONV string( <lfs_wa_clientes>-txjcd ).
      REPLACE ALL OCCURRENCES OF REGEX lv_regex IN lv_s_temp WITH ``.
      ASSIGN lv_n_temp(7) TO <lfs_temp>.
      <lfs_temp> = lv_s_temp+3(10).
      <lfs_line>+237 = <lfs_temp>.


      lw_txt-line = <lfs_line>.
      APPEND lw_txt TO it_txt.

      CLEAR: lw_txt.
    ENDLOOP.

  ELSEIF p_not IS NOT INITIAL.
    ASSIGN lv_line(79) TO <lfs_line>.

    LOOP AT it_prod_fat_nf ASSIGNING FIELD-SYMBOL(<wa_prod_fat_nf>).
      lv_s_temp = CONV string( <wa_prod_fat_nf>-nfenum ).
      REPLACE ALL OCCURRENCES OF REGEX lv_regex IN lv_s_temp WITH ``.
      ASSIGN lv_n_temp(6) TO <lfs_temp>.
      <lfs_temp> = lv_s_temp+0(6).
      <lfs_line>+0 = <lfs_temp>.

      <lfs_line>+6 = <wa_prod_fat_nf>-series+0(3).

      lv_s_temp = CONV string( <wa_prod_fat_nf>-credat ).
      REPLACE ALL OCCURRENCES OF REGEX lv_regex IN lv_s_temp WITH ``.
      <lfs_line>+9 = lv_s_temp+0(8).

      lv_s_temp = CONV string( <wa_prod_fat_nf>-matnr ).
      REPLACE ALL OCCURRENCES OF REGEX lv_regex IN lv_s_temp WITH ``.
      ASSIGN lv_n_temp(18) TO <lfs_temp>.
      <lfs_temp> = lv_s_temp+0(18).
      <lfs_line>+17 = <lfs_temp>.

      lv_s_temp = CONV string( <wa_prod_fat_nf>-menge ).
      REPLACE ALL OCCURRENCES OF REGEX lv_regex IN lv_s_temp WITH ``.
      ASSIGN lv_n_temp(15) TO <lfs_temp>.
      <lfs_temp> = lv_s_temp+0(15).
      <lfs_line>+35 = <lfs_temp>.

      lv_s_temp = CONV string( <wa_prod_fat_nf>-nftot ).
      REPLACE ALL OCCURRENCES OF REGEX lv_regex IN lv_s_temp WITH ``.
      ASSIGN lv_n_temp(15) TO <lfs_temp>.
      <lfs_temp> = lv_s_temp+0(15).
      <lfs_line>+50 = <lfs_temp>.

      lv_s_temp = CONV string( <wa_prod_fat_nf>-cgc ).
      REPLACE ALL OCCURRENCES OF REGEX lv_regex IN lv_s_temp WITH ``.
      ASSIGN lv_n_temp(15) TO <lfs_temp>.
      <lfs_temp> = lv_s_temp+0(15).
      <lfs_line>+50 = <lfs_temp>.

      lw_txt-line = <lfs_line>.
      APPEND lw_txt TO it_txt.

      CLEAR: lw_txt.
    ENDLOOP.

  ENDIF.
ENDFORM.


*--------------------------------------------------------*
*             Form  ZF_SALVAR_ARQUIVO_LOCAL              *
*--------------------------------------------------------*
*              Salva um arquivo localmente               *
*--------------------------------------------------------*
FORM zf_salvar_arquivo_local TABLES p_in_it_out USING p_in_excel TYPE flag.
  IF p_file IS NOT INITIAL.
    CALL FUNCTION 'GUI_DOWNLOAD'
      EXPORTING
        filename                = gv_path
        filetype                = 'ASC'
        write_field_separator   = p_in_excel
      TABLES
        data_tab                = p_in_it_out
        fieldnames              = it_header
      EXCEPTIONS
        file_write_error        = 1
        no_batch                = 2
        gui_refuse_filetransfer = 3
        invalid_type            = 4
        no_authority            = 5
        unknown_error           = 6
        header_not_allowed      = 7
        separator_not_allowed   = 8
        filesize_not_allowed    = 9
        header_too_long         = 10
        dp_error_create         = 11
        dp_error_send           = 12
        dp_error_write          = 13
        unknown_dp_error        = 14
        access_denied           = 15
        dp_out_of_memory        = 16
        disk_full               = 17
        dp_timeout              = 18
        file_not_found          = 19
        dataprovider_exception  = 20
        control_flush_error     = 21
        OTHERS                  = 22.

    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.
  ELSE.
    MESSAGE s208(00) DISPLAY LIKE sy-abcde+4(1) WITH TEXT-e03.
  ENDIF.
ENDFORM.


*--------------------------------------------------------*
*            Form  ZF_SALVAR_ARQUIVO_SERVIDOR            *
*--------------------------------------------------------*
*              Salva um arquivo no servidor              *
*--------------------------------------------------------*
FORM zf_salvar_arquivo_servidor TABLES p_in_it_output USING p_excel.
  IF p_excel IS INITIAL.
    OPEN DATASET gv_path FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.
    IF sy-subrc EQ 0.
      LOOP AT it_txt ASSIGNING FIELD-SYMBOL(<lfs_wa_output>).
        TRANSFER <lfs_wa_output>-line TO gv_path.
      ENDLOOP.
      CLOSE DATASET gv_path.
    ENDIF.

  ELSE.
*    GET REFERENCE OF p_in_it_output INTO DATA(lo_data_ref).
    DATA(lv_xstring) = NEW zcl_itab_to_excel( )->itab_to_xstring( p_in_it_output ).
    OPEN DATASET gv_path FOR OUTPUT IN BINARY MODE.
    IF sy-subrc EQ 0.
      TRANSFER lv_xstring TO gv_path.
      CLOSE DATASET gv_path.
    ENDIF.
  ENDIF.
ENDFORM.

FORM zf_processar_cds_view.
  DATA: lv_where TYPE string.

  IF p_cli IS NOT INITIAL.
    TRY.
        lv_where = cl_shdb_seltab=>combine_seltabs(
        EXPORTING it_named_seltabs =
          VALUE #( ( name = 'KUNNR' dref = REF #( s_kunnr[] ) ) )
          iv_client_field = 'MANDT'
          ).
      CATCH cx_shdb_exception.
      CATCH cx_sy_open_sql_db.
    ENDTRY.

    SELECT * FROM zcdsv_rel_clie( sel_opt = @lv_where ) INTO TABLE @it_clientes.
    cl_demo_output=>display( it_clientes ).

    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.
  ELSEIF p_not IS NOT INITIAL.
    TRY.
        lv_where = cl_shdb_seltab=>combine_seltabs(
        EXPORTING it_named_seltabs =
          VALUE #( ( name = 'DOCNUM' dref = REF #( s_docnum[] ) ) )
          iv_client_field = 'MANDT'
          ).
      CATCH cx_shdb_exception.
      CATCH cx_sy_open_sql_db.
    ENDTRY.

    SELECT * FROM zcdsv_rel_fatn( sel_opt = @lv_where ) INTO TABLE @it_prod_fat_nf.
    cl_demo_output=>display( it_prod_fat_nf ).

    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.
  ENDIF.

=======
*&---------------------------------------------------------------------------*
*&  REPORT           ZPR_GAP_SD_113.
*&---------------------------------------------------------------------------*
*& Nome: ZFM_CONSUME_BIGDATA
*& Tipo: Report
*& Objetivo: Envio dos dados dos vendedores e representantes de vendas de
*& acessórios para a PST.
*& Data/Hora: Sexta, Setembro 16, 2022 (GMT-3) - 10:15
*& Desenvolvedor: Sérgio Pontes (Grupo Real)
*&---------------------------------------------------------------------------*
*& Versão 1: Sérgio Pontes (Grupo Real) - Inicio Desenvolvimento - DS4K905250
*& Versão 2: ?
*& Versão 3: ?
*&---------------------------------------------------------------------------*
REPORT zpr_gap_sd_113.

****************
***	INCLUDES ***
****************
INCLUDE zic_exconv.

**************
***	TABLES ***
**************
TABLES:
  kna1,
  j_1bnfdoc.

***************
***	 TYPES  ***
***************
TYPES: BEGIN OF ty_clientes,
         kunnr      TYPE kna1-kunnr,
         name1      TYPE kna1-name1,
         addrnumber TYPE adrc-addrnumber,
         street     TYPE adrc-street,
         city1      TYPE adrc-city1,
         post_code1 TYPE adrc-post_code1,
         city2      TYPE adrc-city2,
         region     TYPE adrc-region,
         country    TYPE adrc-country,
         tel_number TYPE adrc-tel_number,
         stcd1      TYPE kna1-stcd1,
         stcd3      TYPE kna1-stcd3,
         stcd2      TYPE kna1-stcd2,
         house_num1 TYPE adrc-house_num1,
         house_num2 TYPE adrc-house_num2,
         txjcd      TYPE j_1bnfdoc-txjcd,
       END OF ty_clientes,

       BEGIN OF ty_fat_diario,
         stcd1    TYPE kna1-stcd1, " CNPJ
         stcd2    TYPE kna1-stcd2, " CPF
         nfenum   TYPE j_1bnfdoc-nfenum,
         series   TYPE j_1bnfdoc-series,
         docnum   TYPE j_1bnfdoc-docnum,
         nftot    TYPE j_1bnfdoc-nftot,
         taxval   TYPE j_1bnfstx-taxval,
         refkey   TYPE j_1bnflin-refkey,
         cod_repr TYPE knvp-parvw,
         cod_vend TYPE knvp-parvw,
         cod_dist TYPE knvp-parvw,
         cgc      TYPE j_1bnfdoc-cgc,
       END OF ty_fat_diario,

       BEGIN OF ty_prod_fat_nf,
         nfenum TYPE j_1bnfdoc-nfenum,
         series TYPE j_1bnfdoc-series,
         docnum TYPE j_1bnfdoc-docnum,
         credat TYPE j_1bnfdoc-credat,
         matnr  TYPE j_1bnflin-matnr,
         menge  TYPE j_1bnflin-menge,
         nftot  TYPE j_1bnfdoc-nftot,
         cgc    TYPE j_1bnfdoc-cgc,
       END OF ty_prod_fat_nf,

       BEGIN OF ty_header,
         line(50) TYPE c,
       END OF ty_header,

       BEGIN OF ty_txt,
         line(245) TYPE c,
       END OF ty_txt.

*************************
***	 INTERNAL TABLES  ***
*************************
DATA: it_clientes    TYPE TABLE OF ty_clientes ##NEEDED,
      it_fat_diario  TYPE TABLE OF ty_fat_diario ##NEEDED,
      it_prod_fat_nf TYPE TABLE OF ty_prod_fat_nf ##NEEDED,
      it_header      TYPE TABLE OF ty_header ##NEEDED,
      it_txt         TYPE TABLE OF ty_txt ##NEEDED.

***************
*  CONSTANTS  *
***************
CONSTANTS:  gc_cod_dist TYPE knvp-parvw VALUE 'P5'.

***************
*  VARIÁVEIS  *
***************
DATA: gv_path      TYPE string ##NEEDED,
      gv_sem_dados TYPE flag VALUE abap_false ##NEEDED.

***************************************
*** PARAMETROS DE SELEÇÃO DE DADOS  ***
***************************************
SELECTION-SCREEN: BEGIN OF BLOCK b_main WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS: s_kunnr FOR kna1-kunnr,
                  s_docnum FOR j_1bnfdoc-docnum.

  SELECTION-SCREEN SKIP.
  SELECTION-SCREEN: BEGIN OF BLOCK b_radiobuttons WITH FRAME TITLE TEXT-002.

    SELECTION-SCREEN BEGIN OF LINE.
      PARAMETERS: p_cli RADIOBUTTON GROUP rad1 DEFAULT 'X'.
      SELECTION-SCREEN COMMENT 3(16) TEXT-rb1.
    SELECTION-SCREEN END OF LINE.

    SELECTION-SCREEN BEGIN OF LINE.
      PARAMETERS: p_fat RADIOBUTTON GROUP rad1.
      SELECTION-SCREEN COMMENT 3(20) TEXT-rb2.
    SELECTION-SCREEN END OF LINE.

    SELECTION-SCREEN BEGIN OF LINE.
      PARAMETERS: p_not RADIOBUTTON GROUP rad1.
      SELECTION-SCREEN COMMENT 3(34) TEXT-rb3.
    SELECTION-SCREEN END OF LINE.

  SELECTION-SCREEN: END OF BLOCK b_radiobuttons.

  SELECTION-SCREEN: BEGIN OF BLOCK b_visualizacao WITH FRAME TITLE TEXT-003.

    PARAMETERS: p_file TYPE rlgrap-filename.

    SELECTION-SCREEN: SKIP.

    SELECTION-SCREEN BEGIN OF LINE.
      PARAMETERS: p_txt RADIOBUTTON GROUP rad2 DEFAULT 'X' USER-COMMAND rd2.
      SELECTION-SCREEN COMMENT 3(26) TEXT-rb4.
    SELECTION-SCREEN END OF LINE.

    SELECTION-SCREEN BEGIN OF LINE.
      PARAMETERS: p_xls RADIOBUTTON GROUP rad2.
      SELECTION-SCREEN COMMENT 3(27) TEXT-rb5.
    SELECTION-SCREEN END OF LINE.

    SELECTION-SCREEN BEGIN OF LINE.
      PARAMETERS: p_alv RADIOBUTTON GROUP rad2.
      SELECTION-SCREEN COMMENT 3(13) TEXT-rb6.
    SELECTION-SCREEN END OF LINE.

    SELECTION-SCREEN BEGIN OF LINE.
      PARAMETERS: p_txt_sv RADIOBUTTON GROUP rad2.
      SELECTION-SCREEN COMMENT 3(38) TEXT-rb7.
    SELECTION-SCREEN END OF LINE.

    SELECTION-SCREEN BEGIN OF LINE.
      PARAMETERS: p_xls_sv RADIOBUTTON GROUP rad2.
      SELECTION-SCREEN COMMENT 3(39) TEXT-rb8.
    SELECTION-SCREEN END OF LINE.

    SELECTION-SCREEN BEGIN OF LINE.
      PARAMETERS: p_cds_v RADIOBUTTON GROUP rad2.
      SELECTION-SCREEN COMMENT 3(8) TEXT-rb9.
    SELECTION-SCREEN END OF LINE.

  SELECTION-SCREEN: END OF BLOCK b_visualizacao.

SELECTION-SCREEN: END OF BLOCK b_main.

* AT SELECTION-SCREEN OUTPUT
AT SELECTION-SCREEN OUTPUT.
  LOOP AT SCREEN.
    IF screen-name EQ 'P_FILE'.
      screen-input = COND #( WHEN p_txt = abap_true OR p_xls = abap_true THEN 1 ELSE 0 ).
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.


* AT SELECTION-SCREEN
AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.
  CALL METHOD cl_gui_frontend_services=>directory_browse
    CHANGING
      selected_folder      = gv_path
    EXCEPTIONS
      cntl_error           = 1
      error_no_gui         = 2
      not_supported_by_gui = 3
      OTHERS               = 4.

  IF sy-subrc <> 0.
    CLEAR: p_file, gv_path.
  ELSE.
    p_file = gv_path.
  ENDIF.

* START-OF-SELECTION
START-OF-SELECTION.
  gv_path = COND #( WHEN gv_path IS INITIAL THEN p_file ELSE gv_path ).
  PERFORM: zf_limpar_tabelas.

  IF p_cds_v IS NOT INITIAL.
    PERFORM zf_processar_cds_view.
  ELSE.
    PERFORM zf_processar_dados.
  ENDIF.

* END-OF-SELECTION
END-OF-SELECTION.
  FIELD-SYMBOLS: <lfs_it_output> TYPE STANDARD TABLE,
                 <lfs_wa_output> TYPE any.

  IF gv_sem_dados IS INITIAL.
    IF p_cli IS NOT INITIAL.
      DATA lw_clientes TYPE ty_clientes.
      ASSIGN it_clientes TO <lfs_it_output>.
      ASSIGN lw_clientes TO <lfs_wa_output>.
    ELSEIF p_fat IS NOT INITIAL.
      DATA lw_fat_diario TYPE ty_fat_diario.
      ASSIGN it_fat_diario TO <lfs_it_output>.
      ASSIGN lw_fat_diario TO <lfs_wa_output>.
    ELSE.
      DATA lw_prod_fat_nf TYPE ty_prod_fat_nf.
      ASSIGN it_prod_fat_nf TO <lfs_it_output>.
      ASSIGN lw_prod_fat_nf TO <lfs_wa_output>.
    ENDIF.

    PERFORM zf_gerar_path.

    IF p_txt IS NOT INITIAL.
      PERFORM: zf_criar_arquivo_pst,
                zf_salvar_arquivo_local TABLES it_txt USING abap_false.

    ELSEIF p_xls IS NOT INITIAL.
      PERFORM: zf_criar_heading_excel,
               zf_salvar_arquivo_local TABLES <lfs_it_output> USING abap_true.

    ELSEIF p_txt_sv IS NOT INITIAL.
      PERFORM: zf_criar_arquivo_pst,
               zf_salvar_arquivo_servidor TABLES it_txt USING abap_false.
    ELSEIF p_xls_sv IS NOT INITIAL.
      PERFORM: zf_criar_heading_excel,
               zf_salvar_arquivo_servidor TABLES <lfs_it_output> USING abap_false.
    ELSEIF p_alv IS NOT INITIAL.
      PERFORM: zf_exibir_alv TABLES <lfs_it_output> USING <lfs_wa_output>.
    ELSEIF p_cds_v IS NOT INITIAL.

    ENDIF.
  ELSE.
    MESSAGE s208(00) DISPLAY LIKE sy-abcde+4(1) WITH TEXT-e02.
  ENDIF.


*--------------------------------------------------------*
*                Form  ZF_LIMPAR_TABELAS                 *
*--------------------------------------------------------*
*              LIMPA AS TABELAS DO REPORT                *
*--------------------------------------------------------*
FORM zf_limpar_tabelas.
  FREE: it_clientes,
        it_fat_diario,
        it_prod_fat_nf,
        it_header,
        it_txt.
ENDFORM.

*--------------------------------------------------------*
*               Form  ZF_PROCESSAR_DADOS                 *
*--------------------------------------------------------*
* SELECIONA E PROCESSA OS DADOS A SEREM EXIBIDOS PELO    *
* RELATÓRIO                                              *
*--------------------------------------------------------*
FORM zf_processar_dados.
  IF p_cli IS NOT INITIAL.
* Parte de seleção de dados
    SELECT kunnr,
           name1,
           stcd1,
           stcd2,
           stcd3,
           adrnr,
           txjcd
      FROM kna1
      INTO TABLE @DATA(it_kna1)
      WHERE kunnr IN @s_kunnr.

    IF sy-subrc EQ 0.

      SELECT  addrnumber,
              date_from,
              nation,
              street,
              city1,
              post_code1,
              city2,
              region,
              country,
              tel_number,
              house_num1,
              house_num2
        FROM adrc
        INTO TABLE @DATA(it_adrc)
        FOR ALL ENTRIES IN @it_kna1
        WHERE addrnumber EQ @it_kna1-adrnr.

    ENDIF.
* Parte de processamento de dados
    SORT: it_adrc BY addrnumber date_from nation.

    LOOP AT it_kna1 ASSIGNING FIELD-SYMBOL(<lfs_wa_kna1>).
      APPEND INITIAL LINE TO it_clientes ASSIGNING FIELD-SYMBOL(<lfs_wa_clientes>).

      <lfs_wa_clientes>-kunnr = <lfs_wa_kna1>-kunnr.
      <lfs_wa_clientes>-name1 = <lfs_wa_kna1>-name1.
      <lfs_wa_clientes>-addrnumber = <lfs_wa_kna1>-adrnr.
      <lfs_wa_clientes>-stcd1 = <lfs_wa_kna1>-stcd1.
      <lfs_wa_clientes>-stcd3 = <lfs_wa_kna1>-stcd3.
      <lfs_wa_clientes>-stcd2 = <lfs_wa_kna1>-stcd2.
      <lfs_wa_clientes>-txjcd = <lfs_wa_kna1>-txjcd.

      READ TABLE it_adrc INTO DATA(wa_adrc) WITH KEY addrnumber = <lfs_wa_kna1>-adrnr BINARY SEARCH.

      IF sy-subrc EQ 0.
        <lfs_wa_clientes>-street  =   wa_adrc-street.
        <lfs_wa_clientes>-city1  =    wa_adrc-city1.
        <lfs_wa_clientes>-post_code1 = wa_adrc-post_code1.
        <lfs_wa_clientes>-city2 = wa_adrc-city2.
        <lfs_wa_clientes>-region = wa_adrc-region.
        <lfs_wa_clientes>-country = wa_adrc-country.
        <lfs_wa_clientes>-tel_number = wa_adrc-tel_number.
        <lfs_wa_clientes>-house_num1 = wa_adrc-house_num1.
        <lfs_wa_clientes>-house_num2 = wa_adrc-house_num2.

        CLEAR: wa_adrc.
      ENDIF.

    ENDLOOP.
    gv_sem_dados = COND #( WHEN it_clientes IS INITIAL THEN abap_true ELSE abap_false ).
  ELSEIF p_fat IS NOT INITIAL.
*
* Código ´do relatório de Faturamento Diário
*
    gv_sem_dados = COND #( WHEN it_fat_diario IS INITIAL THEN abap_true ELSE abap_false ).
  ELSE.
* Parte de seleção de dados
    SELECT docnum,
           credat,
           nfenum,
           series,
           nftot,
           zterm,
           parvw,
           cgc,
           txjcd
      FROM j_1bnfdoc
      INTO TABLE @DATA(it_j_1bnfdoc)
      WHERE docnum IN @s_docnum.

    IF sy-subrc EQ 0.
      SELECT docnum,
             itmnum,
             matnr,
             menge,
             refkey
        FROM j_1bnflin
        INTO TABLE @DATA(it_j_1bnflin)
        FOR ALL ENTRIES IN @it_j_1bnfdoc
        WHERE docnum EQ @it_j_1bnfdoc-docnum.

      IF sy-subrc EQ 0.
        SELECT docnum,
               itmnum,
               taxtyp,
               taxval
          FROM j_1bnfstx
          INTO TABLE @DATA(it_j_1bnfstx)
          FOR ALL ENTRIES IN @it_j_1bnflin
          WHERE docnum EQ @it_j_1bnflin-docnum AND itmnum EQ @it_j_1bnflin-itmnum.

      ENDIF.
    ENDIF.
* Parte de processamento de dados
    SORT: it_j_1bnfdoc BY docnum,
          it_j_1bnflin BY docnum itmnum,
          it_j_1bnfstx BY docnum itmnum taxtyp.

    LOOP AT it_j_1bnflin ASSIGNING FIELD-SYMBOL(<lfs_wa_j_1bnflin>).
      APPEND INITIAL LINE TO it_prod_fat_nf ASSIGNING FIELD-SYMBOL(<lfs_wa_prod_fat_nf>).

      READ TABLE it_j_1bnfdoc INTO DATA(wa_j_1bnfdoc) WITH KEY docnum = <lfs_wa_j_1bnflin>-docnum
                                                                              BINARY SEARCH.
      IF sy-subrc EQ 0.
        <lfs_wa_prod_fat_nf>-nfenum = wa_j_1bnfdoc-nfenum.
        <lfs_wa_prod_fat_nf>-series = wa_j_1bnfdoc-series.
        <lfs_wa_prod_fat_nf>-docnum = wa_j_1bnfdoc-docnum.
        <lfs_wa_prod_fat_nf>-credat = wa_j_1bnfdoc-credat.
        <lfs_wa_prod_fat_nf>-matnr  = <lfs_wa_j_1bnflin>-matnr.
        <lfs_wa_prod_fat_nf>-menge  = <lfs_wa_j_1bnflin>-menge.
        <lfs_wa_prod_fat_nf>-nftot  = wa_j_1bnfdoc-nftot.
        <lfs_wa_prod_fat_nf>-cgc    = wa_j_1bnfdoc-cgc.
      ENDIF.
      CLEAR: wa_j_1bnfdoc.
    ENDLOOP.
    gv_sem_dados = COND #( WHEN it_prod_fat_nf IS INITIAL THEN abap_true ELSE abap_false ).
  ENDIF.

ENDFORM.

FORM zf_gerar_path.
  DATA: lv_filename TYPE string,
        lv_filetype TYPE string,
        lv_date(6)  TYPE c.

  lv_date = |{ gc_cod_dist }{ sy-datum+6(2) }{ sy-datum+4(2) }{ sy-datum+2(2) }|.

  IF p_cli IS NOT INITIAL.
* TEXT-cli = CLIE
    lv_filename = |{ TEXT-cli }{ gc_cod_dist }{ lv_date }|.
  ELSEIF p_fat IS NOT INITIAL.
* TEXT-fat = FATD
    lv_filename = |{ TEXT-fat }{ gc_cod_dist }{ lv_date }|.
  ELSE.
* TEXT-fan = FATN
    lv_filename = |{ TEXT-fan }{ gc_cod_dist }{ lv_date }|.
  ENDIF.

* TEXT-txt = .txt
* TEXT-xls = .xls
  lv_filetype = COND #( WHEN p_txt IS NOT INITIAL OR p_txt_sv IS NOT INITIAL THEN TEXT-txt ELSE TEXT-xls ).

  IF p_txt_sv IS NOT INITIAL OR p_xls_sv IS NOT INITIAL.
    gv_path = |{ TEXT-svp }{ TEXT-c03 }{ lv_filename }{ TEXT-c02 }{ TEXT-ps1 }{ lv_filetype }|.
  ELSE.
    gv_path = |{ p_file }{ TEXT-c01 }{ lv_filename }{ TEXT-c02 }{ TEXT-ps1 }{ lv_filetype }|.
  ENDIF.

ENDFORM.

*--------------------------------------------------------*
*                 Form  ZF_EXIBIR_ALV                    *
*--------------------------------------------------------*
*              EXIBE OS DADOS DOS RELATÓRIO              *
*--------------------------------------------------------*
FORM zf_exibir_alv TABLES p_in_it_output USING lw_output.
  DATA: lt_fieldcat TYPE lvc_t_fcat,
        wa_layout   TYPE lvc_s_layo.

  wa_layout-zebra = abap_true.
  wa_layout-cwidth_opt = abap_true.

* Criação da tabela de fieldcat
  CALL FUNCTION 'STRALAN_FIELDCAT_CREATE'
    EXPORTING
      is_structure = lw_output
    IMPORTING
      et_fieldcat  = lt_fieldcat.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY_LVC'
    EXPORTING
      i_callback_program = sy-repid
      is_layout_lvc      = wa_layout
      it_fieldcat_lvc    = lt_fieldcat
    TABLES
      t_outtab           = p_in_it_output
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
  IF sy-subrc NE 0.
    MESSAGE s208(00) DISPLAY LIKE sy-abcde+4(1) WITH TEXT-e01.
  ENDIF.

ENDFORM.


*--------------------------------------------------------*
*              Form  ZF_CRIAR_HEADING_EXCEL              *
*--------------------------------------------------------*
*              EXIBE OS DADOS DOS RELATÓRIO              *
*--------------------------------------------------------*
FORM zf_criar_heading_excel.
  DATA lw_header TYPE ty_header.

  IF p_cli IS NOT INITIAL.

    lw_header-line = TEXT-s02.
    APPEND lw_header TO it_header.
    lw_header-line = TEXT-s03.
    APPEND lw_header TO it_header.
    lw_header-line = TEXT-s04.
    APPEND lw_header TO it_header.
    lw_header-line = TEXT-s05.
    APPEND lw_header TO it_header.
    lw_header-line = TEXT-s06.
    APPEND lw_header TO it_header.
    lw_header-line = TEXT-s07.
    APPEND lw_header TO it_header.
    lw_header-line = TEXT-s08.
    APPEND lw_header TO it_header.
    lw_header-line = TEXT-s09.
    APPEND lw_header TO it_header.
    lw_header-line = TEXT-s10.
    APPEND lw_header TO it_header.
    lw_header-line = TEXT-s11.
    APPEND lw_header TO it_header.
    lw_header-line = TEXT-s12.
    APPEND lw_header TO it_header.
    lw_header-line = TEXT-s13.
    APPEND lw_header TO it_header.
    lw_header-line = TEXT-s14.
    APPEND lw_header TO it_header.
    lw_header-line = TEXT-s15.
    APPEND lw_header TO it_header.
    lw_header-line = TEXT-s16.
    APPEND lw_header TO it_header.
    lw_header-line = TEXT-s17.
    APPEND lw_header TO it_header.

  ELSEIF p_fat IS NOT INITIAL.

    lw_header-line = TEXT-s12.
    APPEND lw_header TO it_header.
    lw_header-line = TEXT-s14.
    APPEND lw_header TO it_header.
    lw_header-line = TEXT-s18.
    APPEND lw_header TO it_header.
    lw_header-line = TEXT-s19.
    APPEND lw_header TO it_header.
    lw_header-line = TEXT-s20.
    APPEND lw_header TO it_header.
    lw_header-line = TEXT-s21.
    APPEND lw_header TO it_header.
*   J_1BNFSTX-TAXVAL: Total da IPI
*   J_1BNFSTX-TAXVAL: Total de ICM
    lw_header-line = TEXT-s22.
    APPEND lw_header TO it_header.
    lw_header-line = TEXT-s23.
    APPEND lw_header TO it_header.
    lw_header-line = TEXT-s24.
    APPEND lw_header TO it_header.
    lw_header-line = TEXT-s25.
    APPEND lw_header TO it_header.
    lw_header-line = TEXT-s26.
    APPEND lw_header TO it_header.

  ELSE.

    lw_header-line = TEXT-s18.
    APPEND lw_header TO it_header.
    lw_header-line = TEXT-s19.
    APPEND lw_header TO it_header.
    lw_header-line = TEXT-s29.
    APPEND lw_header TO it_header.
    lw_header-line = TEXT-s20.
    APPEND lw_header TO it_header.
    lw_header-line = TEXT-s27.
    APPEND lw_header TO it_header.
    lw_header-line = TEXT-s28.
    APPEND lw_header TO it_header.
    lw_header-line = TEXT-s21.
    APPEND lw_header TO it_header.
    lw_header-line = TEXT-s26.
    APPEND lw_header TO it_header.

  ENDIF.
ENDFORM.

*--------------------------------------------------------*
*              Form  ZF_CRIAR_ARQUIVO_PST                *
*--------------------------------------------------------*
*    GERA OS ARQUIVOS .txt A SEREM ENVIADOS PARA A PST   *
*--------------------------------------------------------*
FORM zf_criar_arquivo_pst.
  DATA: lw_txt       TYPE ty_txt.

  DATA: lv_line(255)   TYPE c,
        lv_s_temp(100) TYPE c,
        lv_n_temp(40)  TYPE n,
        lv_regex(26)   TYPE c VALUE '[-(),.;:+=!@#$%&*^~,.:;/]+'.

  FIELD-SYMBOLS: <lfs_line> TYPE c,
                 <lfs_temp> TYPE n.

  IF p_cli IS NOT INITIAL.
    ASSIGN lv_line(244) TO <lfs_line>.

    LOOP AT it_clientes ASSIGNING FIELD-SYMBOL(<lfs_wa_clientes>).
      <lfs_line>+0 =  <lfs_wa_clientes>-name1+0(35).
      <lfs_line>+35 = <lfs_wa_clientes>-street+0(35).
      <lfs_line>+70 = <lfs_wa_clientes>-city1+0(35).

      lv_s_temp = CONV string( <lfs_wa_clientes>-post_code1 ).
      REPLACE ALL OCCURRENCES OF REGEX lv_regex IN lv_s_temp WITH ``.
      ASSIGN lv_n_temp(10) TO <lfs_temp>.
      <lfs_temp> = lv_s_temp+0(10).
      <lfs_line>+104 = <lfs_temp>.

      <lfs_line>+115 = <lfs_wa_clientes>-city2+0(35).
      <lfs_line>+150 = <lfs_wa_clientes>-region+0(3).
      <lfs_line>+153 = TEXT-ps1.

      lv_s_temp = CONV string( <lfs_wa_clientes>-tel_number ).
      REPLACE ALL OCCURRENCES OF REGEX lv_regex IN lv_s_temp WITH ``.
      ASSIGN lv_n_temp(16) TO <lfs_temp>.
      <lfs_temp> = lv_s_temp+0(16).
      <lfs_line>+156 = <lfs_temp>.

      lv_s_temp = CONV string( <lfs_wa_clientes>-stcd1 ).
      REPLACE ALL OCCURRENCES OF REGEX lv_regex IN lv_s_temp WITH ``.
      ASSIGN lv_n_temp(16) TO <lfs_temp>.
      <lfs_temp> = lv_s_temp+0(16).
      <lfs_line>+172 = <lfs_temp>.

      lv_s_temp = CONV string( <lfs_wa_clientes>-stcd3 ).
      REPLACE ALL OCCURRENCES OF REGEX lv_regex IN lv_s_temp WITH ``.
      ASSIGN lv_n_temp(18) TO <lfs_temp>.
      <lfs_temp> = lv_s_temp+0(18).
      <lfs_line>+188 = <lfs_temp>.

      lv_s_temp = CONV string( <lfs_wa_clientes>-stcd2 ).
      REPLACE ALL OCCURRENCES OF REGEX lv_regex IN lv_s_temp WITH ``.
      ASSIGN lv_n_temp(11) TO <lfs_temp>.
      <lfs_temp> = lv_s_temp+0(11).
      <lfs_line>+206 = <lfs_temp>.

      <lfs_line>+217 = <lfs_wa_clientes>-house_num1+0(10).
      <lfs_line>+227 = <lfs_wa_clientes>-house_num2+0(10).

      lv_s_temp = CONV string( <lfs_wa_clientes>-txjcd ).
      REPLACE ALL OCCURRENCES OF REGEX lv_regex IN lv_s_temp WITH ``.
      ASSIGN lv_n_temp(7) TO <lfs_temp>.
      <lfs_temp> = lv_s_temp+3(10).
      <lfs_line>+237 = <lfs_temp>.


      lw_txt-line = <lfs_line>.
      APPEND lw_txt TO it_txt.

      CLEAR: lw_txt.
    ENDLOOP.

  ELSEIF p_not IS NOT INITIAL.
    ASSIGN lv_line(79) TO <lfs_line>.

    LOOP AT it_prod_fat_nf ASSIGNING FIELD-SYMBOL(<wa_prod_fat_nf>).
      lv_s_temp = CONV string( <wa_prod_fat_nf>-nfenum ).
      REPLACE ALL OCCURRENCES OF REGEX lv_regex IN lv_s_temp WITH ``.
      ASSIGN lv_n_temp(6) TO <lfs_temp>.
      <lfs_temp> = lv_s_temp+0(6).
      <lfs_line>+0 = <lfs_temp>.

      <lfs_line>+6 = <wa_prod_fat_nf>-series+0(3).

      lv_s_temp = CONV string( <wa_prod_fat_nf>-credat ).
      REPLACE ALL OCCURRENCES OF REGEX lv_regex IN lv_s_temp WITH ``.
      <lfs_line>+9 = lv_s_temp+0(8).

      lv_s_temp = CONV string( <wa_prod_fat_nf>-matnr ).
      REPLACE ALL OCCURRENCES OF REGEX lv_regex IN lv_s_temp WITH ``.
      ASSIGN lv_n_temp(18) TO <lfs_temp>.
      <lfs_temp> = lv_s_temp+0(18).
      <lfs_line>+17 = <lfs_temp>.

      lv_s_temp = CONV string( <wa_prod_fat_nf>-menge ).
      REPLACE ALL OCCURRENCES OF REGEX lv_regex IN lv_s_temp WITH ``.
      ASSIGN lv_n_temp(15) TO <lfs_temp>.
      <lfs_temp> = lv_s_temp+0(15).
      <lfs_line>+35 = <lfs_temp>.

      lv_s_temp = CONV string( <wa_prod_fat_nf>-nftot ).
      REPLACE ALL OCCURRENCES OF REGEX lv_regex IN lv_s_temp WITH ``.
      ASSIGN lv_n_temp(15) TO <lfs_temp>.
      <lfs_temp> = lv_s_temp+0(15).
      <lfs_line>+50 = <lfs_temp>.

      lv_s_temp = CONV string( <wa_prod_fat_nf>-cgc ).
      REPLACE ALL OCCURRENCES OF REGEX lv_regex IN lv_s_temp WITH ``.
      ASSIGN lv_n_temp(15) TO <lfs_temp>.
      <lfs_temp> = lv_s_temp+0(15).
      <lfs_line>+50 = <lfs_temp>.

      lw_txt-line = <lfs_line>.
      APPEND lw_txt TO it_txt.

      CLEAR: lw_txt.
    ENDLOOP.

  ENDIF.
ENDFORM.


*--------------------------------------------------------*
*             Form  ZF_SALVAR_ARQUIVO_LOCAL              *
*--------------------------------------------------------*
*              Salva um arquivo localmente               *
*--------------------------------------------------------*
FORM zf_salvar_arquivo_local TABLES p_in_it_out USING p_in_excel TYPE flag.
  IF p_file IS NOT INITIAL.
    CALL FUNCTION 'GUI_DOWNLOAD'
      EXPORTING
        filename                = gv_path
        filetype                = 'ASC'
        write_field_separator   = p_in_excel
      TABLES
        data_tab                = p_in_it_out
        fieldnames              = it_header
      EXCEPTIONS
        file_write_error        = 1
        no_batch                = 2
        gui_refuse_filetransfer = 3
        invalid_type            = 4
        no_authority            = 5
        unknown_error           = 6
        header_not_allowed      = 7
        separator_not_allowed   = 8
        filesize_not_allowed    = 9
        header_too_long         = 10
        dp_error_create         = 11
        dp_error_send           = 12
        dp_error_write          = 13
        unknown_dp_error        = 14
        access_denied           = 15
        dp_out_of_memory        = 16
        disk_full               = 17
        dp_timeout              = 18
        file_not_found          = 19
        dataprovider_exception  = 20
        control_flush_error     = 21
        OTHERS                  = 22.

    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.
  ELSE.
    MESSAGE s208(00) DISPLAY LIKE sy-abcde+4(1) WITH TEXT-e03.
  ENDIF.
ENDFORM.


*--------------------------------------------------------*
*            Form  ZF_SALVAR_ARQUIVO_SERVIDOR            *
*--------------------------------------------------------*
*              Salva um arquivo no servidor              *
*--------------------------------------------------------*
FORM zf_salvar_arquivo_servidor TABLES p_in_it_output USING p_excel.
  IF p_excel IS INITIAL.
    OPEN DATASET gv_path FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.
    IF sy-subrc EQ 0.
      LOOP AT it_txt ASSIGNING FIELD-SYMBOL(<lfs_wa_output>).
        TRANSFER <lfs_wa_output>-line TO gv_path.
      ENDLOOP.
      CLOSE DATASET gv_path.
    ENDIF.

  ELSE.
*    GET REFERENCE OF p_in_it_output INTO DATA(lo_data_ref).
    DATA(lv_xstring) = NEW zcl_itab_to_excel( )->itab_to_xstring( p_in_it_output ).
    OPEN DATASET gv_path FOR OUTPUT IN BINARY MODE.
    IF sy-subrc EQ 0.
      TRANSFER lv_xstring TO gv_path.
      CLOSE DATASET gv_path.
    ENDIF.
  ENDIF.
ENDFORM.

FORM zf_processar_cds_view.
  DATA: lv_where TYPE string.

  IF p_cli IS NOT INITIAL.
    TRY.
        lv_where = cl_shdb_seltab=>combine_seltabs(
        EXPORTING it_named_seltabs =
          VALUE #( ( name = 'KUNNR' dref = REF #( s_kunnr[] ) ) )
          iv_client_field = 'MANDT'
          ).
      CATCH cx_shdb_exception.
      CATCH cx_sy_open_sql_db.
    ENDTRY.

    SELECT * FROM zcdsv_rel_clie( sel_opt = @lv_where ) INTO TABLE @it_clientes.
    cl_demo_output=>display( it_clientes ).

    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.
  ELSEIF p_not IS NOT INITIAL.
    TRY.
        lv_where = cl_shdb_seltab=>combine_seltabs(
        EXPORTING it_named_seltabs =
          VALUE #( ( name = 'DOCNUM' dref = REF #( s_docnum[] ) ) )
          iv_client_field = 'MANDT'
          ).
      CATCH cx_shdb_exception.
      CATCH cx_sy_open_sql_db.
    ENDTRY.

    SELECT * FROM zcdsv_rel_fatn( sel_opt = @lv_where ) INTO TABLE @it_prod_fat_nf.
    cl_demo_output=>display( it_prod_fat_nf ).

    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.
  ENDIF.

>>>>>>> origin/main
ENDFORM.