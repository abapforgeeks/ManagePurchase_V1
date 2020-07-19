CLASS lcl_buffer DEFINITION.

PUBLIC SECTION.
TYPES: BEGIN OF lty_podoc_buffer.
       INCLUDE TYPE zpurchase_doc AS po_data.
      TYPES: END OF lty_podoc_buffer.
TYPES: BEGIN OF lty_poitem_buffer.
       INCLUDE TYPE zpurchase_item AS po_item.
       TYPES: END OF lty_poitem_buffer.

CLASS-DATA: tt_podoc_update TYPE TABLE OF lty_podoc_buffer,
            tt_poitem_update TYPE TABLE OF lty_poitem_buffer.

ENDCLASS.
CLASS lhc_Z_I_PurchaseDoc_U DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS create_po FOR MODIFY
      IMPORTING it_purchasedoc FOR CREATE podoc.
      METHODS lock_po FOR LOCK IMPORTING it_purchasedoc FOR LOCK podoc.

*    METHODS delete FOR MODIFY
*      IMPORTING keys FOR DELETE podoc.
*
    METHODS update FOR MODIFY
      IMPORTING it_podoc FOR UPDATE podoc.
*
    METHODS read FOR READ
      IMPORTING it_podoc FOR READ podoc RESULT et_podoc.
*
    METHODS cba_POITEMS FOR MODIFY
      IMPORTING po_items_cba FOR CREATE podoc\_poitems.
*
    METHODS rba_POITEMS FOR READ
      IMPORTING keys_rba FOR READ podoc\_poitems FULL result_requested RESULT result LINK association_links.
*    METHODS set_Status FOR MODIFY
*     IMPORTING keys FOR ACTION podoc~set_Status RESULT result.

ENDCLASS.

CLASS lhc_Z_I_PurchaseDoc_U IMPLEMENTATION.

  METHOD create_po.
    DATA : ls_purchase_doc TYPE zpurchase_doc.
           DATA: lt_purchase_doc TYPE TABLE OF zpurchase_doc.
                 DATA lv_pono TYPE zpuch_doc.
    "fetch Already Existing PO Max Number
    SELECT FROM zpurchase_doc FIELDS MAX( purchase_doc ) INTO @lv_pono.
    "Mapping CDS fields to the back end table fields.
    LOOP AT it_purchasedoc ASSIGNING FIELD-SYMBOL(<lfs_purchase_doc>).
    DATA(lv_cid) = <lfs_purchase_doc>-%cid.
    DATA(lv_purchasedoc) = CONV zpuch_doc( lv_pono + 1 ) .
    ls_purchase_doc  = CORRESPONDING #( <lfs_purchase_doc> MAPPING
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
    "Get time stamp fields.
    GET TIME STAMP FIELD DATA(lv_create_change_time).
    ls_purchase_doc-purchase_doc = condense( | {  lv_purchasedoc ALPHA = IN }| ).
    ls_purchase_doc-create_by = sy-uname.
    ls_purchase_doc-change_by = sy-uname.
    ls_purchase_doc-cr_time_date = lv_create_change_time.
    ls_purchase_doc-ch_time_date = lv_create_change_time.
    APPEND ls_purchase_doc TO lt_purchase_doc.

ENDLOOP.
    IF lt_purchase_doc IS  NOT INITIAL.
    "Transaction Buffering
    zcl_manage_purchases=>buffer_purchasedoc(
      EXPORTING
        it_purchasedoc = lt_purchase_doc
      IMPORTING
        et_messages    = DATA(lt_messages)
    ).

    IF lt_messages IS NOT INITIAL.
    "Message Handling
        LOOP AT lt_messages ASSIGNING FIELD-SYMBOL(<lfs_messages>).
        APPEND VALUE #( %cid = lv_cid
                        purchasedoc = ls_purchase_doc-purchase_doc ) TO failed-podoc.

        APPEND VALUE #(  %cid = lv_cid
                         %msg = NEW cl_abap_behv( )->new_message(
                                                    id       =  <lfs_messages>-id
                                                    number   = <lfs_messages>-number
                                                    severity = if_abap_behv_message=>severity-error
                                                                  )
                 Purchasedoc =  ls_purchase_doc-purchase_doc  ) TO reported-podoc.

        ENDLOOP.

    ELSE.
        "Success Messages
        APPEND VALUE #( %cid = lv_cid
                        %msg = NEW cl_abap_behv( )->new_message(
                                                    id       =  'ZPO_MSG'
                                                    number   = '002'
                                                    severity = if_abap_behv_message=>severity-success
                                                    v1 = lv_purchasedoc
                                                  )
                  Purchasedoc =  lv_purchasedoc   ) TO reported-podoc.
    ENDIF.
    ENDIF.



  ENDMETHOD.

*  METHOD delete.
*  ENDMETHOD.
*
  METHOD update.
    DATA:lt_purchasedocs_new TYPE TABLE OF zpurchase_doc,
         lt_purchasedocx TYPE z_if_purchase_types=>tt_purchase_docx.

    DATA: ls_purchasedocx TYPE z_if_purchase_types=>ts_purchase_docx.

           DATA: lt_field_names TYPE z_if_purchase_types=>tt_field_names.
    DATA: lo_ref TYPE REF TO cl_abap_structdescr.
    lo_ref ?= cl_abap_typedescr=>describe_by_name( p_name =  'ZPURCHASE_DOC').
    lt_field_names = CORRESPONDING #( lo_ref->components MAPPING name = name ).

    LOOP AT it_podoc ASSIGNING FIELD-SYMBOL(<lfs_podoc>).
    "Map CDS Field to DB
    DATA(ls_purchasedoc) = zcl_manage_purchases=>map_purchasedoc_cds_to_db( is_purchasedoc = CORRESPONDING #( <lfs_podoc> )  ).

    "Changed fields information
    ls_purchasedocx-description = xsdbool( <lfs_podoc>-%control-Description = cl_abap_behv=>flag_changed ).
    ls_purchasedocx-company_code = xsdbool( <lfs_podoc>-%control-CompanyCode = cl_abap_behv=>flag_changed ).
    ls_purchasedocx-doc_category = xsdbool( <lfs_podoc>-%control-POCategory = cl_abap_behv=>flag_changed  ).
    ls_purchasedocx-status = xsdbool( <lfs_podoc>-%control-POStatus = cl_abap_behv=>flag_changed  ).
    ls_purchasedocx-priority = xsdbool( <lfs_podoc>-%control-Priority = cl_abap_behv=>flag_changed  ).
    ls_purchasedocx-pruch_org = xsdbool( <lfs_podoc>-%control-PurchaseOrg = cl_abap_behv=>flag_changed  ).
    "These fields updated by us, so marked explicitly.
    ls_purchasedocx-change_by = abap_true.
    ls_purchasedocx-ch_time_date = abap_true.
    ls_purchasedocx-purchase_doc = <lfs_podoc>-PurchaseDoc.



    APPEND ls_purchasedoc TO lt_purchasedocs_new.
    APPEND ls_purchasedocx TO lt_purchasedocx.
    ENDLOOP.
    "Fetch Old Values for the purchase document to update the changed values(only).
    SELECT * FROM zpurchase_doc
             INTO TABLE @DATA(lt_purchasedocs_db)
             FOR ALL ENTRIES IN @lt_purchasedocs_new
             WHERE purchase_doc EQ @lt_purchasedocs_new-purchase_doc.
    IF sy-subrc EQ 0.
    LOOP AT lt_purchasedocs_new ASSIGNING FIELD-SYMBOL(<lfs_podoc_new>).

    READ TABLE lt_purchasedocs_db INTO DATA(ls_podoc_db) WITH KEY purchase_doc = <lfs_podoc_new>-purchase_doc.
    IF sy-subrc EQ 0.
        "keeping purchase document details in buffer(right now we are inserted only old values,
*        changes values will be overwritten with <lfs_podoc_buffer>
        INSERT VALUE #( po_data = ls_podoc_db ) INTO TABLE lcl_buffer=>tt_podoc_update
        ASSIGNING FIELD-SYMBOL(<Lfs_podoc_buffer>).

        READ TABLE lt_purchasedocx INTO DATA(ls_podocx) WITH KEY purchase_doc = <lfs_podoc_new>-purchase_doc.

        LOOP AT lt_field_names ASSIGNING FIELD-SYMBOL(<Lfs_field_name>).

           ASSIGN COMPONENT <Lfs_field_name>-name OF STRUCTURE ls_podocx TO FIELD-SYMBOL(<lfs_flag>).
           IF sy-subrc NE 0.
           CONTINUE.
           ENDIF.

           IF <lfs_flag> EQ abap_true.
           ASSIGN COMPONENT <Lfs_field_name>-name OF STRUCTURE <lfs_podoc_new>   TO FIELD-SYMBOL(<lfs_new_value>).
           ASSERT sy-subrc EQ 0.
           ASSIGN COMPONENT <Lfs_field_name>-name OF STRUCTURE <lfs_podoc_buffer> TO FIELD-SYMBOL(<lfs_old_value>).
           ASSERT sy-subrc EQ 0.
           <lfs_old_value> = <lfs_new_value>.
           ENDIF.

        ENDLOOP.
    ENDIF.
    ENDLOOP.
    ENDIF.



  ENDMETHOD.
*
*  METHOD read.
*  ENDMETHOD.
*
  METHOD cba_POITEMS.
    DATA: lt_purchase_items TYPE z_if_purchase_types=>gt_purchase_item,
          ls_purchase_item TYPE zpurchase_item.
          DATA: lv_po_item(4) TYPE c.
    DATA(lv_purchasedoc) = po_items_cba[ 1 ]-PurchaseDoc.
    SELECT FROM zpurchase_item
    FIELDS MAX( purchase_item ) WHERE purchase_doc = @lv_purchasedoc INTO @lv_po_item
    .
    LOOP AT   po_items_cba ASSIGNING FIELD-SYMBOL(<lfs_podoc>).
    DATA(lv_pono) = <lfs_podoc>-PurchaseDoc.
    DATA(lv_cid) = <lfs_podoc>-%cid_ref.
    LOOP AT <lfs_podoc>-%target ASSIGNING FIELD-SYMBOL(<lfs_items>).
        ls_purchase_item = CORRESPONDING #( <lfs_items> MAPPING
                                            purchase_doc = PurchaseDoc
                                            purchase_item = PurchaseDocItem
                                            material = Product
                                            price = Price
                                            currency = Currency
                                           quantity = Quantity
                                           unit = Unit
                                           plant = Plant
                                           short_text = PorductDesc
                                            ).
    GET TIME STAMP FIELD DATA(lv_cr_ch_time).
    ls_purchase_item-lch_by = lv_cr_ch_time.
    ls_purchase_item-purchase_item =       lv_po_item + 1.
    ls_purchase_item-purchase_doc = |{ lv_pono ALPHA = IN }|.
    APPEND ls_purchase_item TO lt_purchase_items.
    ENDLOOP.

    IF lt_purchase_items IS NOT INITIAL.
        zcl_manage_purchases=>buffer_purchaseitem(
          EXPORTING
            it_purchaseitem = lt_purchase_items
          IMPORTING
            et_messages     = DATA(lt_messages)
        ).
        IF lt_messages IS NOT INITIAL.
    "Message Handling
        LOOP AT lt_messages ASSIGNING FIELD-SYMBOL(<lfs_messages>).
        APPEND VALUE #( %cid = lv_cid
                        purchasedoc = ls_purchase_item-purchase_doc
                        purchasedocitem = lv_po_item ) TO failed-poitems.

        APPEND VALUE #(  %cid = lv_cid
                         %msg = NEW cl_abap_behv( )->new_message(
                                                    id       =  <lfs_messages>-id
                                                    number   = <lfs_messages>-number
                                                    severity = if_abap_behv_message=>severity-error
                                                                 )
                 Purchasedoc =  ls_purchase_item-purchase_doc  ) TO reported-poitems.
                 ENDLOOP.
    ELSE.
 "Success Messages
        APPEND VALUE #( %cid = lv_cid
                        %msg = NEW cl_abap_behv( )->new_message(
                                                    id       =  'ZPO_MSG'
                                                    number   = '003'
                                                    severity = if_abap_behv_message=>severity-success
                                                    v1 = lv_pono
                                                    v2 = lv_po_item
                                                  )
                  Purchasedoc =  lv_pono
                  purchasedocitem = lv_po_item  ) TO reported-poitems.
    ENDIF.

   ENDIF.


    ENDLOOP.
  ENDMETHOD.
*
*  METHOD rba_POITEMS.
*  ENDMETHOD.
*
*  METHOD set_Status.
*
*  ENDMETHOD.

  METHOD rba_poitems.
RETURN.
  ENDMETHOD.



  METHOD lock_po.
*Implement Locking
  ENDMETHOD.

  METHOD read.
    LOOP AT it_podoc ASSIGNING FIELD-SYMBOL(<lfs_podoc>).

    SELECT SINGLE * FROM zpurchase_doc INTO @DATA(ls_podoc)
    WHERE purchase_doc EQ @<lfs_podoc>-PurchaseDoc.
    IF sy-subrc EQ 0.
    INSERT VALUE #(
                    purchasedoc = ls_podoc-purchase_doc
                    description = ls_podoc-description
                    companycode = ls_podoc-company_code
                    pocategory = ls_podoc-doc_category
                    purchaseorg = ls_podoc-pruch_org
                    postatus = ls_podoc-status
                    priority = ls_podoc-priority
                    createtimedate = ls_podoc-cr_time_date
                    createdby = ls_podoc-create_by
                    changetimedate = ls_podoc-ch_time_date
                    changedby = ls_podoc-change_by
                ) INTO TABLE et_podoc.

    ENDIF.

    ENDLOOP.
  ENDMETHOD.

ENDCLASS.

CLASS lhc_Z_I_POItem_U DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS create FOR MODIFY
      IMPORTING it_items FOR CREATE poitems.

    METHODS delete FOR MODIFY
      IMPORTING it_items FOR DELETE poitems.

    METHODS update FOR MODIFY
      IMPORTING it_items FOR UPDATE poitems.

    METHODS read FOR READ
      IMPORTING it_poitems FOR READ poitems RESULT et_poitems.

ENDCLASS.

CLASS lhc_Z_I_POItem_U IMPLEMENTATION.

  METHOD create.
  RETURN.
  ENDMETHOD.

  METHOD delete.
  ENDMETHOD.

  METHOD update.
    DATA: ls_purchase_item TYPE zpurchase_item,
          ls_purchase_itemx TYPE z_if_purchase_types=>ts_purchase_itemx.
    DATA: lt_purchase_items TYPE TABLE OF zpurchase_item,
          lt_purchase_itemx TYPE z_if_purchase_types=>tt_purchase_itemx.

   DATA: lt_field_names TYPE z_if_purchase_types=>tt_field_names.
    DATA: lo_ref TYPE REF TO cl_abap_structdescr.

          lo_ref ?= cl_abap_typedescr=>describe_by_name( p_name = 'ZPURCHASE_ITEM' ).
          lt_field_names = CORRESPONDING #( lo_ref->components MAPPING name = name ).


          LOOP AT it_items ASSIGNING FIELD-SYMBOL(<lfs_items>).
          "Map CDS fields to DB ( When the mapping is already at behavior definition )
          ls_purchase_item = CORRESPONDING #( <lfs_items> MAPPING FROM ENTITY  ).

          "Capture Changed fields.
          ls_purchase_itemx-purchase_doc = <lfs_items>-PurchaseDoc.
          ls_purchase_itemx-purchase_item = <lfs_items>-PurchaseDocItem.
          ls_purchase_itemx-material = xsdbool( <lfs_items>-%control-Product = cl_abap_behv=>flag_changed ).
          ls_purchase_itemx-plant = xsdbool( <lfs_items>-%control-Plant = cl_abap_behv=>flag_changed ).
          ls_purchase_itemx-price = xsdbool( <lfs_items>-%control-Price = cl_abap_behv=>flag_changed ).
          ls_purchase_itemx-unit = xsdbool( <lfs_items>-%control-Unit = cl_abap_behv=>flag_changed ).
          ls_purchase_itemx-quantity = xsdbool( <lfs_items>-%control-Quantity = cl_abap_behv=>flag_changed ).
          ls_purchase_itemx-currency = xsdbool( <lfs_items>-%control-Currency = cl_abap_behv=>flag_changed ).

          "Marking changed time explicitly.
          ls_purchase_itemx-lch_by = abap_true.

          "Update changed time as well.
          GET TIME STAMP FIELD ls_purchase_item-lch_by.
          APPEND ls_purchase_item TO lt_purchase_items.
          APPEND ls_purchase_itemx TO lt_purchase_itemx.
          ENDLOOP.

          "fetch purchase item data from DB( to update the required fields ).
          SELECT * FROM zpurchase_item INTO TABLE @DATA(lt_item_db)
          FOR ALL ENTRIES IN @lt_purchase_items
          WHERE purchase_doc EQ @lt_purchase_items-purchase_doc
          AND purchase_item EQ @lt_purchase_items-purchase_item.
          IF sy-subrc EQ 0.

          LOOP AT lt_purchase_items ASSIGNING FIELD-SYMBOL(<lfs_items_new>).
          "now replace old values of each item with new changed values.
           READ TABLE lt_item_db WITH KEY purchase_doc = <lfs_items_new>-purchase_doc
                                         purchase_item = <lfs_items_new>-purchase_item
                                        ASSIGNING FIELD-SYMBOL(<lfs_item_old>).
            IF sy-subrc EQ 0.
            "keep the data in buffer and updated changed fields
            INSERT VALUE #( po_item = <lfs_item_old> ) INTO TABLE lcl_buffer=>tt_poitem_update
            ASSIGNING FIELD-SYMBOL(<lfs_poitem_buffer>).

            "get the changed field information
            READ TABLE lt_purchase_itemx ASSIGNING FIELD-SYMBOL(<lfs_itemx>)
            WITH KEY purchase_doc  = <lfs_items_new>-purchase_doc
                     purchase_item = <lfs_items_new>-purchase_item.

            "now update the buffer based on the fields changed
            LOOP AT lt_field_names ASSIGNING FIELD-SYMBOL(<lfs_field_name>).
                ASSIGN COMPONENT <lfs_field_name>-name OF STRUCTURE <lfs_itemx> TO FIELD-SYMBOL(<lfs_flag>).
                IF sy-subrc NE 0.
                CONTINUE.
                ENDIF.

                IF <lfs_flag> EQ abap_true.
                ASSIGN COMPONENT <lfs_field_name>-name OF STRUCTURE <lfs_items_new> TO FIELD-SYMBOL(<lfs_new_value>).
                ASSERT sy-subrc EQ 0.
                ASSIGN COMPONENT <lfs_field_name>-name OF STRUCTURE <lfs_poitem_buffer> TO FIELD-SYMBOL(<lfs_old_value>).
                ASSERT sy-subrc EQ 0.
                <lfs_old_value> = <lfs_new_value>.
                ENDIF.

            ENDLOOP.

           ENDIF.
           ENDLOOP.
ENDIF.
  ENDMETHOD.

  METHOD read.
*  select * FROM zpurchase_item INTO TABLE @data(lt_items)
*  FOR ALL ENTRIES IN @it_poitems
TYPES: BEGIN OF lty_items,
       itemno TYPE ebelp,
       END OF lty_items.
       TYPES: lt_items TYPE TABLE OF lty_items WITH EMPTY KEY.

    DATA(lt_item_nos) = VALUE lt_items( FOR ls_item IN it_poitems (  CONV #(  ls_item-PurchaseDocItem ) ) ).

    DATA(lv_podoc) = it_poitems[ 1 ]-PurchaseDoc.



  ENDMETHOD.

ENDCLASS.

CLASS lsc_Z_I_PurchaseDoc_U DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS check_before_save REDEFINITION.
    METHODS finalize          REDEFINITION.
    METHODS save              REDEFINITION.

ENDCLASS.

CLASS lsc_Z_I_PurchaseDoc_U IMPLEMENTATION.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD finalize.
  ENDMETHOD.

  METHOD save.
  zcl_manage_purchases=>save(  ).

  "Update PO Doc Table
  IF lcl_buffer=>tt_podoc_update IS NOT INITIAL.
  UPDATE zpurchase_doc FROM TABLE lcl_buffer=>tt_podoc_update.
  ENDIF.
  ENDMETHOD.

*  METHOD adjust_numbers.
**  DATA: lv_final_po TYPE zpuch_doc,
**        lv_purchasedoc TYPE zpuch_doc.
**    SELECT FROM zpurchase_doc FIELDS MAX( purchase_doc ) INTO @DATA(lv_pono).
**    lv_final_po =  lv_pono + 1 .
**    lv_purchasedoc = |{ lv_final_po ALPHA = IN }|.
**
**    APPEND VALUE #( %pid = lv_final_po purchasedoc = lv_purchasedoc ) TO mapped-podoc.
*
*  ENDMETHOD.

ENDCLASS.
