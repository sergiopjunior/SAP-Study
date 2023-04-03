*&---------------------------------------------------------------------*
*& Report YADD_USER
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT yadd_user.

SELECTION-SCREEN: BEGIN OF BLOCK b_main WITH FRAME TITLE TEXT-000.
PARAMETER p_fname TYPE ycustomer-first_name.
PARAMETER p_lname TYPE ycustomer-last_name.
PARAMETER p_bdate TYPE ycustomer-bdate.
PARAMETER p_telf1 TYPE ycustomer-telf1.
PARAMETER p_telf2 TYPE ycustomer-telf2.
PARAMETER p_telfx TYPE ycustomer-telfx.
PARAMETER p_cnpj TYPE ycustomer-cnpj.
PARAMETER p_cpf TYPE ycustomer-cpf.
PARAMETER p_cntry TYPE ycustomer-country.
PARAMETER p_lang TYPE ycustomer-lang.
PARAMETER p_region TYPE ycustomer-region.
PARAMETER p_city TYPE ycustomer-city.
PARAMETER p_pcode TYPE ycustomer-post_code.
PARAMETER p_nhood TYPE ycustomer-neighborhood.
PARAMETER p_street TYPE ycustomer-street.
PARAMETER p_honum TYPE ycustomer-house_num.
PARAMETER p_build TYPE ycustomer-building.
PARAMETER p_floor TYPE ycustomer-floor.
PARAMETER p_ronum TYPE ycustomer-roomnumber.

SELECTION-SCREEN: END OF BLOCK b_main.

START-OF-SELECTION.
  PERFORM zsave_records.

FORM zget_next_code CHANGING out_cust_nbr.
  CALL FUNCTION 'NUMBER_GET_NEXT'
    EXPORTING
      nr_range_nr             = '01'
      object                  = 'YCUSTNR'
    IMPORTING
      number                  = out_cust_nbr
    EXCEPTIONS
      interval_not_found      = 1
      number_range_not_intern = 2
      object_not_found        = 3
      quantity_is_0           = 4
      quantity_is_not_1       = 5
      interval_overflow       = 6
      buffer_overflow         = 7
      OTHERS                  = 8.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

ENDFORM.


FORM zsave_records.
ENDFORM.