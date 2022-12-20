@AbapCatalog.sqlViewName: 'ZCDS_SQL_EX12'
@EndUserText.label: 'exposed associations'
define view ZCDS_DDL_EX12 as select from sbook as a
    association to scustom as _b
    on a.customid = _b.id  
   {
    a.carrid,    
    a.connid,
    a.fldate,
    a.bookid, 
    a.customid, 
    _b  
    } 
  

 
