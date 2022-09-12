*&---------------------------------------------------------------------*
*& Report ZPG_SP_EX04                                                  *
*& Exercício 4 da Apostila-ABAP:                                       *
*& Leia a hora atual do sistema e escreva o horário em 6 diferentes    *
*& fusos (3 deles devem ser obrigatoriamente Greenwich, Brasília e o   *
*& Delhi).                                                             *
*&---------------------------------------------------------------------*

REPORT YINFINITFY_EX04.

START-OF-SELECTION.
  GET TIME.

  DATA v_data TYPE char11.

  PERFORM get_time USING '+0' '0' CHANGING v_data.
  WRITE: 'Greenwich UTC+0: ', v_data, /.

  PERFORM get_time USING '-3' '0' CHANGING v_data.
  WRITE: 'Brasília UTC-3: ', v_data, /.

  PERFORM get_time USING '+5' '30' CHANGING v_data.
  WRITE: 'Delhi UTC+5:30: ', v_data, /.

  PERFORM get_time USING '+9' '0' CHANGING v_data.
  WRITE: 'Tokyo UTC+9: ', v_data, /.

  PERFORM get_time USING '+8' '0' CHANGING v_data.
  WRITE: 'Pequim UTC+8: ', v_data, /.

  PERFORM get_time USING '+1' '0' CHANGING v_data.
  WRITE: 'Londres UTC+1: ', v_data, /.


FORM get_time USING p_utc_h TYPE char3 p_utc_m TYPE char2 CHANGING v_data.
  DATA(v_time) = sy-timlo.
  DATA(v_hora_conv) = CONV char2( CONV i( v_time(2) ) + CONV i( p_utc_h ) ).
  DATA(v_min_conv) = CONV char2( CONV i( v_time+2(2) ) + CONV i( p_utc_m ) ).

  WHILE v_min_conv GE 60.
    v_min_conv = v_min_conv - 60.
    ADD 1 TO v_hora_conv.
  ENDWHILE.

  IF v_hora_conv GT 24.
    v_hora_conv = v_hora_conv - 24.
  ENDIF.

  IF v_hora_conv LT 10.
    DATA temp TYPE char2.
    CONCATENATE '0' v_hora_conv INTO temp.
    v_hora_conv = temp.
  ELSEIF v_hora_conv EQ 24.
    v_hora_conv = '00'.
  ENDIF.


  CONCATENATE v_hora_conv v_min_conv v_time+4(2) INTO v_data SEPARATED BY ':'.

ENDFORM.