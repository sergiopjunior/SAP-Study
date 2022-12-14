*&---------------------------------------------------------------------*
*& Report zreport32
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zreport32.

DATA:l_carrid TYPE s_carrid,
     lv_where  TYPE string.

SELECT-OPTIONS:s_carrid FOR l_carrid.

START-OF-SELECTION.
  lv_where = cl_shdb_seltab=>combine_seltabs(
                              EXPORTING it_named_seltabs = VALUE #( ( name = 'CARRID' dref = REF #( s_carrid[] ) ) )
                                        iv_client_field = 'MANDT').

ZCL_AMDP_EX31=>amdp_procedure(
  EXPORTING
    iv_sel_opt_carrid = lv_where
  IMPORTING
    ET_Scarr = data(lt_scarr)
).

   try.
  cl_salv_table=>FACTORY(
    EXPORTING
      LIST_DISPLAY   = IF_SALV_C_BOOL_SAP=>FALSE    " ALV Displayed in List Mode
*      R_CONTAINER    =     " Abstract Container for GUI Controls
*      CONTAINER_NAME =
    IMPORTING
      R_SALV_TABLE   =  data(lo_alv)  " Basis Class Simple ALV Tables
    CHANGING
      T_TABLE        = lt_scarr
  ).
    CATCH CX_SALV_MSG.    "
    endtry.

lo_alv->DISPLAY( ).
