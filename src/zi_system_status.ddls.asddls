@AbapCatalog.sqlViewName: 'ZISYSTATUS'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'System Statuses'
@Search.searchable: true
@ObjectModel.representativeKey: 'Status'
define view ZI_System_Status as select from tj02 
association [0..*] to ZI_Main_Text as _StatusText on $projection.Status = _StatusText.StatusCode {
   //TJ02
   @ObjectModel.text.association: '_StatusText'
   @Search.defaultSearchElement: true
   key istat as Status,   
   _StatusText
}
