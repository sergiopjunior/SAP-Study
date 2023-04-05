FUNCTION ybapi_customer_create.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(CUSTOMER) TYPE  YCUSTOMER
*"     VALUE(ADDRESS) TYPE  YADDRESS
*"  EXPORTING
*"     VALUE(CUST_NBR) TYPE  YCUSTOMER-CUST_NBR
*"  EXCEPTIONS
*"      INCONSISTENT_ADDRESS_DATA
*"      EMPTY_NAME
*"      CUST_NBR_CREATION_ERROR
*"      ERROR_SAVING_RECORD
*"      CUSTOMER_NOT_FOUND
*"----------------------------------------------------------------------

  IF customer-first_name IS INITIAL.
    RAISE empty_name.
  ENDIF.

  IF customer-cust_nbr IS INITIAL.
    CALL FUNCTION 'YBAPI_ADDRESS_CREATE'
      EXPORTING
        address                   = address
      IMPORTING
        addrnr                    = customer-addrnr
      EXCEPTIONS
        address_not_found         = 1
        country_missing           = 2
        region_missing            = 3
        lang_missing              = 4
        addrnr_creation_error     = 5
        invalid_identity_document = 6
        OTHERS                    = 7.
    IF sy-subrc <> 0.
      RAISE inconsistent_address_data.
    ENDIF.

    CALL FUNCTION 'NUMBER_GET_NEXT'
      EXPORTING
        nr_range_nr             = '01'
        object                  = 'YCUSTNR'
      IMPORTING
        number                  = customer-cust_nbr
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
      RAISE cust_nbr_creation_error.
    ENDIF.

    INSERT ycustomer FROM customer.

    IF sy-subrc = 0.
      COMMIT WORK.
      cust_nbr = customer-cust_nbr.
    ELSE.
      ROLLBACK WORK.
      RAISE error_saving_record.
    ENDIF.
  ELSE.
    SELECT SINGLE cust~cust_nbr,
                    adrc~addrnr
      FROM ycustomer AS cust
      LEFT JOIN yaddress AS adrc ON adrc~addrnr = @customer-addrnr
      INTO @DATA(lw_customer)
      WHERE cust~cust_nbr = @customer-cust_nbr.

    IF sy-subrc <> 0.
      RAISE customer_not_found.
    ENDIF.

    CALL FUNCTION 'YBAPI_ADDRESS_CREATE'
      EXPORTING
        address                   = address
      IMPORTING
        addrnr                    = customer-addrnr
      EXCEPTIONS
        address_not_found         = 1
        country_missing           = 2
        region_missing            = 3
        lang_missing              = 4
        addrnr_creation_error     = 5
        invalid_identity_document = 6
        OTHERS                    = 7.
    IF sy-subrc <> 0.
      RAISE inconsistent_address_data.
    ENDIF.

    MODIFY ycustomer FROM customer.

    IF sy-subrc = 0.
      COMMIT WORK.
      cust_nbr = customer-cust_nbr.
    ELSE.
      ROLLBACK WORK.
      RAISE error_saving_record.
    ENDIF.
  ENDIF.

ENDFUNCTION.