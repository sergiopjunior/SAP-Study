*&---------------------------------------------------------------------*
*& Report ZPG_SP_EX01                                                  *
*& Exercício 1 da Apostila-ABAP:                                       *
*& Concatene duas palavras e escreva o resultado.                      *
*&---------------------------------------------------------------------*

REPORT YINFINITFY_EX01.

DATA: p_reslt TYPE char40.

SELECTION-SCREEN: BEGIN OF BLOCK b0 WITH FRAME TITLE TEXT-000.

  PARAMETERS: p_word1 TYPE char20,
              p_word2 TYPE char20.

SELECTION-SCREEN:END OF BLOCK b0.

START-OF-SELECTION.
  PERFORM concat_words USING p_word1
                               p_word2
                               CHANGING p_reslt.

FORM concat_words  USING p_word_1 TYPE char20
                          p_word_2 TYPE char20
                          CHANGING p_reslt.

  CONCATENATE p_word1 p_word2 INTO p_reslt SEPARATED BY ' '.
  WRITE:  p_reslt.

ENDFORM.