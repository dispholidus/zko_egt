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
      insert_to_fcat IMPORTING iv_columnname   TYPE string
                               iv_columnname_s TYPE string OPTIONAL
                               iv_ref_field    TYPE string
                               iv_ref_table    TYPE string
                     EXPORTING es_fcat         TYPE lvc_s_fcat,
      handle_button_click_serbest
            FOR EVENT button_click OF cl_gui_alv_grid
        IMPORTING
            es_col_id
            es_row_no,
      handle_button_click_demirbas
            FOR EVENT button_click OF cl_gui_alv_grid
        IMPORTING
            es_col_id
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
    ENDCASE.
  ENDMETHOD.

  METHOD get_data.
    SELECT matnr, maktx, labst FROM zko_egt_t_mlzstk
      INTO CORRESPONDING FIELDS OF TABLE @gt_serbest_alvtable
            WHERE demirbas_mi EQ 'S'.

    LOOP AT gt_serbest_alvtable ASSIGNING <gfs_serbest_alv>.
      <gfs_serbest_alv>-button = 'Demirbaslara Ekle'.
    ENDLOOP.

    SORT  gt_serbest_alvtable ASCENDING BY matnr.

    SELECT matnr, maktx, labst FROM zko_egt_t_mlzstk
      INTO CORRESPONDING FIELDS OF TABLE @gt_demirbas_alvtable
            WHERE demirbas_mi EQ 'D'.

    LOOP AT gt_demirbas_alvtable ASSIGNING <gfs_demirbas_alv>.
      <gfs_demirbas_alv>-button = 'Serbest Stoklara Ekle'.
    ENDLOOP.

    SORT gt_demirbas_alvtable ASCENDING BY matnr.
  ENDMETHOD.

  METHOD set_fcat.
    go_main->insert_to_fcat(
      EXPORTING
        iv_columnname   = 'Malzeme Numarası'
        iv_columnname_s = 'Malzeme No'
        iv_ref_field    = 'MATNR'
        iv_ref_table    = 'ZKO_EGT_T_MLZSTK'
      IMPORTING
        es_fcat         = gs_fcat
    ).
    APPEND gs_fcat   TO gt_serbest_fcat .
    APPEND gs_fcat  TO gt_demirbas_fcat.
    CLEAR gs_fcat.
    go_main->insert_to_fcat(
      EXPORTING
        iv_columnname   = 'Malzeme Tanımı'
        iv_ref_field    = 'MAKTX'
        iv_ref_table    = 'ZKO_EGT_T_MLZSTK'
      IMPORTING
        es_fcat         = gs_fcat
    ).
    APPEND gs_fcat   TO gt_serbest_fcat .
    APPEND gs_fcat  TO gt_demirbas_fcat.
    CLEAR gs_fcat.
    go_main->insert_to_fcat(
      EXPORTING
        iv_columnname   = 'Stok Miktari'
        iv_columnname_s = 'Stok Mik'
        iv_ref_field    = 'LABST'
        iv_ref_table    = 'ZKO_EGT_T_MLZSTK'
      IMPORTING
        es_fcat         = gs_fcat
    ).
    APPEND gs_fcat TO gt_serbest_fcat .
    APPEND gs_fcat  TO gt_demirbas_fcat.
    CLEAR gs_fcat.

    gs_fcat-fieldname = 'BUTTON'.
    gs_fcat-seltext = 'Demirbaslara Ekle'.
    gs_fcat-reptext = 'Demirbaslara Ekle'.
    gs_fcat-scrtext_s = 'DmrbslrEkl'.
    gs_fcat-scrtext_m = gs_fcat-scrtext_l = 'Demirbaslara Ekle'.
    gs_fcat-style = cl_gui_alv_grid=>mc_style_button.
    APPEND gs_fcat TO gt_serbest_fcat.
    CLEAR gs_fcat.
    gs_fcat-fieldname = 'BUTTON'.
    gs_fcat-seltext = 'Serbest Stoklara Ekle'.
    gs_fcat-reptext = 'Serbest Stoklara Ekle'.
    gs_fcat-scrtext_s = 'SrbstStklrEkl'.
    gs_fcat-scrtext_m = gs_fcat-scrtext_l = 'Serbest Stoklara Ekle'.
    gs_fcat-style = cl_gui_alv_grid=>mc_style_button.
    APPEND gs_fcat TO gt_demirbas_fcat.
    CLEAR gs_fcat.
  ENDMETHOD.

  METHOD insert_to_fcat.
    es_fcat-ref_field = iv_ref_field.
    es_fcat-ref_table = iv_ref_table.
    es_fcat-fieldname = iv_ref_field.
    IF iv_columnname_s IS INITIAL.
      es_fcat-seltext = iv_columnname.
      es_fcat-reptext =  iv_columnname.
      es_fcat-scrtext_s = iv_columnname.
      es_fcat-scrtext_m = iv_columnname.
      es_fcat-scrtext_l = iv_columnname.
    ELSE.
      es_fcat-seltext =  iv_columnname.
      es_fcat-reptext =  iv_columnname.
      es_fcat-scrtext_s = iv_columnname_s.
      es_fcat-scrtext_m = iv_columnname.
      es_fcat-scrtext_l = iv_columnname.
    ENDIF.
  ENDMETHOD.

  METHOD set_layout.
    gs_layout-zebra = 'X'.
    gs_layout-cwidth_opt = 'X'.
    gs_layout-col_opt = 'X'.
  ENDMETHOD.

  METHOD display_alv.
    IF go_serbest_grid IS INITIAL.
      CREATE OBJECT go_serbest_container
        EXPORTING
          container_name = 'CC_ALV_SERBEST'.

      CREATE OBJECT go_serbest_grid
        EXPORTING
          i_parent = go_serbest_container.

      SET HANDLER go_main->handle_button_click_serbest
       FOR go_serbest_grid.

      go_serbest_grid->set_table_for_first_display(
        EXPORTING
          is_layout                     = gs_layout
        CHANGING
          it_outtab                     = gt_serbest_alvtable
          it_fieldcatalog               = gt_serbest_fcat
      ).
    ELSE.
      go_main->get_data( ).
      CALL METHOD go_serbest_grid->refresh_table_display.
    ENDIF.
    IF go_demirbas_grid IS INITIAL.
      CREATE OBJECT go_demirbas_container
        EXPORTING
          container_name = 'CC_ALV_DEMIRBAS'.

      CREATE OBJECT go_demirbas_grid
        EXPORTING
          i_parent = go_demirbas_container.

      SET HANDLER go_main->handle_button_click_demirbas
       FOR go_demirbas_grid.

      go_demirbas_grid->set_table_for_first_display(
        EXPORTING
          is_layout                     = gs_layout
        CHANGING
          it_outtab                     = gt_demirbas_alvtable
          it_fieldcatalog               = gt_demirbas_fcat
      ).
    ELSE.
      go_main->get_data( ).
      CALL METHOD go_demirbas_grid->refresh_table_display.
    ENDIF.
  ENDMETHOD.

  METHOD handle_button_click_serbest.
    DATA: ls_mlzstok TYPE zko_egt_t_mlzstk.
    READ TABLE gt_serbest_alvtable INTO gs_serbest_alvtable INDEX es_row_no-row_id.
    ls_mlzstok-matnr = gs_serbest_alvtable-matnr.
    ls_mlzstok-maktx = gs_serbest_alvtable-maktx.
    ls_mlzstok-labst = gs_serbest_alvtable-labst.
    ls_mlzstok-demirbas_mi = 'D'.

    UPDATE zko_egt_t_mlzstk FROM ls_mlzstok.
    CLEAR: gs_serbest_alvtable.

    go_main->display_alv( ).
  ENDMETHOD.

  METHOD handle_button_click_demirbas.
    READ TABLE gt_demirbas_alvtable INTO gs_demirbas_alvtable INDEX es_row_no-row_id.
    DATA: ls_mlzstok TYPE zko_egt_t_mlzstk.

    ls_mlzstok-matnr = gs_demirbas_alvtable-matnr.
    ls_mlzstok-maktx = gs_demirbas_alvtable-maktx.
    ls_mlzstok-labst = gs_demirbas_alvtable-labst.
    ls_mlzstok-demirbas_mi = 'S'.

    UPDATE zko_egt_t_mlzstk FROM ls_mlzstok.
    CLEAR: gs_demirbas_alvtable.

    go_main->display_alv( ).
  ENDMETHOD.
ENDCLASS.
