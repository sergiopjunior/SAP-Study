*&---------------------------------------------------------------------*
*& Report ZPG_SP_EX03                                                  *
*& Exercício 3 da Apostila-ABAP:                                       *
*& Leia a data atual do sistema e escreva em português a data por      *
*& extenso.                                                            *
*&---------------------------------------------------------------------*

REPORT YINFINITFY_EX03.

DATA: tb_dias         TYPE STANDARD TABLE OF char20
  WITH EMPTY KEY,
      idioma          TYPE lang VALUE 'P',
      p_data          TYPE char8,
      p_dia           TYPE char2,
      p_dia_semana    TYPE char20,
      p_mes           TYPE char2,
      p_mes_escrito   TYPE char20,
      p_ano           TYPE char4,
      p_data_completa TYPE char64.


INITIALIZATION.
  tb_dias = VALUE #(
  ( 'Segunda-feira' )
  ( 'Terça-feira' )
  ( 'Quarta-feira' )
  ( 'Quinta-feira' )
  ( 'Sexta-feira' )
  ( 'Sábado' )
  ( 'Domingo' )
  ).

  p_dia = sy-datum+6(2).
  p_mes = CONV i( sy-datum+4(2) ).
  p_ano = sy-datum(4).


START-OF-SELECTION.

  PERFORM get_dia_semana CHANGING p_dia_semana.
  PERFORM get_mes_escrito USING p_mes CHANGING p_mes_escrito.

  CONCATENATE p_dia_semana ',' INTO p_data_completa.
  CONCATENATE p_data_completa p_dia 'de' p_mes_escrito 'de' p_ano INTO p_data_completa SEPARATED BY space.
  WRITE: p_data_completa.

FORM get_dia_semana CHANGING p_dia_semana.

  DATA: dia      TYPE c,
        iterator TYPE i VALUE 1.

  CALL FUNCTION 'DATE_COMPUTE_DAY'
    EXPORTING
      date = sy-datum
    IMPORTING
      day  = dia.

  LOOP AT tb_dias INTO DATA(char20).
    IF iterator EQ CONV i( dia ).
      p_dia_semana = char20.
    ENDIF.
    ADD 1 TO iterator.
  ENDLOOP.

ENDFORM.

FORM get_mes_escrito USING mes TYPE char2 CHANGING p_mes_escrito.

  SELECT SINGLE LTX FROM t247 WHERE spras = @idioma AND mnr = @mes INTO @p_mes_escrito.

ENDFORM.