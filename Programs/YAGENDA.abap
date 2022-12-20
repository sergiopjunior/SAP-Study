*&---------------------------------------------------------------------*
*& Report YAGENDA
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT yagenda.

*& Structures
TYPES: BEGIN OF ty_agenda,
         nome      TYPE c LENGTH 20, "Sérgio
         sobrenome TYPE c LENGTH 40, "Pontes
         idade     TYPE i, "17
         telefone  TYPE c LENGTH 15, "(000)00000-0000
       END OF ty_agenda.

*& Internal Tables
DATA: it_agenda TYPE TABLE OF ty_agenda.

*& Work-area
DATA: wa_agenda LIKE LINE OF it_agenda.

wa_agenda-nome = 'Sérgio'.
wa_agenda-sobrenome = 'Pontes'.
wa_agenda-idade = 24.
wa_agenda-telefone = '(096)99773-9519'.
APPEND wa_agenda TO it_agenda.

wa_agenda-nome = 'Julia'.
wa_agenda-sobrenome = 'da Conceição'.
wa_agenda-idade = 18.
wa_agenda-telefone = '(62)2539-7062'.
APPEND wa_agenda TO it_agenda.

wa_agenda-nome = 'Mirella'.
wa_agenda-sobrenome = 'Rocha'.
wa_agenda-idade = 18.
wa_agenda-telefone = '(62)2539-7062'.
APPEND wa_agenda TO it_agenda.

CLEAR wa_agenda.

LOOP AT it_agenda INTO wa_agenda.
  WRITE: wa_agenda-nome, wa_agenda-sobrenome.
  WRITE wa_agenda-idade.
  WRITE: wa_agenda-telefone, /.
ENDLOOP.