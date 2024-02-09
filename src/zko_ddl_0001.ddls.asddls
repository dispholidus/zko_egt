@AbapCatalog.sqlViewName: 'ZKO_CDS_0001'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS_0001'
define view ZKO_DDL_0001
  as select from tadir
{
  pgmid,
  object,
  obj_name,
  author
}
where
  author = 'KEMALO' 
 