*&---------------------------------------------------------------------*
*& Include          ZKO_EGT_ODEV_007_CLS
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
      insert_edited_rows,
      check_data_changed FOR EVENT data_changed OF cl_gui_alv_grid
        IMPORTING er_data_changed.
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
      WHEN '&KAYDET'.
        go_main->insert_edited_rows( ).
    ENDCASE.
  ENDMETHOD.
  METHOD get_data.
    SELECT vbeln,erdat,erzet,ernam,audat,vbtyp,auart,
        netwr,waerk,vkorg,vtweg,spart,vkgrp,vkbur,ktext
      FROM vbak
      INTO CORRESPONDING FIELDS OF TABLE @gt_alvtable
      WHERE audat IN @gso_auda AND
            vbtyp IN @gso_vbty AND
            auart IN @gso_auar.

  ENDMETHOD.
  METHOD set_fcat.
    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
      EXPORTING
        i_structure_name = 'ZKO_EGT_T_ODEV_7'
      CHANGING
        ct_fieldcat      = gt_fcat.

    READ TABLE gt_fcat ASSIGNING FIELD-SYMBOL(<gfs_fcat>) WITH KEY fieldname = 'KTEXT'.
    <gfs_fcat>-edit = abap_true.
  ENDMETHOD.
  METHOD set_layout.
    gs_layout-zebra = 'X'.
    gs_layout-cwidth_opt = 'X'.
    gs_layout-col_opt = 'X'.
    gs_layout-sel_mode = 'C'.
  ENDMETHOD.
  METHOD display_alv.
    IF go_grid IS INITIAL.
*      CREATE OBJECT go_container
*        EXPORTING
*          container_name = 'CCALV'.
      CREATE OBJECT go_grid
        EXPORTING
          i_parent = cl_gui_container=>default_screen.
*      -------------------------------------------------------
      SET HANDLER go_main->check_data_changed FOR go_grid.
*      -------------------------------------------------------
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
  METHOD insert_edited_rows.
    LOOP AT gt_insert ASSIGNING FIELD-SYMBOL(<ls_insert>).
      READ TABLE gt_alvtable INTO DATA(ls_alvtable)
                             WITH KEY vbeln = <ls_insert>-vbeln.
      <ls_insert>-ktext = ls_alvtable-ktext.
    ENDLOOP.
    MODIFY zko_egt_t_odev_7 FROM TABLE gt_insert.
    IF sy-subrc NE 0.
      ROLLBACK WORK.
      MESSAGE 'DB yazma sırasında bir hata oluştu!' TYPE 'I' DISPLAY LIKE 'W'.
    ELSE.
      COMMIT WORK.
    ENDIF.
  ENDMETHOD.
  METHOD check_data_changed.
    LOOP AT er_data_changed->mt_mod_cells INTO DATA(data).
      READ TABLE gt_alvtable INTO DATA(ls_alvtable) INDEX data-tabix.
      APPEND ls_alvtable TO gt_insert.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
