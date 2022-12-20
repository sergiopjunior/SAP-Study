class ZCL_AMDP_EX33 definition public.


  public section.

interfaces if_amdp_marker_hdb.

class-methods amdp_function for table function ZCDS_DDL_EX34.

ENDCLASS.



CLASS ZCL_AMDP_EX33 IMPLEMENTATION.

method amdp_function by database function
                        for hdb
                        language sqlscript
                        options read-only
                        using scarr.

lt_scarr = apply_filter (scarr , :sel_opt_carrid );

          return select mandt, carrid, carrname, currcode, url
                        from :lt_scarr ;


endmethod.


ENDCLASS.
