*&---------------------------------------------------------------------*
*& Report zreport22
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zreport22.

parameters: p_name type s_carrname.

select * from ZCDS_DDL_EX20( I_NAME = @p_name ) into table @data(lt_scarr).

cl_salv_table=>FACTORY(
  EXPORTING
    LIST_DISPLAY   = IF_SALV_C_BOOL_SAP=>FALSE    " ALV Displayed in List Mode
*    R_CONTAINER    =     " Abstract Container for GUI Controls
*    CONTAINER_NAME =
  IMPORTING
    R_SALV_TABLE   =   data(lo_alv)  " Basis Class Simple ALV Tables
  CHANGING
    T_TABLE        = lt_scarr
).
*  CATCH CX_SALV_MSG.    "

lo_alv->DISPLAY( ).
