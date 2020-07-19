@AbapCatalog.sqlViewName: 'ZICCODE'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Company Code COntact View'
@VDM.viewType: #BASIC
define view Z_I_CompanyCode
  as select from t001
    inner join   adrc as address on adrnr = address.addrnumber
{
  @ObjectModel.text.element: ['Name']
 key bukrs as CompanyCode,
  @Semantics.name.fullName: true
  @Semantics.text: true
  butxt as Name,
  @Semantics.address.city: true
  ort01 as City,
  @Semantics.telephone.type: [#FAX]
  address.fax_number,
  @Semantics.telephone.type: [#WORK]
  address.tel_number,
  @Semantics:{ eMail.address: true,eMail.type: [#WORK]}
  'abapforgeeks@gmail.com' as Email
}
