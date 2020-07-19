@AbapCatalog.sqlViewName: 'ZPODOC'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Purchase Documents'
@VDM.viewType: #BASIC
define view Z_I_PurchaseDoc
  as select from zpurchase_doc
  association [0..*] to Z_I_PurchaseDocItem as _POItems     on $projection.PurchaseDoc = _POItems.PurchaseDoc
  association [0..1] to Z_I_CompanyCode     as _CompanyCode on $projection.CompanyCode = _CompanyCode.CompanyCode
  association [0..1] to Z_I_POCategory      as _DocCategory on $projection.POCategory = _DocCategory.POCategory
  association [0..1] to I_PurchaseOrgVH     as _PurchaseOrg on $projection.PurchaseOrg = _PurchaseOrg.ResponsiblePurchaseOrg
  association [0..1] to Z_I_POStatus        as _POStatus    on $projection.POStatus = _POStatus.status
  association [0..*] to Z_I_PO_Priority     as _POPriority  on $projection.Priority = _POPriority.priority
{ //zpurchase_doc
      @ObjectModel.text.element: ['Description']
  key purchase_doc as PurchaseDoc,
      description  as Description,
      @ObjectModel.foreignKey.association: '_CompanyCode'
      company_code as CompanyCode,
      @ObjectModel.foreignKey.association: '_DocCategory'
      doc_category as POCategory,
      pruch_org    as PurchaseOrg,
      @ObjectModel.foreignKey.association: '_POStatus'
      @Consumption.valueHelpDefinition: [{ association: '_POStatus' }]
      @UI.selectionField: [{ position: 10 }]
      status       as POStatus,
      priority     as Priority,
      cr_time_date as CreateTimeDate,
      create_by    as CreatedBy,
      ch_time_date as ChangeTimeDate,
      change_by    as ChangedBy,

      _POItems,
      _CompanyCode,
      _DocCategory,
      _PurchaseOrg,
      _POStatus,
      _POPriority
}
