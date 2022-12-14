class ZCL_AMDP_EX31 definition public. " public - global class
public section.
interfaces if_amdp_marker_hdb.

types: ty_scustom type table of scarr.

class-methods amdp_procedure
      importing
                value(iv_sel_opt_carrid) type string
      exporting
                value(et_scarr) type ty_scarr.
ENDCLASS.

CLASS ZCL_AMDP_EX31 IMPLEMENTATION.
method amdp_procedure by database procedure
                   for hdb
                   language sqlscript
                   options read-only
                   using scarr.
       et_scarr = apply_filter (SCARR, :iv_sel_opt_carrid);
endmethod.
ENDCLASS.

