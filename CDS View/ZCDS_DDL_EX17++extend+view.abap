@AbapCatalog.sqlViewAppendName: 'ZCDS_EX17_EXT'
@EndUserText.label: 'extend view'
extend view ZCDS_DDL_EX16 with ZCDS_DDL_EX17 
association to scustom as _b
on a.customid = _b.id
{
 concat(a.carrid, a.connid) as new_id,
 _b.name,
 _b.email
 

} 
   
 
