@EndUserText.label: 'CDS table function'
define table function ZCDS_DDL_EX20
with parameters @Environment.systemField: #CLIENT
                i_mandt : s_mandt,
                i_name  : s_carrname
returns {
  mandt : s_mandt;
  carrid : s_carr_id;
  carrname : s_carrname;
  currcode : s_currcode;
  url : s_carrurl;
  
}
implemented by method ZCL_AMDP_EX21=>AMDP_FUNCTION;
