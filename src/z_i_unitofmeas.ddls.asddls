@AbapCatalog.sqlViewName: 'ZPOUOM'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@ObjectModel.dataCategory: #TEXT
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Unitof Measure'
define view Z_I_UnitofMeas
  as select from t006a
{
      //T006A
      @ObjectModel.text.element: ['msehl']
  key msehi as UomCode,
      @Semantics.language: true
  key spras as Language,
      @Semantics.text: true
      msehl
}
