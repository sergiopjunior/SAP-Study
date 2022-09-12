*&---------------------------------------------------------------------*
*& Report YOOP_TEST
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT YOOP_TEST.

CLASS animal DEFINITION.

  PUBLIC SECTION.

    DATA: cor_pele TYPE string.

    METHODS: comer.

ENDCLASS.

CLASS animal IMPLEMENTATION.

  METHOD: comer.
    WRITE: 'O animal comeu!', /.
  ENDMETHOD.

ENDCLASS.


CLASS ave DEFINITION INHERITING FROM animal.

  PUBLIC SECTION.
    METHODS: voar,
      comer REDEFINITION.

ENDCLASS.

CLASS ave IMPLEMENTATION.

  METHOD: voar.
    WRITE: 'A ave voou!', /.
  ENDMETHOD.

  METHOD: comer.
    WRITE: 'A ave comeu!', /.
  ENDMETHOD.

ENDCLASS.

DATA: cl_animal TYPE REF TO animal,
      cl_ave    TYPE REF TO ave.

INITIALIZATION.
  CREATE OBJECT cl_animal.
  cl_animal->cor_pele = 'Branca'.
  cl_animal->comer( ).
  WRITE: 'Cor da pele: ', cl_animal->cor_pele, /.

  CREATE OBJECT cl_ave.
  cl_ave->cor_pele = 'Preto'.
  cl_ave->comer( ).
  cl_ave->voar( ).
  WRITE: 'Cor da pele: ', cl_ave->cor_pele, /.