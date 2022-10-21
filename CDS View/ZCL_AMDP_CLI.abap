CLASS zcl_amdp_cli DEFINITION PUBLIC.
  PUBLIC SECTION.
    INTERFACES if_amdp_marker_hdb.
    CLASS-METHODS get_data FOR TABLE FUNCTION ZCDSV_REL_CLIE.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_amdp_cli IMPLEMENTATION.
  METHOD get_data BY DATABASE FUNCTION
        FOR HDB
        LANGUAGE SQLSCRIPT
        OPTIONS READ-ONLY
        USING kna1 adrc.

    lt_kna1 = apply_filter ( kna1 , :sel_opt );

    RETURN SELECT
    k.mandt,
    k.kunnr,
    k.name1,
    k.adrnr,
    a.street,
    a.city1,
    a.post_code1,
    a.city2,
    a.region,
    a.country,
    a.tel_number,
    k.stcd1,
    k.stcd3,
    k.stcd2,
    a.house_num1,
    a.house_num2,
    k.txjcd
    from :lt_kna1 as k
    left join adrc as a on a.addrnumber = k.adrnr and a.client = k.mandt
    order by k.mandt, k.kunnr;

  endmethod.
ENDCLASS.