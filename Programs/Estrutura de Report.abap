<<<<<<< HEAD
*&---------------------------------------------------------------------*
*&  REPORT           ZPR_RELATORIO_EXCEL
*&---------------------------------------------------------------------*
*& Nome: ZFM_CONSUME_BIGDATA
*& Tipo: Report
*& Objetivo: Gerar relatório e salvar os dados em uma planilha do Excel
*& Data/Hora: Sexta, Setembro 16, 2022 (GMT-3) - 10:15
*& Desenvolvedor: Higor Lopes(Burger King)
*&---------------------------------------------------------------------*
*& Versão 1: Sérgio Pontes (Grupo Real) - Inicio Desenvolvimento - DS4K905250
*& Versão 2: ?
*& Versão 3: ?
*&---------------------------------------------------------------------*

REPORT zpr_relatorio_excel.

***************
***	TABELAS	***
***************
TABLES: mara.

***************
***	 TYPES  ***
***************
TYPES: BEGIN OF ty_mara,
         matnr TYPE mara-matnr,
       END OF ty_mara.

*************************
***	 INTERNAL TABLES  ***
*************************
DATA: it_mara TYPE TABLE OF ty_mara.

*******************
*** WORK AREAS  ***
*******************
DATA: wa_mara TYPE ty_mara.

***************************************
*** PARAMETROS DE SELEÇÃO DE DADOS  ***
***************************************
SELECTION-SCREEN: BEGIN OF BLOCK b_main WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS s_matnr FOR mara-matnr.
SELECTION-SCREEN: END OF BLOCK b_main.

* START-OF-SELECTION
START-OF-SELECTION.
  PERFORM: zf_selecionar_dados,
           zf_processar_dados.

* END-OF-SELECTION
END-OF-SELECTION.
  PERFORM: zf_salvar_dados.

*--------------------------------------------------------*
*               Form  Z_SELECIONA_DADOS                  *
*--------------------------------------------------------*
*   SELECIONA OS DADOS A SEREM EXIBIDOS PELO RELATÓRIO   *
*--------------------------------------------------------*
FORM zf_selecionar_dados.
ENDFORM.


*--------------------------------------------------------*
*               Form  Z_PROCESSAR_DADOS                  *
*--------------------------------------------------------*
*         PROCESSA AS INFORMAÇÕES DO RELATÓRIO           *
*--------------------------------------------------------*
FORM zf_processar_dados.
ENDFORM.

*--------------------------------------------------------*
*                 Form  Z_SALVAR_DADOS                   *
*--------------------------------------------------------*
*  SALVA OS DADOS DO RELATÓRIO EM UMA PLANILHA DO EXCEL  *
*--------------------------------------------------------*
FORM zf_salvar_dados.
=======
*&---------------------------------------------------------------------*
*&  REPORT           ZPR_RELATORIO_EXCEL
*&---------------------------------------------------------------------*
*& Nome: ZFM_CONSUME_BIGDATA
*& Tipo: Report
*& Objetivo: Gerar relatório e salvar os dados em uma planilha do Excel
*& Data/Hora: Sexta, Setembro 16, 2022 (GMT-3) - 10:15
*& Desenvolvedor: Higor Lopes(Burger King)
*&---------------------------------------------------------------------*
*& Versão 1: Sérgio Pontes (Grupo Real) - Inicio Desenvolvimento - DS4K905250
*& Versão 2: ?
*& Versão 3: ?
*&---------------------------------------------------------------------*

REPORT zpr_relatorio_excel.

***************
***	TABELAS	***
***************
TABLES: mara.

***************
***	 TYPES  ***
***************
TYPES: BEGIN OF ty_mara,
         matnr TYPE mara-matnr,
       END OF ty_mara.

*************************
***	 INTERNAL TABLES  ***
*************************
DATA: it_mara TYPE TABLE OF ty_mara.

*******************
*** WORK AREAS  ***
*******************
DATA: wa_mara TYPE ty_mara.

***************************************
*** PARAMETROS DE SELEÇÃO DE DADOS  ***
***************************************
SELECTION-SCREEN: BEGIN OF BLOCK b_main WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS s_matnr FOR mara-matnr.
SELECTION-SCREEN: END OF BLOCK b_main.

* START-OF-SELECTION
START-OF-SELECTION.
  PERFORM: zf_selecionar_dados,
           zf_processar_dados.

* END-OF-SELECTION
END-OF-SELECTION.
  PERFORM: zf_salvar_dados.

*--------------------------------------------------------*
*               Form  Z_SELECIONA_DADOS                  *
*--------------------------------------------------------*
*   SELECIONA OS DADOS A SEREM EXIBIDOS PELO RELATÓRIO   *
*--------------------------------------------------------*
FORM zf_selecionar_dados.
ENDFORM.


*--------------------------------------------------------*
*               Form  Z_PROCESSAR_DADOS                  *
*--------------------------------------------------------*
*         PROCESSA AS INFORMAÇÕES DO RELATÓRIO           *
*--------------------------------------------------------*
FORM zf_processar_dados.
ENDFORM.

*--------------------------------------------------------*
*                 Form  Z_SALVAR_DADOS                   *
*--------------------------------------------------------*
*  SALVA OS DADOS DO RELATÓRIO EM UMA PLANILHA DO EXCEL  *
*--------------------------------------------------------*
FORM zf_salvar_dados.
>>>>>>> origin/main
ENDFORM.