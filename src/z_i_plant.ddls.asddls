@AbapCatalog.sqlViewName: 'ZPOPLANT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Plant Details'
define view Z_I_Plant
  as select from t001w
{
      //T001W
      @EndUserText:{label: 'Plant' }
      @ObjectModel.text.element: ['Name']
  key werks as Plant,
      @Semantics.text: true
      name1 as Name
}
