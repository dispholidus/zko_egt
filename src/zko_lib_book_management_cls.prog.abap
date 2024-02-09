*&---------------------------------------------------------------------*
*& Include          ZKO_LIB_BOOK_MANAGEMENT_CLS
*&---------------------------------------------------------------------*

CLASS lcl_cls DEFINITION.
  PUBLIC SECTION.
    METHODS: start_screen,
      pbo_0100,
      pai_0100 IMPORTING iv_ucomm TYPE sy-ucomm,
      pbo_0200,
      pai_0200 IMPORTING iv_ucomm TYPE sy-ucomm,
      get_data,
      set_fcat,
      set_layout,
      display_alv,
      kitap_ekle,
      kitap_sil.

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
      WHEN '&EKLE'.
        CALL SCREEN 0200 STARTING AT 10 10.
      WHEN '&SIL'.
        kitap_sil( ).
    ENDCASE.
  ENDMETHOD.
  METHOD pbo_0200.
    SET PF-STATUS 'STATUS_0200'.

  ENDMETHOD.
  METHOD pai_0200.
    CASE iv_ucomm.
      WHEN '&BACK'.
        SET SCREEN 0.
      WHEN '&INSERT'.
        kitap_ekle( ).
    ENDCASE.
  ENDMETHOD.
  METHOD get_data.
    SELECT * FROM zko_lib_book
      INTO TABLE @gt_alvtable.
  ENDMETHOD.
  METHOD set_fcat.
    CLEAR gt_fcat.
    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
      EXPORTING
        i_structure_name = 'ZKO_LIB_BOOK'
      CHANGING
        ct_fieldcat      = gt_fcat.
  ENDMETHOD.
  METHOD set_layout.
    gs_layout-zebra = 'X'.
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
          it_outtab                     = gt_alvtable   " Output Table
          it_fieldcatalog               = gt_fcat    " Field Catalog
      ).
    ELSE.
      CALL METHOD go_grid->refresh_table_display.
    ENDIF.
  ENDMETHOD.
  METHOD kitap_ekle.
    IF gs_insert-book_id IS NOT INITIAL OR gs_insert-book_ad IS NOT INITIAL.
      INSERT zko_lib_book FROM gs_insert.
      IF sy-subrc EQ 4.
        MESSAGE 'Kitap zaten var!' TYPE 'I' DISPLAY LIKE 'W'.
      ELSEIF sy-subrc EQ 0.
        SET SCREEN 0.
      ENDIF.
    ELSE.
      MESSAGE 'Alanlar boş bırakılamaz!' TYPE 'I' DISPLAY LIKE 'W'.
    ENDIF.
  ENDMETHOD.

  METHOD kitap_sil.
    DATA lt_index  TYPE  lvc_t_row.
    CALL METHOD go_grid->get_selected_rows
      IMPORTING
        et_index_rows = lt_index.

    LOOP AT lt_index INTO DATA(ls_index).
      READ TABLE gt_alvtable INTO DATA(lt_alvtable) INDEX ls_index-index.
      DELETE FROM zko_lib_book WHERE book_id EQ @lt_alvtable-book_id.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
