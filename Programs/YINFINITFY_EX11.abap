*&---------------------------------------------------------------------*
*& Report YINFINITFY_EX11                                              *
*&                                                                     *
*Faça uma rotina que deve conter uma workarea com 5 campos de tipos    *
*diferentes ou mais, esta deve ser populada e os seus campos devem ser *
*& impressos um em cada linha, separados por duas linhas horizontais.  *
*&---------------------------------------------------------------------*

REPORT yinfinitfy_ex11.

TYPES: BEGIN OF ty_pessoas,
         registro TYPE numc10, "1234567890
         nome     TYPE char20, "Sérgio
         peso     TYPE p decimals 2, "63.65
         idade    TYPE i, "17
         data     TYPE dats, "YYYYMMDD
       END OF ty_pessoas.

DATA: it_pessoas TYPE TABLE OF ty_pessoas.

START-OF-SELECTION.

  PERFORM inserir_pessoa USING '0124786547' 'Sérgio' '64.5' 24 '20220717'.
  PERFORM inserir_pessoa USING '4264586241' 'Cristina' '47' 17 '20220715'.
  PERFORM inserir_pessoa USING '0064232571' 'Vera' '53.42' 17 '20220715'.

  PERFORM exibir_pessoas.

FORM exibir_pessoas.

  DATA: wa_pessoas LIKE LINE OF it_pessoas.

  LOOP AT it_pessoas INTO wa_pessoas.
    WRITE: wa_pessoas-registro, wa_pessoas-nome, wa_pessoas-peso, wa_pessoas-idade, wa_pessoas-data, /.
    ULINE.
    ULINE.
  ENDLOOP.

ENDFORM.

FORM inserir_pessoa USING p_registro p_nome p_peso  p_idade p_data.

  DATA: wa_pessoas LIKE LINE OF it_pessoas.

  wa_pessoas-registro = p_registro.
  wa_pessoas-nome = p_nome.
  wa_pessoas-peso = p_peso.
  wa_pessoas-idade = p_idade.
  wa_pessoas-data = p_data.
  APPEND wa_pessoas TO it_pessoas.

ENDFORM.