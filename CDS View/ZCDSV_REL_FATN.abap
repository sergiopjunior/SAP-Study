@EndUserText.label: 'Relatório de Produtos Por Notas Fiscais'
@ClientDependent: true
define table function ZCDSV_REL_FATN
  with parameters
    sel_opt : abap.char(1000)
returns
{
  mandt : abap.clnt;
  NFENUM : j_1bnfnum9;
  series : j_1bseries;
  docnum : j_1bdocnum;
  credat : j_1bcredat;
  matnr : matnr;
  menge : j_1bnetqty;
  nftot : j_1bnftot;
  cgc : j_1bcgc;
}
implemented by method
  zcl_amdp_fatn=>get_data;