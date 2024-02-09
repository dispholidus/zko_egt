*&---------------------------------------------------------------------*
*& Include          ZKO_EGT_EX_HARD_004_CLS
*&---------------------------------------------------------------------*

CLASS lcl_cls DEFINITION.
  PUBLIC SECTION.
    METHODS: start_screen,
      pbo_0100,
      pai_0100 IMPORTING iv_ucomm TYPE sy-ucomm,
      get_data,
      set_fcat,
      set_layout,
      display_alv,
      generate_excel,
      read_excel,
      insert_excel.

ENDCLASS.

CLASS lcl_cls IMPLEMENTATION.
  METHOD start_screen.
    CALL SCREEN 0100.
  ENDMETHOD.

  METHOD pbo_0100.
    SET PF-STATUS 'STATUS_0100'.
    go_main->get_data( ).
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
    SELECT
      b~envanter_ad,
      e~adet,
      e~cname,
      e~cdate,
      e~ctime
      FROM zko_egt_t_envlis AS e
      INNER JOIN zko_egt_t_bakkod AS b ON b~envanter_id EQ e~envanter_id
      INTO TABLE @gt_alvtable.
  ENDMETHOD.

  METHOD set_fcat.
    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
      EXPORTING
        i_structure_name = 'ZKO_EGT_S_ALV_ENVLIST'
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
      go_grid->set_table_for_first_display(
        EXPORTING
          is_layout                     =  gs_layout
        CHANGING
          it_outtab                     = gt_alvtable
          it_fieldcatalog               = gt_fcat
      ).
    ELSE.
      CALL METHOD go_grid->refresh_table_display.
    ENDIF.
  ENDMETHOD.

  METHOD generate_excel.
    CALL METHOD cl_gui_frontend_services=>directory_browse
      CHANGING
        selected_folder = gv_file.

    gv_file = gv_file
              && '\'
              && sy-datum
              &&  '_'
              && sy-uzeit
              &&  '_'
              && 'envlis.xls'.

    gs_header-line  = 'Envanter Id'.
    APPEND gs_header TO gt_header.
    gs_header-line = 'Adet'.
    APPEND gs_header TO gt_header.

    CALL FUNCTION 'GUI_DOWNLOAD'
      EXPORTING
        filename              = gv_file
        filetype              = 'ASC'
        write_field_separator = 'X'
      TABLES
        data_tab              = gt_table
        fieldnames            = gt_header.
    .
  ENDMETHOD.

  METHOD read_excel.

    CALL FUNCTION 'TEXT_CONVERT_XLS_TO_SAP'
      EXPORTING
        i_line_header        = 'X'
        i_tab_raw_data       = gt_type
        i_filename           = p_file
      TABLES
        i_tab_converted_data = gt_table.
  ENDMETHOD.

  METHOD insert_excel.
    DATA: lt_dbtab TYPE TABLE OF zko_egt_t_envlis,
          ls_dbtab TYPE  zko_egt_t_envlis.

    SELECT
      b~envanter_id,
      e~adet
      FROM zko_egt_t_bakkod AS b
      LEFT JOIN zko_egt_t_envlis AS e ON e~envanter_id EQ b~envanter_id
      FOR ALL ENTRIES IN @gt_table
      WHERE b~envanter_id EQ @gt_table-envanter_id
      INTO TABLE @DATA(lt_existingid).

    ls_dbtab-cdate = sy-datum.
    ls_dbtab-ctime = sy-uzeit.
    ls_dbtab-cname = sy-uname.

    LOOP AT lt_existingid INTO DATA(ls_data).
      READ TABLE gt_table INTO DATA(ls_table) WITH KEY envanter_id = ls_data-envanter_id.

      IF ls_data-adet IS NOT INITIAL.
        ls_dbtab-adet = ls_data-adet + ls_table-adet.
      ELSE.
        ls_dbtab-adet = ls_table-adet.
      ENDIF.

      ls_dbtab-envanter_id = ls_table-envanter_id.

      APPEND ls_dbtab TO lt_dbtab.
    ENDLOOP.

    MODIFY zko_egt_t_envlis FROM TABLE @lt_dbtab.
  ENDMETHOD.
ENDCLASS.
