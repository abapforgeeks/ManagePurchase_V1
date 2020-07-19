@EndUserText.label: 'Purchase Doc Item Report'
@AccessControl.authorizationCheck: #CHECK
@Search.searchable: true
@VDM.viewType: #CONSUMPTION
@Metadata.allowExtensions: true
define view entity Z_C_PurchaseDocItems
  as projection on Z_I_POItem_U
{
      //Z_I_POItem_U
  key PurchaseDoc,
  key PurchaseDocItem,
      @ObjectModel.text.element: ['PorductDesc']
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.7
      @Search.ranking: #HIGH
      Product,
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.7
      @Search.ranking: #HIGH

      PorductDesc,
      @Consumption.valueHelpDefinition: [{ entity:{ name:'Z_I_Plant',element: 'Plant'} }]
      Plant,
      Price,
      Quantity,
      @Consumption.valueHelpDefinition: [{ entity:{ name:'Z_I_UnitofMeas',element: 'UomCode' } }]
      Unit,
      TotalItemPrice,
      @Consumption.valueHelpDefinition: [{ entity:{ name: 'I_Currency',element: 'Currency'} }]
      Currency,
      LastChangedBy,
      PricePercentage,

      /* Associations */
      //Z_I_POItem_U
      _Currency,
      _PODocument : redirected to parent Z_C_PurchaseDocReport,
      _POPlant,
      _UOM
}
