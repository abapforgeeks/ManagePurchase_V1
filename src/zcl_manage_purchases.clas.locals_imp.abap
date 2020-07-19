*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
CLASS  lcl_buffer_class DEFINITION CREATE PRIVATE.
PUBLIC SECTION.
CLASS-DATA: mt_purchase_doc TYPE z_if_purchase_types=>gt_purchase_doc,
            mt_purchase_items TYPE z_if_purchase_types=>gt_purchase_item.
CLASS-METHODS: get_instance RETURNING VALUE(ro_instance) TYPE REF TO lcl_buffer_class.
METHODS: buffer_purchasedoc IMPORTING it_purchase_doc TYPE z_if_purchase_types=>gt_purchase_doc,
         buffer_purchaseitems IMPORTING it_purchase_items TYPE z_if_purchase_types=>gt_purchase_item.
METHODS save.

PRIVATE SECTION.
CLASS-DATA: gref_instance TYPE REF TO lcl_buffer_class.

ENDCLASS.

CLASS lcl_buffer_class IMPLEMENTATION.

  METHOD save.
    IF mt_purchase_doc IS NOT INITIAL.
    INSERT zpurchase_doc FROM TABLE mt_purchase_doc.
    ENDIF.

    IF mt_purchase_items IS NOT INITIAL.
    INSERT zpurchase_item FROM TABLE mt_purchase_items.
    ENDIF.

  ENDMETHOD.

  METHOD get_instance.
    gref_instance = COND #( WHEN gref_instance IS BOUND THEN gref_instance ELSE NEW #(  ) ).
    ro_instance = gref_instance.
  ENDMETHOD.

  METHOD buffer_purchasedoc.
    MOVE-CORRESPONDING it_purchase_doc TO mt_purchase_doc.
  ENDMETHOD.

  METHOD buffer_purchaseitems.
    MOVE-CORRESPONDING it_purchase_items TO     mt_purchase_items.
  ENDMETHOD.

ENDCLASS.
