@AbapCatalog.sqlViewName: 'ZDOC_CAT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Document Category Text'
@ObjectModel.dataCategory: #TEXT
@VDM.viewType: #BASIC
define view ZDoc_Category_Text
  as select from dd07t
{
      @ObjectModel.text.element: ['Description']
  key cast( substring(dd07t.domvalue_l, 1, 1) as ebstyp preserving type ) as DocumentCategory,
      @Semantics.text: true
      @EndUserText.label: 'PO Category Desc.'
      ddtext                                                              as Description

}
where
  (
        dd07t.domname    = 'EBSTYP'
  )
  and(
        dd07t.as4local   = 'A'
    and dd07t.ddlanguage = $session.system_language
  )
