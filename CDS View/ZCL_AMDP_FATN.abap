<<<<<<< HEAD
CLASS zcl_amdp_fatn DEFINITION PUBLIC.
  PUBLIC SECTION.
    INTERFACES if_amdp_marker_hdb.
    CLASS-METHODS get_data FOR TABLE FUNCTION zcdsv_rel_fatn.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_amdp_fatn IMPLEMENTATION.
  METHOD get_data BY DATABASE FUNCTION FOR HDB LANGUAGE SQLSCRIPT OPTIONS READ-ONLY USING j_1bnfdoc j_1bnflin.

    lt_j_1bnfdoc = apply_filter ( j_1bnfdoc , :sel_opt );

    RETURN SELECT
    doc.mandt,
    doc.nfenum,
    doc.series,
    r.docnum,
    doc.credat,
    r.matnr,
    r.menge,
    doc.nftot,
    doc.cgc
    from j_1bnflin as r right join j_1bnfdoc as doc on doc.docnum = r.docnum and doc.mandt = r.mandt
    order by doc.mandt, doc.nfenum, doc.series, r.docnum;

  endmethod.
=======
CLASS zcl_amdp_fatn DEFINITION PUBLIC.
  PUBLIC SECTION.
    INTERFACES if_amdp_marker_hdb.
    CLASS-METHODS get_data FOR TABLE FUNCTION zcdsv_rel_fatn.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_amdp_fatn IMPLEMENTATION.
  METHOD get_data BY DATABASE FUNCTION FOR HDB LANGUAGE SQLSCRIPT OPTIONS READ-ONLY USING j_1bnfdoc j_1bnflin.

    lt_j_1bnfdoc = apply_filter ( j_1bnfdoc , :sel_opt );

    RETURN SELECT
    doc.mandt,
    doc.nfenum,
    doc.series,
    r.docnum,
    doc.credat,
    r.matnr,
    r.menge,
    doc.nftot,
    doc.cgc
    from j_1bnflin as r right join j_1bnfdoc as doc on doc.docnum = r.docnum and doc.mandt = r.mandt
    order by doc.mandt, doc.nfenum, doc.series, r.docnum;

  endmethod.
>>>>>>> origin/main
ENDCLASS.