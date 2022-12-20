*&---------------------------------------------------------------------*
*& Report YFRONT_TEST
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT YFRONT_TEST.

DATA: id TYPE i.

SELECTION-SCREEN: BEGIN OF BLOCK bloco WITH FRAME TITLE TEXT-001.
PARAMETERS: p_data TYPE sy-datum,
            p_id   TYPE i.

SELECTION-SCREEN: SKIP.
SELECT-OPTIONS: so_id FOR id.

SELECTION-SCREEN: SKIP.
PARAMETERS: p_chkbox AS CHECKBOX DEFAULT ''.

SELECTION-SCREEN: SKIP.
PARAMETERS: p_radio1 RADIOBUTTON GROUP rb,
            p_radio2 RADIOBUTTON GROUP rb.


SELECTION-SCREEN: SKIP.
PARAMETERS: p_list AS LISTBOX VISIBLE LENGTH 10.

SELECTION-SCREEN: END OF BLOCK bloco.

INITIALIZATION.
  PERFORM feed_list.

FORM feed_list.
  DATA: name_list TYPE vrm_id,
        values    TYPE vrm_values,
        value     TYPE vrm_value.

  name_list = 'P_LIST'.

  value-key = '1'.
  value-text = 'Option 1'.
  APPEND value TO values.

  value-key = '2'.
  value-text = 'Option 2'.
  APPEND value TO values.

  CALL FUNCTION 'VRM_SET_VALUES'
    EXPORTING
      id     = name_list
      values = values.
ENDFORM.