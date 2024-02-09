*&---------------------------------------------------------------------*
*& Include          ZKO_EGT_EX_MEDIUM_001_CLS
*&---------------------------------------------------------------------*

CLASS lcl_main DEFINITION.
  PUBLIC SECTION .
    METHODS : start_screen,
      pbo_0100,
      pai_0100 IMPORTING iv_ucomm TYPE sy-ucomm,
      get_data IMPORTING iv_matnr TYPE matnr18,
      get_all_data,
      set_fcat,
      set_layout,
      display_alv.
ENDCLASS.

CLASS lcl_main IMPLEMENTATION.

  METHOD start_screen.
    CALL SCREEN 0100.

  ENDMETHOD.

  METHOD pbo_0100.
    SET PF-STATUS 'STATUS_0100'.

    go_main->get_all_data( ).
    go_main->set_fcat( ).
    go_main->set_layout( ).
    go_main->display_alv( ).
  ENDMETHOD.

  METHOD pai_0100.
    CASE iv_ucomm.
      WHEN '&BACK'.
        SET SCREEN 0.
    ENDCASE.
  ENDMETHOD.
  METHOD get_data.
    CALL FUNCTION 'BAPI_MATERIAL_GET_DETAIL'
      EXPORTING
        material              = iv_matnr
      IMPORTING
        material_general_data = gs_bapimatdoa.

    gs_malzeme-base_uom = gs_bapimatdoa-base_uom.
    gs_malzeme-created_by = gs_bapimatdoa-created_by.
    gs_malzeme-created_on = gs_bapimatdoa-created_on.
    gs_malzeme-matl_desc = gs_bapimatdoa-matl_desc.
    gs_malzeme-matl_type = gs_bapimatdoa-matl_type.
    gs_malzeme-matnr = iv_matnr.
    INSERT gs_malzeme INTO TABLE gt_malzeme.

  ENDMETHOD.

  METHOD get_all_data.
    DATA: lv_matnr type matnr18.

    LOOP AT s_matnr INTO DATA(d_selopt).
      lv_matnr = d_selopt-low.
      go_main->get_data( iv_matnr = lv_matnr ).
    ENDLOOP.

  ENDMETHOD.
  METHOD set_fcat.
    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
      EXPORTING
        i_structure_name = 'zko_egt_s_malzeme'
      CHANGING
        ct_fieldcat      = gt_fcat.
  ENDMETHOD.

  METHOD set_layout.
    gs_layout-zebra = 'X'.
    gs_layout-cwidth_opt = 'X'.
    gs_layout-col_opt = 'X'.
  ENDMETHOD.

  METHOD display_alv.
    IF go_grid IS INITIAL.
      CREATE OBJECT go_container
        EXPORTING
          container_name = 'CC_ALV'.

      CREATE OBJECT go_grid
        EXPORTING
          i_parent = go_container.

      CALL METHOD go_grid->set_table_for_first_display
        EXPORTING
          is_layout       = gs_layout
        CHANGING
          it_outtab       = gt_malzeme
          it_fieldcatalog = gt_fcat.
    ELSE.
      CALL METHOD go_grid->refresh_table_display.
    ENDIF.
  ENDMETHOD.

ENDCLASS.
