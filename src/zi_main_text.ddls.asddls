@AbapCatalog.sqlViewName: 'ZIMAINTEXT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Text View'
@ObjectModel.dataCategory: #TEXT
@Search.searchable: true
@ObjectModel.representativeKey: 'StatusCode'
define view ZI_Main_Text as select from tj02t {
    //TJ02T
    key istat as StatusCode,
    @Semantics.language: true
    key spras as Language,
    
    @Semantics.text: true
    @Search:{ defaultSearchElement: true, ranking: #MEDIUM, fuzzinessThreshold: 0.7}
    txt30 as LongDesc
}
