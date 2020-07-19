@AbapCatalog.sqlViewName: 'ZPO_STAT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@ObjectModel.dataCategory: #TEXT
@VDM.viewType: #BASIC
@ObjectModel.representativeKey: 'status'
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Purchase Order Status'
@Search.searchable: true
@ObjectModel.resultSet.sizeCategory: #XS
define view Z_I_PO_Status
  as select from zpo_status
{
      //zpo_status
      @EndUserText.label: 'PO Status'
      @ObjectModel.text.element: ['description']
  key status,
      @Semantics.language: true
  key language,
      @Semantics.text: true
      @EndUserText.label: 'PO Status Des.'
      @Search:{  defaultSearchElement: true,ranking: #HIGH,fuzzinessThreshold: 0.7}
      description
}
