@AbapCatalog.sqlViewName: 'ZPODOCITEM'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Purchase Doc Items'

define view Z_I_PurchaseDocItem
  as select from zpurchase_item
  association [1..1] to Z_I_PurchaseDoc as _PODocument on $projection.PurchaseDoc = _PODocument.PurchaseDoc
  association [0..1] to Z_I_Plant       as _POPlant    on $projection.Plant = _POPlant.Plant
  association [0..*] to Z_I_UnitofMeas  as _UOM        on $projection.Unit = _UOM.UomCode
  association [0..1] to I_Currency      as _Currency   on $projection.Currency = _Currency.Currency
{
      //zpurchase_item
      @ObjectModel.foreignKey.association: '_PODocument'
  key purchase_doc                                             as PurchaseDoc,
      @ObjectModel.text.element: ['ProductDesc']
  key purchase_item                                            as PurchaseDocItem,
      @Semantics.text: true
      short_text                                               as PorductDesc,

      material                                                 as Product,
      @ObjectModel.foreignKey.association: '_POPlant'
      plant                                                    as Plant,

      storage_log                                              as StorageLocation,
      @Semantics.amount.currencyCode: 'Currency'
      price                                                    as Price,
      @Semantics.currencyCode: true
      @ObjectModel.foreignKey.association: '_Currency'
      currency                                                 as Currency,
      @Semantics.quantity.unitOfMeasure: 'Unit'

      quantity                                                 as Quantity,
      @ObjectModel.foreignKey.association: '_UOM'
      @Semantics.unitOfMeasure: true
      unit                                                     as Unit,

      @Semantics.amount.currencyCode: 'Currency'
      ( quantity * price )                                     as TotalItemPrice,

      ( cast( price as abap.fltp ) /
      cast( ( quantity * price ) as abap.fltp ) * ( 100.00 ) ) as PricePercentage,

      lch_by                                                   as LastChangedBy,

      _PODocument,
      _POPlant,
      _UOM,
      _Currency
}
