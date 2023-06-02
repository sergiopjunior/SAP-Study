FUNCTION ybapi_address_create.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(ADDRESS) TYPE  YADDRESS
*"  EXPORTING
*"     VALUE(ADDRNR) TYPE  YADDRESS-ADDRNR
*"  EXCEPTIONS
*"      ADDRESS_NOT_FOUND
*"      COUNTRY_MISSING
*"      REGION_MISSING
*"      LANG_MISSING
*"      ADDRNR_CREATION_ERROR
*"      INVALID_IDENTITY_DOCUMENT
*"      ERROR_SAVING_RECORD
*"      INVALID_ADDRESS_TYPE
*"----------------------------------------------------------------------
  IF address-country IS INITIAL.
    RAISE country_missing.
  ELSEIF address-region IS INITIAL.
    RAISE region_missing.
  ELSEIF address-lang IS INITIAL.
    RAISE lang_missing.
  ELSEIF address-cnpj IS INITIAL AND address-city IS INITIAL.
    RAISE invalid_identity_document.
  ELSE.
    SELECT SINGLE title FROM tsad3 INTO @DATA(lv_title) WHERE title = @address-title.
    IF lv_title IS INITIAL.
      RAISE invalid_address_type.
    ENDIF.
  ENDIF.

  IF address-addrnr IS INITIAL.
    CALL FUNCTION 'NUMBER_GET_NEXT'
      EXPORTING
        nr_range_nr             = '01'
        object                  = 'YADDRNR'
      IMPORTING
        number                  = address-addrnr
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
      RAISE addrnr_creation_error.
    ENDIF.

    INSERT yaddress FROM address.

    IF sy-subrc = 0.
      COMMIT WORK.
      addrnr = address-addrnr.
    ELSE.
      ROLLBACK WORK.
      RAISE error_saving_record.
    ENDIF.
  ELSE.
    SELECT SINGLE addrnr FROM yaddress INTO @DATA(lv_address) WHERE addrnr = @address-addrnr.

    IF sy-subrc <> 0.
      RAISE address_not_found.
    ENDIF.

    MODIFY yaddress FROM address.

    IF sy-subrc = 0.
      COMMIT WORK.
      addrnr = address-addrnr.
    ELSE.
      ROLLBACK WORK.
      RAISE error_saving_record.
    ENDIF.
  ENDIF.

ENDFUNCTION.