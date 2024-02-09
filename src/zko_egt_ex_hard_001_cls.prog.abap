*&---------------------------------------------------------------------*
*& Include          ZKO_EGT_EX_MEDIUM_006_CLS
*&---------------------------------------------------------------------*

CLASS lcl_class DEFINITION.
  PUBLIC SECTION.
    METHODS: start_screen,
      pbo_0100,
      pai_0100 IMPORTING iv_ucomm TYPE sy-ucomm,
      select_ogr,
      insert_ogr,
      update_ogr,
      delete_ogr,
      set_fcat,
      set_layout,
      display_alv.
ENDCLASS.

CLASS lcl_class IMPLEMENTATION.

  METHOD start_screen.
    CALL SCREEN 0100.
  ENDMETHOD.

  METHOD pbo_0100.
    SET PF-STATUS 'STATUS_0100'.
    go_main->set_fcat( ).
    go_main->set_layout( ).
    LOOP AT SCREEN.
      CASE 'X'.
        WHEN rb_slct.
          IF screen-group4 EQ 'X'.
            screen-active = 0.
            gv_titletext = 'Yapılacak Islem SELECT'.
          ENDIF.
        WHEN rb_insrt.
          gv_titletext = 'Yapılacak Islem INSERT'.
        WHEN rb_updt.
          IF screen-group2 EQ 'X'.
            screen-active = 0.
            gv_titletext = 'Yapılacak Islem UPDATE'.
          ENDIF.
        WHEN rb_dlt.
          IF screen-group3 EQ 'X'.
            screen-active = 0.
            gv_titletext = 'Yapılacak Islem DELETE'.
          ENDIF.
      ENDCASE.
      MODIFY SCREEN.
    ENDLOOP.
  ENDMETHOD.

  METHOD pai_0100.
    CASE iv_ucomm.
      WHEN '&BACK'.
        SET SCREEN 0.
      WHEN '&ISLEM'.
        CASE 'X'.
          WHEN rb_slct.
            IF gv_puan IS INITIAL.
              MESSAGE i003.
            ELSE.
              go_main->select_ogr( ).
              go_main->display_alv( ).
            ENDIF.

          WHEN rb_insrt.
            IF gv_ogrid IS INITIAL OR
               gv_ograd IS INITIAL OR
               gv_ogrsoyad IS INITIAL OR
               gv_dersid IS INITIAL OR
               gv_puan IS INITIAL.
              MESSAGE i003.
            ELSE.
              go_main->insert_ogr( ).
            ENDIF.

          WHEN rb_updt.
            IF gv_ogrid IS INITIAL OR
               gv_ograd IS INITIAL OR
               gv_ogrsoyad IS INITIAL.
              MESSAGE i003.
            ELSE.
              go_main->update_ogr( ).
            ENDIF.

          WHEN rb_dlt.
            IF gv_ogrid IS INITIAL.
              MESSAGE i003.
            ELSE.
              go_main->delete_ogr( ).
            ENDIF.
        ENDCASE.
    ENDCASE.
  ENDMETHOD.

  METHOD select_ogr.
    SELECT
      ogrtbl~ogrenci_id,
      ogrtbl~ogrenci_ad,
      ogrtbl~ogrenci_soyad,
      drstbl~ders_ad,
      drstbl~ders_kredi,
      ogrtbl~puan
      FROM zko_egt_t_ogrnl AS ogrtbl
      LEFT JOIN zders_detay AS drstbl ON ogrtbl~ders_id EQ drstbl~ders_id
      INTO CORRESPONDING FIELDS OF TABLE @gt_alvtable
      WHERE ogrtbl~puan EQ @gv_puan.
  ENDMETHOD.

  METHOD insert_ogr.
    gs_ogrtable-ogrenci_id = gv_ogrid.
    gs_ogrtable-ogrenci_ad = gv_ograd.
    gs_ogrtable-ogrenci_soyad = gv_ogrsoyad.
    gs_ogrtable-ders_id = gv_dersid.
    gs_ogrtable-puan = gv_puan.

    INSERT zko_egt_t_ogrnl FROM gs_ogrtable.
    IF sy-subrc NE 0.
      MESSAGE i007 DISPLAY LIKE 'E'.
      ROLLBACK WORK.
    ELSE.
      MESSAGE i006.
      COMMIT WORK.
    ENDIF.
  ENDMETHOD.

  METHOD update_ogr.
    gs_ogrtable-ogrenci_id = gv_ogrid.
    gs_ogrtable-ogrenci_ad = gv_ograd.
    gs_ogrtable-ogrenci_soyad = gv_ogrsoyad.
    UPDATE zko_egt_t_ogrnl SET ogrenci_ad = gs_ogrtable-ogrenci_ad
                               ogrenci_soyad = gs_ogrtable-ogrenci_soyad
                           WHERE ogrenci_id EQ gs_ogrtable-ogrenci_id.
    IF sy-subrc NE 0.
      MESSAGE i005 DISPLAY LIKE 'E'.
      ROLLBACK WORK.
    ELSE.
      MESSAGE i004.
      COMMIT WORK.
    ENDIF.

  ENDMETHOD.

  METHOD delete_ogr.
    DELETE FROM zko_egt_t_ogrnl WHERE ogrenci_id EQ gv_ogrid.
    IF sy-subrc NE 0.
      MESSAGE i001 DISPLAY LIKE 'E'.
      ROLLBACK WORK.
    ELSE.
      MESSAGE i000.
      COMMIT WORK.
    ENDIF.
  ENDMETHOD.

  METHOD set_fcat.
    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
      EXPORTING
        i_structure_name = 'ZKO_EGT_S_OGR_NOT_DETAY'
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
ENDCLASS.
