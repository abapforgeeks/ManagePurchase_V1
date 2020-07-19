INTERFACE z_if_purchase_types
  PUBLIC .
  TYPES:BEGIN OF lty_purchase_doc.
        INCLUDE TYPE zpurchase_doc.
        TYPES:END OF lty_purchase_doc.
 TYPES: BEGIN OF lty_purchase_item.
        INCLUDE TYPE zpurchase_item.
        TYPES: END OF lty_purchase_item.
 TYPES: BEGIN OF lty_fields,
           name TYPE string,
           END OF lty_fields.


  TYPES: BEGIN OF lty_purchase_docx,
      action TYPE string,
      Purchase_Doc TYPE zpuch_doc,
      description TYPE boolean,
      company_code TYPE boolean,
      doc_category TYPE boolean,
      pruch_org TYPE boolean,
      status TYPE boolean,
      priority TYPE boolean,
      cr_time_date TYPE boolean,
      create_by TYPE boolean,
      ch_time_date TYPE boolean,
      change_by TYPE boolean,
    END OF lty_purchase_docx.

TYPES: BEGIN OF lty_purchase_itemx,
       purchase_doc TYPE boolean,
       purchase_item TYPE boolean,
        short_text TYPE boolean,
        material TYPE boolean,
        plant TYPE boolean,
        storage_log TYPE boolean,
        price TYPE boolean,
        currency TYPE boolean,
        quantity TYPE boolean,
        unit TYPE boolean,
        lch_by TYPE boolean,
END OF lty_purchase_itemx.

 TYPES: gs_purchase_doc TYPE lty_purchase_doc,
        gs_purchase_item TYPE lty_purchase_item,
        ts_purchase_docx TYPE lty_purchase_docx,
        ts_purchase_itemx TYPE lty_purchase_itemx.

TYPES:  gt_purchase_doc TYPE TABLE OF lty_purchase_doc,
        gt_purchase_item TYPE TABLE OF zpurchase_item,
        tt_purchase_docx TYPE TABLE OF lty_purchase_docx,
        tt_purchase_item TYPE TABLE OF lty_purchase_item,
        tt_purchase_itemx TYPE TABLE OF lty_purchase_itemx,
        tt_field_names TYPE TABLE OF lty_fields.


ENDINTERFACE.
