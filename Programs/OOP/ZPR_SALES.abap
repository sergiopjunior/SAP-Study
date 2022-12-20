*&---------------------------------------------------------------------*
*& Report ZPR_SALES
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zpr_sales.

INCLUDE zic_sales.

TABLES:
  zdemo_soh.

SELECTION-SCREEN: BEGIN OF BLOCK b_main WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS so_ordid FOR zdemo_soh-salesorderuuid MATCHCODE OBJECT  zsh_salesorderuuid.
SELECTION-SCREEN: END OF BLOCK b_main.

START-OF-SELECTION.
  cl_main=>get_sales_products( so_ordid[] ).