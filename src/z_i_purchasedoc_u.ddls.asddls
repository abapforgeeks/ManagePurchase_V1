@AbapCatalog.sqlViewName: 'ZIPODOC_U'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Purchase Document Object Unmanaged'
@VDM.viewType: #COMPOSITE
define root view Z_I_PurchaseDoc_U
  as select from Z_I_PurchaseDocTotalPrice
  composition [0..*] of Z_I_POItem_U as _POItems
{
      //Z_I_PurchaseDocTotalPrice
  key PurchaseDoc,
      POTOtalPrice,
      Currency,
      case when POTOtalPrice >0 and POTOtalPrice < 1000 then 3
        when POTOtalPrice >1000 and POTOtalPrice < 5000 then 2
        when POTOtalPrice > 5000  then 1
        else 0
        end                                                as TotalPriceCriticality,
      case when POTOtalPrice > 1000 then 'Yes' else '' end as IsAprovalReq,
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
      //Z_I_PurchaseDocTotalPrice
      _CompanyCode,
      _Currency,
      _DocCategory,
      _POItems,
      _POPriority,
      _POStatus,
      _PurchaseOrg
}
