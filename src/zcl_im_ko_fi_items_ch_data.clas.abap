class ZCL_IM_KO_FI_ITEMS_CH_DATA definition
  public
  final
  create public .

public section.

  interfaces IF_EX_FI_ITEMS_CH_DATA .
protected section.
private section.
ENDCLASS.



CLASS ZCL_IM_KO_FI_ITEMS_CH_DATA IMPLEMENTATION.


  METHOD if_ex_fi_items_ch_data~change_items.

*    TYPES:
*      BEGIN OF name_type,
*        konto TYPE char10,
*        name  TYPE name1,
*      END OF name_type.
*
*    DATA: lt_lfa1 TYPE TABLE OF name_type,
*          lt_kna1 TYPE TABLE OF name_type,
*          lt_skat TYPE TABLE OF name_type.
*
*    CONSTANTS: lc_fbl1n TYPE tcode VALUE 'FBL1N',
*               lc_fbl3n TYPE tcode VALUE 'FBL3N',
*               lc_fbl5n TYPE tcode VALUE 'FBL5N'.
*
*    IF sy-tcode EQ lc_fbl1n OR sy-tcode EQ lc_fbl3n OR sy-tcode EQ lc_fbl5n.
*      SELECT lifnr, name1 FROM lfa1 INTO TABLE @lt_lfa1 FOR ALL ENTRIES IN @ct_items WHERE lifnr EQ @ct_items-konto.
*      SELECT kunnr, name1 FROM kna1 INTO TABLE @lt_kna1 FOR ALL ENTRIES IN @ct_items WHERE kunnr EQ @ct_items-konto.
*      SELECT saknr, txt50 FROM skat INTO TABLE @lt_skat FOR ALL ENTRIES IN @ct_items WHERE saknr EQ @ct_items-konto.
*      LOOP AT ct_items ASSIGNING FIELD-SYMBOL(<fs_item>).
*        READ TABLE lt_lfa1 WITH KEY konto = <fs_item>-konto INTO <fs_item>-zko_ad.
*        READ TABLE lt_kna1 WITH KEY konto = <fs_item>-konto INTO <fs_item>-zko_ad.
*        READ TABLE lt_skat WITH KEY konto = <fs_item>-konto INTO <fs_item>-zko_ad.
*      ENDLOOP.
*    ENDIF.

  ENDMETHOD.
ENDCLASS.
