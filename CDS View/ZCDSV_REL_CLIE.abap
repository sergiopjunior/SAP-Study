<<<<<<< HEAD
@EndUserText.label: 'Relátorio de Clientes'
@ClientDependent: true
define table function ZCDSV_REL_CLIE
with parameters
            sel_opt : abap.char(1000)
    returns {
        mandt : abap.clnt;
        kunnr : kunnr;
        name1 : name1_gp;
        adrnr : adrnr;
        street : ad_street;
        city1 : ad_city1;
        post_code1 : ad_pstcd1;
        city2 : ad_city2;
        region : regio;
        country : land1;
        tel_number : ad_tlnmbr1;
        stcd1 : stcd1;
        stcd3 : stcd3;
        stcd2 : stcd2;
        house_num1 : ad_hsnm1;
        house_num2 : ad_hsnm2;    
        txjcd :txjcd;               
        }
implemented by method
=======
@EndUserText.label: 'Relátorio de Clientes'
@ClientDependent: true
define table function ZCDSV_REL_CLIE
with parameters
            sel_opt : abap.char(1000)
    returns {
        mandt : abap.clnt;
        kunnr : kunnr;
        name1 : name1_gp;
        adrnr : adrnr;
        street : ad_street;
        city1 : ad_city1;
        post_code1 : ad_pstcd1;
        city2 : ad_city2;
        region : regio;
        country : land1;
        tel_number : ad_tlnmbr1;
        stcd1 : stcd1;
        stcd3 : stcd3;
        stcd2 : stcd2;
        house_num1 : ad_hsnm1;
        house_num2 : ad_hsnm2;    
        txjcd :txjcd;               
        }
implemented by method
>>>>>>> origin/main
  zcl_amdp_cli=>get_data;