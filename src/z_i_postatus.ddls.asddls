@AbapCatalog.sqlViewName: 'ZIPOSTAT'
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Text view'
@Search.searchable: true
define view Z_I_POStatus
  as select from zpo_status
  association [0..*] to Z_I_PO_Status as _text on $projection.status = _text.status
{
      //zpo_status
      @ObjectModel.text.association: '_text'
      @Search.defaultSearchElement: true
  key status,
      _text

}
