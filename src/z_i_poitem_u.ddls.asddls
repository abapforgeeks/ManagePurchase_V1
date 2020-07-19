@AbapCatalog.sqlViewName: 'ZIPOITEM_U'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Po Items Unmanaged'
@VDM.viewType: #COMPOSITE
define view Z_I_POItem_U
  as select from Z_I_PurchaseDocItem
  association to parent Z_I_PurchaseDoc_U as _PODocument on $projection.PurchaseDoc = _PODocument.PurchaseDoc
{
      //Z_I_PurchaseDocItem
  key PurchaseDoc,
  key PurchaseDocItem,
      PorductDesc,
      Product,
      Plant,
      StorageLocation,
      Price,
      Currency,
      Quantity,
      Unit,
      TotalItemPrice,
      PricePercentage,
      
      LastChangedBy,
      
      /* Associations */
      //Z_I_PurchaseDocItem
      _Currency,
      _PODocument,
      _POPlant,
      _UOM
}
