@AbapCatalog.sqlViewName: 'ZI_F4TEST'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Test'
define view Z_F4_test
  as select from zpurchase_item
  association to ZDEMO_I_text_VH as _QuantityUnitValueHelp on $projection.unit = _QuantityUnitValueHelp.UnitOfMeasure
{
      //zpurchase_item
  key purchase_doc,
  key purchase_item,
      short_text,
      material,
      plant,
      storage_log,
      price,
      currency,
      quantity,
//      @ObjectModel.foreignKey.association: '_QuantityUnitValueHelp'
      @UI.selectionField: [{ position:  10 }]
      @Consumption.valueHelpDefinition: [{ association: '_QuantityUnitValueHelp' }]
      unit,
      lch_by,
      _QuantityUnitValueHelp

}
