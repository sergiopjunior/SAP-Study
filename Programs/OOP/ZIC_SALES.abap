*&---------------------------------------------------------------------*
*& Include ZIC_SALES
*&---------------------------------------------------------------------*

CLASS cl_main DEFINITION.
    PUBLIC SECTION.
      CLASS-METHODS:
        get_sales_products
          IMPORTING
            p_salesorderuuid TYPE zdemo_soh-salesorderuuid.
  
    PRIVATE SECTION.
      TYPES: BEGIN OF ty_soh,
               salesorderuuid TYPE zdemo_soh-salesorderuuid,
               salesorder     TYPE zdemo_soh-salesorder,
             END OF ty_soh,
             BEGIN OF ty_soi,
               salesorderitemuuid TYPE zdemo_soi-salesorderitemuuid,
               salesorderuuid     TYPE zdemo_soh-salesorderuuid,
               product            TYPE zdemo_soi-product,
               grossamount        TYPE zdemo_soi-grossamount,
               quantity           TYPE zdemo_soi-quantity,
             END OF ty_soi,
             BEGIN OF ty_output,
               salesorderuuid     TYPE zdemo_soh-salesorderuuid,
               salesorder         TYPE zdemo_soh-salesorder,
               salesorderitemuuid TYPE zdemo_soi-salesorderitemuuid,
               product            TYPE zdemo_soi-product,
               grossamount        TYPE zdemo_soi-grossamount,
               quantity           TYPE zdemo_soi-quantity,
             END OF ty_output.
  
      CLASS-DATA:
        cls_main TYPE REF TO cl_main.
      DATA:
        it_soh    TYPE TABLE OF ty_soh,
        it_soi    TYPE TABLE OF ty_soi,
        it_output TYPE TABLE OF ty_output.
      DATA:
        wa_soh    TYPE ty_soh,
        wa_soi    TYPE ty_soi,
        wa_output TYPE ty_output.
  
      METHODS:
        get_data
          IMPORTING
            p_salesorderuuid TYPE zdemo_soh-salesorderuuid,
        process_data,
        make_output
           RETURNING
             VALUE(it_fieldcat) TYPE lvc_t_fcat,
        display.
  
  ENDCLASS.
  
  CLASS cl_main IMPLEMENTATION.
    METHOD get_sales_products.
      CREATE OBJECT cls_main.
      cls_main->get_data( p_salesorderuuid ).
      cls_main->process_data( ).
      cls_main->display( ).
  
    ENDMETHOD.
  
    METHOD get_data.
      SELECT salesorderuuid
           salesorder
      FROM zdemo_soh
      INTO TABLE it_soh
      WHERE salesorderuuid EQ p_salesorderuuid.
  
      IF sy-subrc EQ 0.
        SELECT salesorderuuid
               salesorderitemuuid
               product
               grossamount
               quantity
          FROM zdemo_soi
          INTO TABLE it_soi
          FOR ALL ENTRIES IN it_soh
          WHERE salesorderuuid EQ it_soh-salesorderuuid.
      ENDIF.
  
    ENDMETHOD.
  
    METHOD process_data.
      SORT: it_soh BY salesorderuuid,
            it_soi BY salesorderitemuuid.
  
      LOOP AT it_soh INTO wa_soh.
        LOOP AT it_soi INTO wa_soi.
          CLEAR wa_output.
  
          wa_output-salesorderuuid = wa_soh-salesorderuuid.
          wa_output-salesorder = wa_soh-salesorder.
  
          IF wa_soh-salesorderuuid <> wa_soi-salesorderuuid.
            wa_output-salesorderitemuuid = wa_soi-salesorderitemuuid.
            wa_output-product = wa_soi-product.
            wa_output-grossamount = wa_soi-grossamount.
            wa_output-quantity = wa_soi-quantity.
  
            IF sy-subrc EQ 0.
              APPEND wa_output TO it_output.
            ENDIF.
          ENDIF.
          CLEAR wa_soi.
        ENDLOOP.
  
        CLEAR wa_soh.
      ENDLOOP.
  
    ENDMETHOD.
  
    METHOD make_output.
      DATA wa_fieldcat TYPE lvc_s_fcat.
  
      wa_fieldcat-fieldname = 'salesorderuuid'.
      wa_fieldcat-scrtext_m = 'Order UUID'.
      APPEND wa_fieldcat TO it_fieldcat.
  
      CLEAR wa_fieldcat.
      wa_fieldcat-fieldname = 'salesorder'.
      wa_fieldcat-scrtext_m = 'Sales Order Number'.
      APPEND wa_fieldcat TO it_fieldcat.
  
      CLEAR wa_fieldcat.
      wa_fieldcat-fieldname = 'salesorderitemuuid'.
      wa_fieldcat-scrtext_m = 'Item UUID'.
      APPEND wa_fieldcat TO it_fieldcat.
  
      CLEAR wa_fieldcat.
      wa_fieldcat-fieldname = 'product'.
      wa_fieldcat-scrtext_m = 'Product ID'.
      APPEND wa_fieldcat TO it_fieldcat.
  
      CLEAR wa_fieldcat.
      wa_fieldcat-fieldname = 'grossamount'.
      wa_fieldcat-scrtext_m = 'Total Gross Amount'.
      APPEND wa_fieldcat TO it_fieldcat.
  
      CLEAR wa_fieldcat.
      wa_fieldcat-fieldname = 'quantity'.
      wa_fieldcat-scrtext_m = 'Quantity'.
      APPEND wa_fieldcat TO it_fieldcat.
  
    ENDMETHOD.
  
    METHOD display.
      DATA: wa_layout TYPE lvc_s_layo,
            wa_vari   TYPE disvariant.
  
      wa_layout-zebra = abap_true.
      wa_layout-cwidth_opt = abap_true.
  
      CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY_LVC'
        EXPORTING
          i_callback_program = sy-repid
          is_layout_lvc      = wa_layout
          it_fieldcat_lvc    = make_output( )
        TABLES
          t_outtab           = it_output
        EXCEPTIONS
          program_error      = 1
          OTHERS             = 2.
      IF sy-subrc NE 0.
        MESSAGE s208(00) DISPLAY LIKE sy-abcde+4(1) WITH TEXT-003. "Exibição de dados falhou
      ENDIF.
  
    ENDMETHOD.
  
  ENDCLASS.