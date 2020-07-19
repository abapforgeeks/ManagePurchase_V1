@EndUserText.label: 'Purchase Doc Report'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@Search.searchable: true
@VDM.viewType: #CONSUMPTION

define root view entity Z_C_PurchaseDocReport
  as projection on Z_I_PurchaseDoc_U
{
      //Z_I_PurchaseDoc_U
      
  key PurchaseDoc,
      POTOtalPrice,
      Currency,
      TotalPriceCriticality,
      IsAprovalReq,
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.7
      @Semantics.text: true
      Description,
      CompanyCode,
      @Consumption.valueHelpDefinition: [{ entity:{ name: 'Z_I_POCategory' ,element: 'POCategory'}}]
      POCategory,
      PurchaseOrg,
      @ObjectModel.text.element: ['StatusDesc']
      @Consumption.valueHelpDefinition: [{ association: '_POStatus' }]
      POStatus,
//      _POStatus.description   as StatusDesc   :localized,
      @ObjectModel.text.element: ['PriorityDesc']
      //      @Consumption.filter.mandatory: true
      Priority,
      _POPriority.description as PriorityDesc :localized,
      CreateTimeDate,
      CreatedBy,
      ChangeTimeDate,
      ChangedBy,
      /* Associations */
      //Z_I_PurchaseDoc_U
      _CompanyCode,
      _Currency,
      _DocCategory,
      _POItems : redirected to composition child Z_C_PurchaseDocItems,
      _POPriority,
      _POStatus,
      _PurchaseOrg
}
