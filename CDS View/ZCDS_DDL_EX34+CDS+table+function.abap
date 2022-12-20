@EndUserText.label: 'CDS table function'
define table function ZCDS_DDL_EX34
with parameters sel_opt_carrid  : abap.char( 1000 )
returns {
  mandt : s_mandt;
  carrid : s_carr_id;
  carrname : s_carrname;
  currcode : s_currcode;
  url : s_carrurl;
  
}
implemented by method ZCL_AMDP_EX21=>AMDP_FUNCTION;
