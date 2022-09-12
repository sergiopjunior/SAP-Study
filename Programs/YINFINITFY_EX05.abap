*&---------------------------------------------------------------------*
*& Report ZPG_SP_EX05                                                  *
*& Exercício 5 da Apostila-ABAP:                                       *
*& Conte quantas vogais há no nome do usuário executando o programa e  *
*& imprima o resultado.                                                *
*&---------------------------------------------------------------------*

REPORT YINFINITFY_EX05.

DATA: p_result TYPE char64.

SELECTION-SCREEN: BEGIN OF BLOCK b0 WITH FRAME TITLE TEXT-000.

  PARAMETERS: p_nome TYPE char30.

SELECTION-SCREEN:END OF BLOCK b0.

START-OF-SELECTION.
  PERFORM count_vowels USING p_nome
                               CHANGING p_result.
  WRITE: p_result.

FORM count_vowels USING p_nome TYPE char30
                          CHANGING p_result.

  DATA: counter TYPE i,
        len     TYPE i,
        vowels  TYPE char5,
        temp    TYPE char10.

  vowels = 'AEIOU'.
  counter = 0.
  len = strlen( p_nome ).

  TRANSLATE p_nome TO UPPER CASE.
  DATA(index) = 0.
  WHILE sy-index <= len.

    IF p_nome+index(1) CA vowels or p_nome+index(1) CA 'É' .
      ADD 1 TO counter.
    ENDIF.
    ADD 1 TO index.
  ENDWHILE.

  MOVE counter TO temp.
  CONCATENATE 'O número de vogais em "' p_nome '"é:' temp INTO p_result SEPARATED BY ''.
ENDFORM.