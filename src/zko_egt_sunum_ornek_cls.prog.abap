*&---------------------------------------------------------------------*
*& Include          ZKO_EGT_EX_MEDIUM_006_CLS
*&---------------------------------------------------------------------*

CLASS lcl_class DEFINITION.
  PUBLIC SECTION.
    METHODS: start_screen,
      pbo_0100,
      pai_0100 IMPORTING iv_ucomm TYPE sy-ucomm,
      get_data,
      set_fcat,
      set_layout,
      display_alv,
      check_data_changed FOR EVENT data_changed OF cl_gui_alv_grid
        IMPORTING er_data_changed.
ENDCLASS.
CLASS lcl_class  IMPLEMENTATION.
  METHOD start_screen.
    CALL SCREEN 0100.
  ENDMETHOD.
  METHOD pbo_0100.
    SET PF-STATUS 'STATUS_0100'.
    get_data( ).
    set_layout( ).
    set_fcat( ).
    display_alv( ).
  ENDMETHOD.
  METHOD pai_0100.
    CASE iv_ucomm.
      WHEN '&BACK'.
        SET SCREEN 0.
    ENDCASE.
  ENDMETHOD.
  METHOD get_data.
    SELECT mra~matnr, mkt~maktx, mrd~labst, mrd~werks, tw~name1, mrd~lgort, tl~lgobe  FROM mara AS mra
      LEFT JOIN makt AS mkt ON mra~matnr EQ mkt~matnr
      LEFT JOIN mard AS mrd ON mra~matnr EQ mrd~matnr
      LEFT JOIN t001w AS tw ON mrd~werks EQ tw~werks
      LEFT JOIN t001l AS tl ON mrd~lgort EQ tl~lgort AND mrd~werks EQ tl~werks
      WHERE mkt~spras EQ @p_lang AND mra~matnr IN @s_matnr
      INTO CORRESPONDING FIELDS OF TABLE @gt_alvtable.
  ENDMETHOD.

  METHOD set_fcat.
*    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
*      EXPORTING
*        i_structure_name = 'ZKO_EGT_S_MALZEME_S3'
*      CHANGING
*        ct_fieldcat      = gt_fcat.

    gs_fcat-ref_table = 'MARA'.
    gs_fcat-ref_field = 'MATNR'.
    gs_fcat-fieldname = 'MATNR'.
    APPEND gs_fcat TO gt_fcat.
    CLEAR gs_fcat.
    gs_fcat-ref_table = 'MAKT'.
    gs_fcat-ref_field = 'MAKTX'.
    gs_fcat-fieldname = 'MAKTX'.
    APPEND gs_fcat TO gt_fcat.
    CLEAR gs_fcat.
    gs_fcat-ref_table = 'MARD'.
    gs_fcat-ref_field = 'LABST'.
    gs_fcat-fieldname = 'LABST'.
    APPEND gs_fcat TO gt_fcat.
    CLEAR gs_fcat.
    gs_fcat-ref_table = 'MARD'.
    gs_fcat-ref_field = 'WERKS'.
    gs_fcat-fieldname = 'WERKS'.
    APPEND gs_fcat TO gt_fcat.
    CLEAR gs_fcat.
    gs_fcat-ref_table = 'T001W'.
    gs_fcat-ref_field = 'NAME1'.
    gs_fcat-fieldname = 'NAME1'.
    APPEND gs_fcat TO gt_fcat.
    CLEAR gs_fcat.
    gs_fcat-ref_table = 'MARD'.
    gs_fcat-ref_field = 'LGORT'.
    gs_fcat-fieldname = 'LGORT'.
    APPEND gs_fcat TO gt_fcat.
    CLEAR gs_fcat.
    gs_fcat-ref_table = 'T001L'.
    gs_fcat-ref_field = 'LGOBE'.
    gs_fcat-fieldname = 'LGOBE'.
    gs_fcat-scrtext_s = gs_fcat-scrtext_l = gs_fcat-scrtext_s = gs_fcat-seltext = gs_fcat-reptext = 'Storage Area'.
    APPEND gs_fcat TO gt_fcat.
    CLEAR gs_fcat.
  ENDMETHOD.

  METHOD set_layout.
    gs_layout-zebra = 'X'.
    gs_layout-col_opt = 'X'.
    gs_layout-cwidth_opt = 'X'.
    gs_layout-edit = 'X'.
  ENDMETHOD.

  METHOD display_alv.
    IF go_grid IS INITIAL.
*      CREATE OBJECT go_container
*        EXPORTING
*          container_name =  .
      CREATE OBJECT go_grid
        EXPORTING
          i_parent = cl_gui_container=>default_screen.
      SET HANDLER go_main->check_data_changed FOR go_grid.
      go_grid->set_table_for_first_display(
        EXPORTING
          is_layout                     =  gs_layout   " Layout
        CHANGING
          it_outtab                     = gt_alvtable    " Output Table
          it_fieldcatalog               = gt_fcat    " Field Catalog
      ).
      go_grid->register_edit_event(
        EXPORTING
          i_event_id = cl_gui_alv_grid=>mc_evt_modified
      ).
    ELSE.
      CALL METHOD go_grid->refresh_table_display.
    ENDIF.
  ENDMETHOD.
  METHOD check_data_changed.
  ENDMETHOD.
ENDCLASS.
