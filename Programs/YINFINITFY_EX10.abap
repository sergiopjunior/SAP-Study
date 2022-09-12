*&---------------------------------------------------------------------*
*& Report ZPG_SP_EX10                                                  *
*&                                                                     *
*& Faça uma rotina que recebe dois números e escreve o resultado da    *
*& operação [maior_numero / menor_numero] caso os números sejam        *
*& diferentes e escreva o resultado de [número ^ 2] caso sejam iguais. *
*&---------------------------------------------------------------------*

REPORT yinfinitfy_ex10.


SELECTION-SCREEN: BEGIN OF BLOCK b0 WITH FRAME TITLE TEXT-000.
PARAMETERS: p_num1 TYPE i,
            p_num2 TYPE i.

SELECTION-SCREEN: END OF BLOCK b0.

START-OF-SELECTION.
  PERFORM do_op USING p_num1 p_num2.

FORM do_op USING p_num1 p_num2.
  DATA: maior TYPE i,
        menor TYPE i.

  IF p_num1 EQ p_num2.
    WRITE: conv i( p_num1 ** 2 ).

  ELSE.

    IF p_num1 GT p_num2.
      maior = p_num1.
      menor = p_num2.
    ELSE.
      maior = p_num2.
      menor = p_num1.
    ENDIF.

    WRITE: CONV f( maior / menor ).
  ENDIF.

ENDFORM.