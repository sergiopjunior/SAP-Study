*&---------------------------------------------------------------------*
*& Report zreport23
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zreport23.

data: lv_sql type string.
data:lt_scarr type table of scarr.
data:lr_scarr type ref to data.

try.

" Create a statement object, Instantiation of class CL_SQL_STATEMENT
 data(lo_sql) = new cl_sql_statement( ).

"Fill string variable with SQL syntax
CONCATENATE
     `SELECT * `
     `FROM SCARR `
     `WHERE mandt = '` sy-mandt `' `     " explicit client handling
     `AND   carrid = '` 'AA' `' `
     INTO lv_sql.

"Call method CL_SQL_STATEMENT-> execute_query()  to issue native SQL call
 data(lo_result) = lo_sql->execute_query( lv_sql ).
"Call method set_param() or set_param_table() of class CL_SQL_RESULT_SET to assign target variable for result set:
  get REFERENCE OF lt_scarr into lr_scarr.
  lo_result->set_param_table( lr_scarr ).
"Call method next_package() of class CL_SQL_RESULT_SET to retrieve result set:
  lo_result->next_package( ).
"Call Method close() of class CL_SQL_RESULT_SET to close result and release resources
  lo_result->close( ).

 catch cx_sql_exception.  "to handle exceptions

 ENDTRY.


data: lo_scarr type ref to cl_salv_table.
 TRY.
 CALL METHOD cl_salv_table=>factory
   IMPORTING
     r_salv_table   =  lo_scarr
   CHANGING
     t_table        =  lt_scarr
     .
  CATCH cx_salv_msg .
 ENDTRY.

 lo_scarr->display( ).
