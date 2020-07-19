CLASS zcl_manage_purchases DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .
PUBLIC SECTION.

CLASS-METHODS:buffer_purchasedoc
        IMPORTING it_purchasedoc TYPE z_if_purchase_types=>gt_purchase_doc
        EXPORTING et_messages TYPE bapiret1_t,
        buffer_purchaseitem
        IMPORTING it_purchaseitem TYPE z_if_purchase_types=>gt_purchase_item
        EXPORTING et_messages TYPE bapiret1_t,

        map_purchasedoc_cds_to_db IMPORTING is_purchasedoc TYPE z_i_purchasedoc_u
        RETURNING VALUE(rs_purchasedoc) TYPE z_if_purchase_types=>gs_purchase_doc,

        map_purchaseitem_cds_to_db IMPORTING is_purchaseitem TYPE z_i_purchasedocitem
        RETURNING VALUE(rs_purchaseitem) TYPE z_if_purchase_types=>gs_purchase_item,
        save.
PROTECTED SECTION.
PRIVATE SECTION.

ENDCLASS.



CLASS zcl_manage_purchases IMPLEMENTATION.
  METHOD buffer_purchasedoc.
    "Validate
    LOOP AT it_purchasedoc ASSIGNING FIELD-SYMBOL(<Lfs_po>).
    IF <lfs_po>-purchase_doc IS INITIAL.
        APPEND VALUE #( type = 'E' id = 'ZPO_MSG' number = '001'   ) TO et_messages.
    ENDIF.
    ENDLOOP.
    "Buffer Purchase document.
    IF et_messages IS  INITIAL.
    lcl_buffer_class=>get_instance(  )->buffer_purchasedoc( it_purchase_doc = it_purchasedoc ).
    ENDIF..
  ENDMETHOD.

  METHOD save.
    lcl_buffer_class=>get_instance(  )->save(  ).
  ENDMETHOD.

  METHOD buffer_purchaseitem.
    LOOP AT it_purchaseitem ASSIGNING FIELD-SYMBOL(<Lfs_items>).
    IF <lfs_items>-purchase_doc IS INITIAL OR <lfs_items>-purchase_item IS INITIAL.
    APPEND VALUE #( type = 'E' id = 'ZPO_MSG'  number = '004') TO et_messages.
    ENDIF.
    IF et_messages IS INITIAL.
        lcl_buffer_class=>get_instance(  )->buffer_purchaseitems( it_purchase_items = it_purchaseitem ).
    ENDIF.

    ENDLOOP.
  ENDMETHOD.

  METHOD map_purchasedoc_cds_to_db.
    rs_purchasedoc = CORRESPONDING #(  is_purchasedoc MAPPING
                                        purchase_doc = PurchaseDoc
                                        description = Description
                                        company_code = CompanyCode
                                        doc_category = POCategory
                                        priority = Priority
                                        status = POStatus
                                        create_by = CreatedBy
                                        cr_time_date = CreateTimeDate
                                        change_by = ChangedBy
                                        ch_time_date = ChangeTimeDate
                                          ).
  rs_purchasedoc-change_by = sy-uname.
  GET TIME STAMP FIELD rs_purchasedoc-ch_time_date.
  ENDMETHOD.

  METHOD map_purchaseitem_cds_to_db.
*    rs_purchaseitem = CORRESPONDING #( is_purchaseitem mapping
*                                       purchase_doc = PurchaseDoc
*                                       purchase_item = PurchaseDocItem )
  ENDMETHOD.

ENDCLASS.
