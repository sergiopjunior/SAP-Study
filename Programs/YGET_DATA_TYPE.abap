*&---------------------------------------------------------------------*
*& Report YGET_DATA_TYPE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT yget_data_type.

TYPES:

my_type TYPE i.

DATA:

my_data TYPE my_type,

descr_ref TYPE ref to cl_abap_typedescr.

START-OF-SELECTION.

descr_ref = cl_abap_typedescr=>describe_by_data( my_data ).

WRITE: / 'Typename:', descr_ref->absolute_name.

WRITE: / 'Kind :', descr_ref->type_kind.

WRITE: / 'Length :', descr_ref->length.

WRITE: / 'Decimals:', descr_ref->decimals.