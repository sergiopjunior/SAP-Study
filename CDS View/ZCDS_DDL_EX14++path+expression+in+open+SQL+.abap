*&---------------------------------------------------------------------*
*& Report zcds_report14
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zcds_report14.

select from ZCDS_DDL_EX12 as c
fields carrid,
       customid,
       \_b-email as email,
       c~\_b-name as name
into table @data(lt_tab).

   try.
  cl_salv_table=>FACTORY(
    EXPORTING
      LIST_DISPLAY   = IF_SALV_C_BOOL_SAP=>FALSE    " ALV Displayed in List Mode
*      R_CONTAINER    =     " Abstract Container for GUI Controls
*      CONTAINER_NAME =
    IMPORTING
      R_SALV_TABLE   =  data(lo_alv)  " Basis Class Simple ALV Tables
    CHANGING
      T_TABLE        = lt_tab
  ).
    CATCH CX_SALV_MSG.    "
    endtry.

lo_alv->DISPLAY( ).
