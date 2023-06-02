  METHOD zii_si_pass_reset_inbound~pass_reset.
    CONSTANTS lc_bapi_success TYPE bapiret2-number VALUE '039'.
    CONSTANTS lc_success(1) TYPE c VALUE '0'.
    CONSTANTS lc_error(1) TYPE c VALUE '1'.
    DATA lt_bapimsg TYPE TABLE OF bapiret2.
    DATA lv_generated_pass TYPE bapipwd VALUE 'SAP@2023'.

    CALL FUNCTION 'BAPI_USER_CHANGE'
      EXPORTING
        username  = CONV bapibname-bapibname( input-mt_pass_reset_outbound-username )
        password  = lv_generated_pass
        passwordx = abap_true
*       productive_pwd     = ' '
*       generate_pwd       = abap_true
*      IMPORTING
*       generated_password = lv_generated_pass
      TABLES
        return    = lt_bapimsg.

    output-mt_pass_reset_inbound-password = lv_generated_pass.
    output-mt_pass_reset_inbound-status = COND #( WHEN line_exists( lt_bapimsg[ number = lc_bapi_success ] )
                                                   THEN lc_success ELSE lc_error ) .
  ENDMETHOD.