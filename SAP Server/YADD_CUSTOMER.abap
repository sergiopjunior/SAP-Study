*&---------------------------------------------------------------------*
*& Report YADD_USER
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT yadd_user.

" Constants
CONSTANTS gc_success(1) TYPE c VALUE 'S' ##NEEDED.
CONSTANTS gc_error(1) TYPE c VALUE 'E' ##NEEDED.

" Workareas
DATA wa_customer TYPE ycustomer ##NEEDED.
DATA wa_address TYPE yaddress ##NEEDED.

" Variables
DATA gv_message TYPE string ##NEEDED.
DATA gv_status(1) TYPE c ##NEEDED.

SELECTION-SCREEN: BEGIN OF BLOCK b_main WITH FRAME TITLE TEXT-000.
PARAMETER p_fname TYPE ycustomer-first_name OBLIGATORY.
PARAMETER p_lname TYPE ycustomer-last_name.
PARAMETER p_bdate TYPE ycustomer-bdate.
PARAMETER p_cnpj TYPE yaddress-cnpj.
PARAMETER p_cpf TYPE yaddress-cpf.
PARAMETER p_adname TYPE yaddress-name.
PARAMETER p_telf1 TYPE yaddress-telf1.
PARAMETER p_telf2 TYPE yaddress-telf2.
PARAMETER p_telfx TYPE yaddress-telfx.
PARAMETER p_cntry TYPE yaddress-country OBLIGATORY.
PARAMETER p_lang TYPE yaddress-lang OBLIGATORY.
PARAMETER p_region TYPE yaddress-region OBLIGATORY.
PARAMETER p_city TYPE yaddress-city.
PARAMETER p_pcode TYPE yaddress-post_code.
PARAMETER p_nhood TYPE yaddress-neighborhood.
PARAMETER p_street TYPE yaddress-street.
PARAMETER p_honum TYPE yaddress-house_num.
PARAMETER p_build TYPE yaddress-building.
PARAMETER p_floor TYPE yaddress-floor.
PARAMETER p_ronum TYPE yaddress-roomnumber.

SELECTION-SCREEN: END OF BLOCK b_main.

START-OF-SELECTION.
  IF p_cnpj IS INITIAL AND p_cpf IS INITIAL.
    MESSAGE s208(00) DISPLAY LIKE sy-abcde+4(1) WITH TEXT-e01.
    LEAVE LIST-PROCESSING.
  ENDIF.

  PERFORM zf_create_record.
  PERFORM zf_save_records.

  MESSAGE s208(00) DISPLAY LIKE gv_status WITH gv_message.

FORM zf_create_record .
  wa_customer-first_name = p_fname.
  wa_customer-last_name = p_lname.
  wa_customer-bdate = p_bdate.

  wa_address-cnpj = p_cnpj.
  wa_address-cpf = p_cpf.
  wa_address-name = p_adname.
  wa_address-telf1 = p_telf1.
  wa_address-telf2 = p_telf2.
  wa_address-telfx = p_telfx.
  wa_address-country = p_cntry.
  wa_address-lang = p_lang.
  wa_address-region = p_region.
  wa_address-city = p_city.
  wa_address-post_code = p_pcode.
  wa_address-neighborhood = p_nhood.
  wa_address-street = p_street.
  wa_address-house_num = p_honum.
  wa_address-building = p_build.
  wa_address-floor = p_floor.
  wa_address-roomnumber = p_ronum.
ENDFORM.

FORM zf_save_records.
  DATA lv_created_cust TYPE ycustomer-cust_nbr.

  CALL FUNCTION 'YBAPI_CUSTOMER_CREATE'
    EXPORTING
      customer                  = wa_customer
      address                   = wa_address
    IMPORTING
      cust_nbr                  = lv_created_cust
    EXCEPTIONS
      inconsistent_address_data = 1
      empty_name                = 2
      cust_nbr_creation_error   = 3
      error_saving_record       = 4
      customer_not_found        = 5
      OTHERS                    = 6.

  gv_message = COND #( WHEN sy-subrc = 0 THEN |{ TEXT-s01 } { lv_created_cust } { TEXT-s02 }| ELSE TEXT-e02 ).
  gv_status = COND #( WHEN sy-subrc = 0 THEN gc_success ELSE gc_error ).

ENDFORM.