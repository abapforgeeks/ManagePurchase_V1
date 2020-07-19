@AbapCatalog.sqlViewName: 'ZDOC_CAT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Document Category Text'
@ObjectModel.dataCategory: #TEXT
@VDM.viewType: #BASIC
define view ZDoc_Category_Text
  as select from zpo_category
{
  //zpo_category
  @ObjectModel.text.element: ['desctiption']
  key pocat,
  @Semantics.text: true
  desctiption
 }
