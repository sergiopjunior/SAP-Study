*&---------------------------------------------------------------------*
*& Report YADD_MATERIAL
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT yadd_material.

SELECTION-SCREEN: BEGIN OF BLOCK b_main WITH FRAME TITLE TEXT-001.

PARAMETERS: p_mtyp  TYPE ymat_type-mtype,
            p_inds  TYPE yinds-indesc,
            p_brand TYPE ybrand-brand_name,
            p_mtgp  TYPE ymat_group-mtgpdesc,
            p_price TYPE ymaterial-price OBLIGATORY,
            p_desc type ymaterial-maktx OBLIGATORY.

SELECTION-SCREEN: END OF BLOCK b_main.

START-OF-SELECTION.
  DATA: mat_nbr TYPE ymaterial-matnr,
        error   TYPE flag VALUE ''.

  PERFORM: zget_next_code CHANGING mat_nbr,
            zsave_records USING mat_nbr CHANGING error.

  IF error EQ abap_false.
    MESSAGE s208(00) DISPLAY LIKE 'S' WITH TEXT-s01.
  ELSE.
    MESSAGE s208(00) DISPLAY LIKE 'E' WITH TEXT-s02.
  ENDIF.


FORM zget_next_code CHANGING out_mat_nbr.
  CALL FUNCTION 'NUMBER_GET_NEXT'
    EXPORTING
      nr_range_nr             = '01'
      object                  = 'YMATNR'
    IMPORTING
      number                  = out_mat_nbr
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

FORM zsave_records USING mat_nbr CHANGING error.
  DATA: lw_mat       TYPE ymaterial.

  IF p_mtyp IS NOT INITIAL.
    SELECT SINGLE mtart
      FROM ymat_type
      INTO lw_mat-mtart
      WHERE mtype = p_mtyp.

    IF sy-subrc NE 0.
      error = abap_true.
    ENDIF.

  ENDIF.

  IF p_inds IS NOT INITIAL.
    SELECT SINGLE mbrsh
      FROM yinds
      INTO lw_mat-mbrsh
      WHERE indesc = p_inds.

    IF sy-subrc NE 0.
      error = abap_true.
    ENDIF.
  ENDIF.

  IF p_brand IS NOT INITIAL.
    SELECT SINGLE brand_nbr
      FROM ybrand
      INTO lw_mat-brand_nbr
      WHERE brand_name = p_brand.

    IF sy-subrc NE 0.
      error = abap_true.
    ENDIF.
  ENDIF.

  IF p_mtgp IS NOT INITIAL.
    SELECT SINGLE matkl
      FROM ymat_group
      INTO lw_mat-matkl
      WHERE mtgpdesc = p_mtgp.

    IF sy-subrc NE 0.
      error = abap_true.
    ENDIF.
  ENDIF.

  IF error EQ abap_false.
    lw_mat-matnr = mat_nbr.
    lw_mat-price = p_price.
    lw_mat-maktx = p_desc.

    INSERT INTO ymaterial VALUES lw_mat.
  ENDIF.

ENDFORM.