*&---------------------------------------------------------------------*
*& Include          ZKO_EGT_ODEV_005_CLS
*&---------------------------------------------------------------------*

CLASS lcl_class DEFINITION.
  PUBLIC SECTION.
    METHODS: start_screen,
      pbo_0100,
      pai_0100 IMPORTING iv_ucomm TYPE sy-ucomm,
      pbo_0200,
      pai_0200 IMPORTING iv_ucomm TYPE sy-ucomm,
      pbo_0300,
      pai_0300 IMPORTING iv_ucomm TYPE sy-ucomm,
      pbo_0400,
      pai_0400 IMPORTING iv_ucomm TYPE sy-ucomm,
      get_data,
      set_fcat,
      set_layout,
      display_alv,
      kullanici_ekle,
      kullanici_sil,
      kullanici_inaktif_et,
      kitap_ver,
      get_data_0300,
      set_fcat_0300,
      set_layout_0300,
      display_alv_0300,
      get_data_0400,
      set_fcat_0400,
      set_layout_0400,
      display_alv_0400,
      handle_double_click FOR EVENT double_click OF cl_gui_alv_grid
        IMPORTING e_column
                    es_row_no.

ENDCLASS.
CLASS lcl_class  IMPLEMENTATION.
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
      WHEN '&KULEKLE'.
        CALL SCREEN 0200 STARTING AT 10 10.
      WHEN '&KULSIL'.
        go_main->kullanici_sil( ).
      WHEN '&KULINAKT'.
        go_main->kullanici_inaktif_et( ).
      WHEN '&KVER'.
        DATA lt_index  TYPE  lvc_t_row.
        CALL METHOD go_grid->get_selected_rows
          IMPORTING
            et_index_rows = lt_index.
        IF lt_index IS NOT INITIAL.
          CALL SCREEN 0300 STARTING AT 20 10.
        ELSE.
          MESSAGE 'Lütfen satır seçiniz!' TYPE 'I' DISPLAY LIKE 'W'.
        ENDIF.
      WHEN '&KIADE'.
        CALL SCREEN 0400 STARTING AT 20 10.
    ENDCASE.
  ENDMETHOD.
  METHOD pbo_0200.
    SET PF-STATUS 'STATUS_0200'.
  ENDMETHOD.
  METHOD pai_0200.
    CASE iv_ucomm.
      WHEN '&BACK'.
        SET SCREEN 0.
      WHEN '&EKLE'.
        go_main->kullanici_ekle( ).
    ENDCASE.
  ENDMETHOD.
  METHOD pbo_0300.
    SET PF-STATUS 'STATUS_0300'.
    go_main->get_data_0300( ).
    go_main->set_fcat_0300( ).
    go_main->set_layout_0300( ).
    go_main->display_alv_0300( ).
  ENDMETHOD.
  METHOD pai_0300.
    CASE iv_ucomm.
      WHEN '&BACK'.
        SET SCREEN 0.
      WHEN '&GIVE'.
        go_main->kitap_ver( ).
    ENDCASE.
  ENDMETHOD.
  METHOD pbo_0400.
    SET PF-STATUS 'STATUS_0400'.
    go_main->get_data_0400( ).
    go_main->set_fcat_0400( ).
    go_main->set_layout_0400( ).
    go_main->display_alv_0400( ).
  ENDMETHOD.
  METHOD pai_0400.
    CASE iv_ucomm.
      WHEN '&BACK'.
        SET SCREEN 0.
    ENDCASE.
  ENDMETHOD.
  METHOD get_data.
    SELECT * FROM zko_lib_member
      INTO TABLE @gt_alvtable
      WHERE is_active EQ 'X'.
  ENDMETHOD.
  METHOD set_fcat.
    CLEAR gt_fcat.
    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
      EXPORTING
        i_structure_name = 'ZKO_LIB_MEMBER'
      CHANGING
        ct_fieldcat      = gt_fcat.
  ENDMETHOD.
  METHOD set_layout.
    gs_layout-zebra = 'X'.
*    gs_layout-cwidth_opt = 'X'.
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
          is_layout                     =  gs_layout   " Layout
        CHANGING
          it_outtab                     = gt_alvtable    " Output Table
          it_fieldcatalog               = gt_fcat    " Field Catalog
      ).
    ELSE.
      CALL METHOD go_grid->refresh_table_display.
    ENDIF.

  ENDMETHOD.
  METHOD kullanici_ekle.
    IF gs_kullanici-member_id IS NOT INITIAL AND
     gs_kullanici-member_ad IS NOT INITIAL AND
     gs_kullanici-member_soyad IS NOT INITIAL  .
      gs_kullanici-is_active = 'X'.
      INSERT zko_lib_member FROM gs_kullanici.
      IF sy-subrc EQ 4.
        UPDATE zko_lib_member FROM gs_kullanici.
      ELSEIF sy-subrc EQ 0.
        SET SCREEN 0.
      ENDIF.
    ENDIF.
  ENDMETHOD.
  METHOD kullanici_sil.
    DATA lt_index  TYPE  lvc_t_row.
    CALL METHOD go_grid->get_selected_rows
      IMPORTING
        et_index_rows = lt_index.

    LOOP AT lt_index INTO DATA(ls_index).
      READ TABLE gt_alvtable INTO DATA(lt_alvtable) INDEX ls_index-index.
      DELETE FROM zko_lib_member WHERE member_id EQ @lt_alvtable-member_id.
    ENDLOOP.

  ENDMETHOD.
  METHOD kullanici_inaktif_et.
    DATA lt_index  TYPE  lvc_t_row.
    CALL METHOD go_grid->get_selected_rows
      IMPORTING
        et_index_rows = lt_index.

    LOOP AT lt_index INTO DATA(ls_index).
      READ TABLE gt_alvtable INTO DATA(lt_alvtable) INDEX ls_index-index.
      lt_alvtable-is_active = ''.
      UPDATE zko_lib_member FROM lt_alvtable.
    ENDLOOP.
  ENDMETHOD.
  METHOD kitap_ver.
    DATA ls_borrow TYPE zko_lib_borrow.

    DATA lt_index  TYPE  lvc_t_row.
    CALL METHOD go_grid->get_selected_rows
      IMPORTING
        et_index_rows = lt_index.

    LOOP AT lt_index INTO DATA(ls_index).
      READ TABLE gt_alvtable INTO DATA(ls_alvtable) INDEX ls_index-index.
      ls_borrow-member_id = ls_alvtable-member_id.
    ENDLOOP.

    CALL METHOD go_grid_0300->get_selected_rows
      IMPORTING
        et_index_rows = lt_index.

    LOOP AT lt_index INTO ls_index.
      READ TABLE gt_alvtable_book INTO DATA(ls_alvtable_book) INDEX ls_index-index.
      ls_borrow-book_id = ls_alvtable_book-book_id.
    ENDLOOP.
    ls_borrow-borrow_date = sy-datum.
    INSERT zko_lib_borrow FROM ls_borrow.
  ENDMETHOD.
  METHOD get_data_0300.
    SELECT * FROM zko_lib_book
      INTO TABLE @gt_alvtable_book.
  ENDMETHOD.
  METHOD set_fcat_0300.
    CLEAR gt_fcat.
    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
      EXPORTING
        i_structure_name = 'ZKO_LIB_BOOK'
      CHANGING
        ct_fieldcat      = gt_fcat.
  ENDMETHOD.
  METHOD set_layout_0300.
    gs_layout-zebra = 'X'.
    gs_layout-col_opt = 'X'.
  ENDMETHOD.
  METHOD display_alv_0300.
    IF go_grid_0300 IS INITIAL.
      CREATE OBJECT go_container_0300
        EXPORTING
          container_name = 'CC_ALV_0300'.
      CREATE OBJECT go_grid_0300
        EXPORTING
          i_parent = go_container_0300.
      go_grid_0300->set_table_for_first_display(
        EXPORTING
          is_layout                     =  gs_layout   " Layout
        CHANGING
          it_outtab                     = gt_alvtable_book    " Output Table
          it_fieldcatalog               = gt_fcat    " Field Catalog
      ).
    ELSE.
      CALL METHOD go_grid_0300->refresh_table_display.
    ENDIF.
  ENDMETHOD.

  METHOD get_data_0400.
    DATA lv_datum TYPE datum.
    SELECT * FROM zko_lib_borrow
      INTO TABLE @gt_alvtable_brrw
      WHERE borrow_date IS NOT NULL
      AND return_date EQ @lv_datum.
  ENDMETHOD.
  METHOD set_fcat_0400.
    CLEAR gt_fcat.
    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
      EXPORTING
        i_structure_name = 'ZKO_LIB_BORROW'
      CHANGING
        ct_fieldcat      = gt_fcat.
  ENDMETHOD.
  METHOD set_layout_0400.
    gs_layout-zebra = 'X'.
    gs_layout-col_opt = 'X'.
  ENDMETHOD.
  METHOD display_alv_0400.
    IF go_grid_0400 IS INITIAL.
      CREATE OBJECT go_container_0400
        EXPORTING
          container_name = 'CC_ALV_0400'.
      CREATE OBJECT go_grid_0400
        EXPORTING
          i_parent = go_container_0400.
      SET HANDLER go_main->handle_double_click FOR go_grid_0400.
      go_grid_0400->set_table_for_first_display(
        EXPORTING
          is_layout                     =  gs_layout   " Layout
        CHANGING
          it_outtab                     = gt_alvtable_brrw    " Output Table
          it_fieldcatalog               = gt_fcat    " Field Catalog
      ).
    ELSE.
      CALL METHOD go_grid_0400->refresh_table_display.
    ENDIF.
  ENDMETHOD.
  METHOD handle_double_click.

    READ TABLE gt_alvtable_brrw INTO DATA(ls_alvtable_brrw) INDEX es_row_no-row_id.
    ls_alvtable_brrw-return_date = sy-datum.

    UPDATE zko_lib_borrow FROM ls_alvtable_brrw.

    CALL METHOD go_grid_0400->refresh_table_display.

  ENDMETHOD.
ENDCLASS.
