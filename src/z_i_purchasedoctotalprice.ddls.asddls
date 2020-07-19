@AbapCatalog.sqlViewName: 'ZPOTOTPRICE'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Pruchase Order Total Price'
@VDM.viewType: #COMPOSITE
define view Z_I_PurchaseDocTotalPrice
  as select from Z_I_PurchaseDoc
  association [0..1] to I_Currency as _Currency on $projection.currency = _Currency.Currency
{
      //Z_I_PurchaseDoc
  key PurchaseDoc,
      @Semantics.amount.currencyCode: 'Currency'
      sum( _POItems.TotalItemPrice ) as POTOtalPrice,
      @Semantics.currencyCode: true
      _POItems.Currency,
      Description,
      CompanyCode,
      POCategory,
      PurchaseOrg,
      POStatus,
      Priority,
      CreateTimeDate,
      CreatedBy,
      ChangeTimeDate,
      ChangedBy,

      /* Associations */
      //Z_I_PurchaseDoc
      _CompanyCode,
      _DocCategory,
      _POItems,
      _POPriority,
      _POStatus,
      _PurchaseOrg,
      _Currency
}

group by
  PurchaseDoc,
  _POItems.Currency,
  Description,
  CompanyCode,
  POCategory,
  PurchaseOrg,
  POStatus,
  Priority,
  CreateTimeDate,
  CreatedBy,
  ChangeTimeDate,
  ChangedBy;
