*&---------------------------------------------------------------------*
*& Report YADD_CITY
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT yadd_city.

TABLES: t005g,
        t005h.

SELECTION-SCREEN: BEGIN OF BLOCK b_main WITH FRAME.
SELECTION-SCREEN: BEGIN OF BLOCK b_city WITH FRAME TITLE TEXT-001.
PARAMETERS: p_lang  TYPE t005h-spras DEFAULT 'PT',
            p_land1 TYPE t005g-land1 OBLIGATORY,
            p_regio TYPE t005g-regio OBLIGATORY,
            p_bezei TYPE t005h-bezei OBLIGATORY.

SELECTION-SCREEN:END OF BLOCK b_city.
SELECTION-SCREEN: END OF BLOCK b_main.

START-OF-SELECTION.
  DATA: cityc_nbr TYPE t005g-cityc.

  PERFORM: zget_next_code CHANGING cityc_nbr,
            zsave_records USING cityc_nbr.

  MESSAGE s208(00) DISPLAY LIKE 'S' WITH TEXT-s01.

FORM zget_next_code CHANGING out_cityc_nbr.
  CALL FUNCTION 'NUMBER_GET_NEXT'
    EXPORTING
      nr_range_nr             = '01'
      object                  = 'YCITYC_NBR'
    IMPORTING
      number                  = out_cityc_nbr
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

FORM zsave_records USING cityc_nbr.
  DATA: lw_005g TYPE t005g,
        lw_005h TYPE t005h.

* T005G workarea
  lw_005g-cityc = cityc_nbr.
  lw_005g-land1 = p_land1.
  lw_005g-regio = p_regio.

* T005H workarea
  lw_005h-spras = p_lang.
  lw_005h-land1 = p_land1.
  lw_005h-regio = p_regio.
  lw_005h-cityc = cityc_nbr.
  lw_005h-bezei = p_bezei.

  INSERT INTO t005g VALUES lw_005g.
  INSERT INTO t005h VALUES lw_005h.

ENDFORM.