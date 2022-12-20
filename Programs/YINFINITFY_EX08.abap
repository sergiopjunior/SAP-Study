*&---------------------------------------------------------------------*
*& Report YINFINITFY_EX08                                              *
*&                                                                     *
*& Faça uma rotina que receba dois números e retorne o maior deles     *
*& (caso os números sejam iguais retorne o próprio número).            *
*&---------------------------------------------------------------------*

REPORT yinfinitfy_ex08.

DATA: v_result TYPE i.

SELECTION-SCREEN: BEGIN OF BLOCK b0 WITH FRAME TITLE TEXT-000.
PARAMETERS: p_num1 TYPE i,
            p_num2 TYPE i.

SELECTION-SCREEN: END OF BLOCK b0.

START-OF-SELECTION.
  PERFORM get_greater_number USING p_num1 p_num2 CHANGING v_result.

  write: v_result.

FORM get_greater_number USING p_num1 p_num2 CHANGING v_result.
  IF p_num1 GE p_num2.
     v_result = p_num1.
  ELSEIF p_num1 LT p_num2.
    v_result = p_num2.
  ENDIF.
ENDFORM.