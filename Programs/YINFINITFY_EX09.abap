*&---------------------------------------------------------------------*
*& Report YINFINITFY_EX09                                              *
*&                                                                     *
*& Faça uma rotina que receba dois números e retorne um flag (caracter *
*& de tamanho 1). Caso os números sejam iguais a flag retornada será   *
*& ‘X’ e caso contrário a flag será igual a ‘ ‘ (space).               *
*&---------------------------------------------------------------------*

REPORT yinfinitfy_ex09.

DATA: v_flag TYPE char1.

SELECTION-SCREEN: BEGIN OF BLOCK b0 WITH FRAME TITLE TEXT-000.
PARAMETERS: p_num1 TYPE i,
            p_num2 TYPE i.

SELECTION-SCREEN: END OF BLOCK b0.

START-OF-SELECTION.
  PERFORM get_flag USING p_num1 p_num2 CHANGING v_flag.

  WRITE: 'Flag:', v_flag.

FORM get_flag USING p_num1 p_num2 CHANGING v_flag.
  IF p_num1 EQ p_num2.
    v_flag = 'X'.
  ELSE.
    v_flag = ' '.
  ENDIF.
ENDFORM.