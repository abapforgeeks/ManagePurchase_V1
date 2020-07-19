@AbapCatalog.sqlViewName: 'ZIPOCAT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Category'
@VDM.viewType: #BASIC
define view Z_I_POCategory as select from zpo_category {
    //zpo_category
    @ObjectModel.text.element: ['Description']
    key pocat as POCategory,
    @Semantics.text: true
    desctiption as Description
}
