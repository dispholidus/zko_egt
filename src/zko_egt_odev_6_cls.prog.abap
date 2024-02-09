*&---------------------------------------------------------------------*
*& Include          ZKO_EGT_ODEV_6_CLS
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
      insert_selected_row,
      paint_rows.
ENDCLASS.
CLASS lcl_class  IMPLEMENTATION.
  METHOD start_screen.
    CALL SCREEN 0100.
  ENDMETHOD.
  METHOD pbo_0100.
    SET PF-STATUS 'STATUS_0100'.

    go_main->get_data( ).
    go_main->paint_rows( ).
    go_main->set_fcat( ).
    go_main->set_layout( ).
    go_main->display_alv( ).

  ENDMETHOD.
  METHOD pai_0100.
    CASE iv_ucomm.
      WHEN '&BACK'.
        SET SCREEN 0.
      WHEN '&KAYDET'.
        insert_selected_row( ).
    ENDCASE.
  ENDMETHOD.
  METHOD get_data.
    SELECT ebeln,bukrs,bstyp,bsart,loekz,statu,aedat,ernam,lifnr,
          spras,zterm,ekorg,ekgrp,waers FROM ekko INTO CORRESPONDING FIELDS OF TABLE @gt_alvtable
      WHERE bukrs IN  @gso_bukr AND
            bstyp IN  @gso_bsty AND
            bsart IN  @gso_bsar.

  ENDMETHOD.
  METHOD set_fcat.
    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
      EXPORTING
        i_structure_name = 'ZKO_EGT_T_BELG'
      CHANGING
        ct_fieldcat      = gt_fcat.
  ENDMETHOD.
  METHOD set_layout.
    gs_layout-cwidth_opt = 'X'.
    gs_layout-info_fname = 'LINE_COLOR'.
    gs_layout-sel_mode = 'A'.
  ENDMETHOD.
  METHOD display_alv.
    IF go_grid IS INITIAL.
      CREATE OBJECT go_grid
        EXPORTING
          i_parent = cl_gui_container=>default_screen.
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
  METHOD insert_selected_row.
    DATA: lt_index  TYPE  lvc_t_row,
          ls_insert TYPE zko_egt_t_belg.
    CALL METHOD go_grid->get_selected_rows
      IMPORTING
        et_index_rows = lt_index.
    LOOP AT lt_index INTO DATA(ls_index).
      READ TABLE gt_alvtable INTO DATA(ls_alvtable) INDEX ls_index-index.
      ls_insert-ebeln = ls_alvtable-ebeln.
      ls_insert-bukrs = ls_alvtable-bukrs.
      ls_insert-bstyp = ls_alvtable-bstyp.
      ls_insert-bsart = ls_alvtable-bsart.
      ls_insert-loekz = ls_alvtable-loekz.
      ls_insert-statu = ls_alvtable-statu.
      ls_insert-aedat = ls_alvtable-aedat.
      ls_insert-ernam = ls_alvtable-ernam.
      ls_insert-lifnr = ls_alvtable-lifnr.
      ls_insert-spras = ls_alvtable-spras.
      ls_insert-zterm = ls_alvtable-zterm.
      ls_insert-ekorg = ls_alvtable-ekorg.
      ls_insert-ekgrp = ls_alvtable-ekgrp.
      ls_insert-waers = ls_alvtable-waers.

      APPEND ls_insert TO gt_insert.
    ENDLOOP.

    MODIFY zko_egt_t_belg FROM TABLE gt_insert.
  ENDMETHOD.
  METHOD paint_rows.
    SELECT ebeln FROM zko_egt_t_belg
      INTO TABLE @DATA(lt_zdata).
    LOOP AT lt_zdata INTO data(ls_zdata).
      READ TABLE gt_alvtable ASSIGNING FIELD-SYMBOL(<ls_alvtable>) WITH KEY ebeln = ls_zdata-ebeln.
      <ls_alvtable>-line_color = 'C510'.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
