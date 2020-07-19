@AbapCatalog.sqlViewName: 'ZPOPRIO'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@ObjectModel.dataCategory: #TEXT
@EndUserText.label: 'PO Priority'

define view Z_I_PO_Priority
  as select from zpo_priority
{
      //zpo_priority
      @ObjectModel.text.element: ['description']
  key priority,
      @Semantics.language: true
  key language,
      @Semantics.text: true
      @EndUserText.label: 'Priority Desc.'
      description
}
