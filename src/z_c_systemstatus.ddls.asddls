@AbapCatalog.sqlViewName: 'ZCSYSTATUS'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'System Statuses'

define view Z_C_SystemStatus
  as select from zorder_status
  association [0..1] to ZI_System_Status as _Status1 on $projection.Status1 = _Status1.Status
  association [0..1] to ZI_System_Status as _Status2 on $projection.Status2 = _Status2.Status
//  association [0..1] to ZI_System_Status as _Status3 on $projection.Status3 = _Status3.Status
{
  key workorder   as WorkOrder,
      @ObjectModel.foreignKey.association: '_Status1'
      @UI.selectionField: [{ position: 10 }]
      @UI.lineItem: [{ position: 10 }]
      status as Status1,
      @Consumption.valueHelpDefinition: [{ association: '_Status2' }]
      @UI.selectionField: [{ position: 20 }]
      @UI.lineItem: [{ position: 20 }]
      status as Status2,
      _Status1,
      _Status2
//      _Status3

}
