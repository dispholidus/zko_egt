*&---------------------------------------------------------------------*
*& Include          ZKO_EGT_EX_MEDIUM_006_CLS
*&---------------------------------------------------------------------*
CLASS lcl_class_0100 DEFINITION.
  PUBLIC SECTION.
    METHODS: start_screen,
      pbo_0100,
      pai_0100 IMPORTING iv_ucomm TYPE sy-ucomm,
      check_data,
      set_fcat,
      set_layout,
      display_alv,
      insert_data IMPORTING iv_alvtable TYPE gtt_alv_0100,
      disable_editing.
ENDCLASS.

CLASS lcl_class_0200 DEFINITION.
  PUBLIC SECTION.
    METHODS: start_screen,
      pbo_0200,
      pai_0200 IMPORTING iv_ucomm TYPE sy-ucomm,
      get_data,
      set_fcat,
      set_layout,
      display_alv.
ENDCLASS.

CLASS lcl_class_0100 IMPLEMENTATION.
  METHOD start_screen.
    CALL SCREEN 0100.
  ENDMETHOD.

  METHOD pbo_0100.
    SET PF-STATUS 'STATUS_0100'.
    go_main_0100->set_fcat( ).
    go_main_0100->set_layout( ).
    go_main_0100->display_alv( ).
  ENDMETHOD.

  METHOD pai_0100.
    CASE iv_ucomm.
      WHEN '&BACK'.
        SET SCREEN 0.
      WHEN '&SAVE'.
        go_main_0100->check_data( ).
    ENDCASE.
  ENDMETHOD.

  METHOD check_data.
    LOOP AT gt_alvtable_0100 ASSIGNING FIELD-SYMBOL(<lfs_alvtable>).
      IF  <lfs_alvtable>-personel_id IS NOT INITIAL
        AND <lfs_alvtable>-personel_ad IS NOT INITIAL
        AND <lfs_alvtable>-personel_soyad IS NOT INITIAL
        AND <lfs_alvtable>-personel_departman_id IS NOT INITIAL
        AND <lfs_alvtable>-personel_title_id IS NOT INITIAL
        AND <lfs_alvtable>-toplam_tecrube IS NOT INITIAL
        AND <lfs_alvtable>-line_color NE 'C510'.

        SELECT SINGLE * FROM zko_egt_t_ttlblg
          INTO @DATA(ls_ttlblg)
          WHERE title_id EQ @<lfs_alvtable>-personel_title_id.
        SELECT SINGLE * FROM zko_egt_t_depblg
          INTO @DATA(ls_depblg)
          WHERE departman_id EQ @<lfs_alvtable>-personel_departman_id.

        IF ls_ttlblg IS NOT INITIAL AND ls_depblg IS NOT INITIAL.
          go_main_0100->insert_data( iv_alvtable = <lfs_alvtable> ).
          <lfs_alvtable>-line_color = 'C510'.
        ENDIF.
      ENDIF.
    ENDLOOP.
    go_main_0100->disable_editing( ).
  ENDMETHOD.

  METHOD set_fcat.
    CLEAR gt_fcat.
    gs_fcat-ref_table = 'ZKO_EGT_T_PERBLG'.
    gs_fcat-ref_field = 'PERSONEL_ID'.
    gs_fcat-fieldname = 'PERSONEL_ID'.
    APPEND gs_fcat TO gt_fcat.
    CLEAR: gs_fcat.
    gs_fcat-ref_table = 'ZKO_EGT_T_PERBLG'.
    gs_fcat-ref_field = 'PERSONEL_AD'.
    gs_fcat-fieldname = 'PERSONEL_AD'.
    APPEND gs_fcat TO gt_fcat.
    CLEAR: gs_fcat.
    gs_fcat-ref_table = 'ZKO_EGT_T_PERBLG'.
    gs_fcat-ref_field = 'PERSONEL_SOYAD'.
    gs_fcat-fieldname = 'PERSONEL_SOYAD'.
    APPEND gs_fcat TO gt_fcat.
    CLEAR: gs_fcat.
    gs_fcat-ref_table = 'ZKO_EGT_T_PERBLG'.
    gs_fcat-ref_field = 'PERSONEL_DEPARTMAN_ID'.
    gs_fcat-fieldname = 'PERSONEL_DEPARTMAN_ID'.
    APPEND gs_fcat TO gt_fcat.
    CLEAR: gs_fcat.
    gs_fcat-ref_table = 'ZKO_EGT_T_PERBLG'.
    gs_fcat-ref_field = 'PERSONEL_TITLE_ID'.
    gs_fcat-fieldname = 'PERSONEL_TITLE_ID'.
    APPEND gs_fcat TO gt_fcat.
    CLEAR: gs_fcat.
    gs_fcat-ref_table = 'ZKO_EGT_T_PERBLG'.
    gs_fcat-ref_field = 'TOPLAM_TECRUBE'.
    gs_fcat-fieldname = 'TOPLAM_TECRUBE'.
    APPEND gs_fcat TO gt_fcat.
    CLEAR: gs_fcat.
  ENDMETHOD.

  METHOD set_layout.
    CLEAR gs_layout.
    gs_layout-zebra      = 'X'.
    gs_layout-cwidth_opt = 'X'.
    gs_layout-col_opt    = 'X'.
    gs_layout-edit       = 'X'.
    gs_layout-info_fname = 'LINE_COLOR'.
    gs_layout-stylefname = 'IS_EDITABLE'.
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
          is_layout       = gs_layout
        CHANGING
          it_outtab       = gt_alvtable_0100
          it_fieldcatalog = gt_fcat
      ).
      go_grid->register_edit_event(
        EXPORTING
          i_event_id = cl_gui_alv_grid=>mc_evt_modified
      ).
    ELSE.
      CALL METHOD go_grid->refresh_table_display.
    ENDIF.
  ENDMETHOD.

  METHOD insert_data.
    DATA: ls_insertdata TYPE zko_egt_t_perblg.
    ls_insertdata-personel_id           = iv_alvtable-personel_id.
    ls_insertdata-personel_ad           = iv_alvtable-personel_ad.
    ls_insertdata-personel_soyad        = iv_alvtable-personel_soyad.
    ls_insertdata-personel_departman_id = iv_alvtable-personel_departman_id.
    ls_insertdata-personel_title_id     = iv_alvtable-personel_title_id.
    ls_insertdata-toplam_tecrube        = iv_alvtable-toplam_tecrube.
    INSERT zko_egt_t_perblg FROM ls_insertdata.
  ENDMETHOD.

  METHOD disable_editing.
    DATA: lwa_styleline TYPE lvc_s_styl.
    LOOP AT gt_alvtable_0100 ASSIGNING FIELD-SYMBOL(<lfs_alvtable>).
      IF <lfs_alvtable>-line_color EQ 'C510'.
        lwa_styleline-fieldname = 'PERSONEL_ID'.
        lwa_styleline-style = cl_gui_alv_grid=>mc_style_disabled.
        INSERT lwa_styleline INTO TABLE <lfs_alvtable>-is_editable.

        lwa_styleline-fieldname = 'PERSONEL_AD'.
        lwa_styleline-style = cl_gui_alv_grid=>mc_style_disabled.
        INSERT lwa_styleline INTO TABLE <lfs_alvtable>-is_editable.

        lwa_styleline-fieldname = 'PERSONEL_SOYAD'.
        lwa_styleline-style = cl_gui_alv_grid=>mc_style_disabled.
        INSERT lwa_styleline INTO TABLE <lfs_alvtable>-is_editable.

        lwa_styleline-fieldname = 'PERSONEL_DEPARTMAN_ID'.
        lwa_styleline-style = cl_gui_alv_grid=>mc_style_disabled.
        INSERT lwa_styleline INTO TABLE <lfs_alvtable>-is_editable.

        lwa_styleline-fieldname = 'PERSONEL_TITLE_ID'.
        lwa_styleline-style = cl_gui_alv_grid=>mc_style_disabled.
        INSERT lwa_styleline INTO TABLE <lfs_alvtable>-is_editable.

        lwa_styleline-fieldname = 'TOPLAM_TECRUBE'.
        lwa_styleline-style = cl_gui_alv_grid=>mc_style_disabled.
        INSERT lwa_styleline INTO TABLE <lfs_alvtable>-is_editable.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.

CLASS lcl_class_0200 IMPLEMENTATION.
  METHOD start_screen.
    CLEAR: go_grid,
           go_container.
    CALL SCREEN 0200.
  ENDMETHOD.

  METHOD pbo_0200.
    SET PF-STATUS 'STATUS_0200'.
    go_main_0200->get_data( ).
    go_main_0200->set_fcat( ).
    go_main_0200->set_layout( ).
    go_main_0200->display_alv( ).
  ENDMETHOD.

  METHOD pai_0200.
    CASE iv_ucomm.
      WHEN '&BACK'.
        SET SCREEN 0.
    ENDCASE.
  ENDMETHOD.

  METHOD get_data.
    IF gso_pa IS NOT INITIAL .
      SELECT
        per~personel_id,
        per~personel_ad,
        per~personel_soyad,
        dep~departman_adi,
        ttl~title_ad,
        per~toplam_tecrube,
        ttl~maas_katsayi
        FROM zko_egt_t_perblg AS per
        INNER JOIN zko_egt_t_depblg AS dep ON dep~departman_id EQ per~personel_departman_id
        INNER JOIN zko_egt_t_ttlblg AS ttl ON ttl~title_id EQ per~personel_title_id
        WHERE per~personel_ad IN @gso_pa
        INTO TABLE @DATA(lt_alvtable).
    ENDIF.

    IF gso_psa IS NOT INITIAL.
      SELECT
        per~personel_id,
        per~personel_ad,
        per~personel_soyad,
        dep~departman_adi,
        ttl~title_ad,
        per~toplam_tecrube,
        ttl~maas_katsayi
        FROM zko_egt_t_perblg AS per
        INNER JOIN zko_egt_t_depblg AS dep ON dep~departman_id EQ per~personel_departman_id
        INNER JOIN zko_egt_t_ttlblg AS ttl ON ttl~title_id EQ per~personel_title_id
        WHERE per~personel_soyad IN @gso_psa
        INTO TABLE @DATA(lt_psa_alvtable).
    ENDIF.

    IF gso_pda IS NOT INITIAL.
      SELECT
        per~personel_id,
        per~personel_ad,
        per~personel_soyad,
        dep~departman_adi,
        ttl~title_ad,
        per~toplam_tecrube,
        ttl~maas_katsayi
        FROM zko_egt_t_perblg AS per
        INNER JOIN zko_egt_t_depblg AS dep ON dep~departman_id EQ per~personel_departman_id
        INNER JOIN zko_egt_t_ttlblg AS ttl ON ttl~title_id EQ per~personel_title_id
        WHERE dep~departman_adi IN @gso_pda
        INTO TABLE @DATA(lt_pda_alvtable).
    ENDIF.

    IF gso_pta IS NOT INITIAL.
      SELECT
        per~personel_id,
        per~personel_ad,
        per~personel_soyad,
        dep~departman_adi,
        ttl~title_ad,
        per~toplam_tecrube,
        ttl~maas_katsayi
        FROM zko_egt_t_perblg AS per
        INNER JOIN zko_egt_t_depblg AS dep ON dep~departman_id EQ per~personel_departman_id
        INNER JOIN zko_egt_t_ttlblg AS ttl ON ttl~title_id EQ per~personel_title_id
        WHERE ttl~title_ad IN @gso_pta
        INTO TABLE @DATA(lt_pta_alvtable).
    ENDIF.

    LOOP AT lt_psa_alvtable INTO DATA(ls_psa_alvtable).
      APPEND ls_psa_alvtable TO lt_alvtable.
    ENDLOOP.
    LOOP AT lt_pda_alvtable INTO DATA(ls_pda_alvtable).
      APPEND ls_pda_alvtable TO lt_alvtable.
    ENDLOOP.
    LOOP AT lt_pta_alvtable INTO DATA(ls_pta_alvtable).
      APPEND ls_pta_alvtable TO lt_alvtable.
    ENDLOOP.

    SORT lt_alvtable ASCENDING BY personel_id.

    DELETE ADJACENT DUPLICATES FROM lt_alvtable COMPARING personel_id.

*   Çekilen tabloları birleştir id üzerinde duplicate olanları sil.
    LOOP AT lt_alvtable INTO DATA(ls_alvtable).
      CLEAR gs_alvtable_0200.
      gs_alvtable_0200-personel_id           = ls_alvtable-personel_id.
      gs_alvtable_0200-personel_ad           = ls_alvtable-personel_ad.
      gs_alvtable_0200-personel_soyad        = ls_alvtable-personel_soyad.
      gs_alvtable_0200-personel_departman_ad = ls_alvtable-departman_adi.
      gs_alvtable_0200-personel_title_ad     = ls_alvtable-title_ad.
      gs_alvtable_0200-toplam_tecrube        = ls_alvtable-toplam_tecrube.
      gs_alvtable_0200-personel_maas         = ls_alvtable-toplam_tecrube * ls_alvtable-maas_katsayi * 2000 .

      IF ls_alvtable-toplam_tecrube LT 1.
        gs_alvtable_0200-personel_yillik_izin = 'YOK'.
      ELSEIF ls_alvtable-toplam_tecrube LT 3.
        gs_alvtable_0200-personel_yillik_izin = '1 Hafta'.
      ELSEIF ls_alvtable-toplam_tecrube LT 5.
        gs_alvtable_0200-personel_yillik_izin = '2 Hafta'.
      ELSEIF ls_alvtable-toplam_tecrube LT 10.
        gs_alvtable_0200-personel_yillik_izin = '3 Hafta'.
      ELSE.
        gs_alvtable_0200-personel_yillik_izin = '1 Ay'.
      ENDIF.
      INSERT gs_alvtable_0200 INTO TABLE gt_alvtable_0200.
    ENDLOOP.
  ENDMETHOD.

  METHOD set_fcat.
    CLEAR gt_fcat.
    gs_fcat-ref_table = 'ZKO_EGT_T_PERBLG'.
    gs_fcat-ref_field = 'PERSONEL_ID'.
    gs_fcat-fieldname = 'PERSONEL_ID'.
    APPEND gs_fcat TO gt_fcat.
    CLEAR: gs_fcat.
    gs_fcat-ref_table = 'ZKO_EGT_T_PERBLG'.
    gs_fcat-ref_field = 'PERSONEL_AD'.
    gs_fcat-fieldname = 'PERSONEL_AD'.
    APPEND gs_fcat TO gt_fcat.
    CLEAR: gs_fcat.
    gs_fcat-ref_table = 'ZKO_EGT_T_PERBLG'.
    gs_fcat-ref_field = 'PERSONEL_SOYAD'.
    gs_fcat-fieldname = 'PERSONEL_SOYAD'.
    APPEND gs_fcat TO gt_fcat.
    CLEAR: gs_fcat.
    gs_fcat-ref_table = 'ZKO_EGT_T_DEPBLG'.
    gs_fcat-ref_field = 'DEPARTMAN_ADI'.
    gs_fcat-fieldname = 'PERSONEL_DEPARTMAN_AD'.
    APPEND gs_fcat TO gt_fcat.
    CLEAR: gs_fcat.
    gs_fcat-ref_table = 'ZKO_EGT_T_TTLBLG'.
    gs_fcat-ref_field = 'TITLE_AD'.
    gs_fcat-fieldname = 'PERSONEL_TITLE_AD'.
    APPEND gs_fcat TO gt_fcat.
    CLEAR: gs_fcat.
    gs_fcat-ref_table = 'ZKO_EGT_T_PERBLG'.
    gs_fcat-ref_field = 'TOPLAM_TECRUBE'.
    gs_fcat-fieldname = 'TOPLAM_TECRUBE'.
    APPEND gs_fcat TO gt_fcat.
    CLEAR: gs_fcat.
    gs_fcat-datatype = 'INT4'.
    gs_fcat-fieldname = 'PERSONEL_MAAS'.
    gs_fcat-seltext = 'Maaş'.
    gs_fcat-reptext = 'Maaş'.
    gs_fcat-scrtext_s = gs_fcat-scrtext_m = gs_fcat-scrtext_l = 'Maaş'.
    APPEND gs_fcat TO gt_fcat.
    CLEAR: gs_fcat.
    gs_fcat-datatype = 'CHAR10'.
    gs_fcat-fieldname = 'PERSONEL_YILLIK_IZIN'.
    gs_fcat-seltext = 'Yıllık İzin'.
    gs_fcat-reptext = 'Yıllık İzin'.
    gs_fcat-scrtext_s = gs_fcat-scrtext_m = gs_fcat-scrtext_l = 'Yıllık İzin'.
    APPEND gs_fcat TO gt_fcat.
    CLEAR: gs_fcat.
  ENDMETHOD.

  METHOD set_layout.
    CLEAR gs_layout.
    gs_layout-zebra = 'X'.
    gs_layout-cwidth_opt = 'X'.
    gs_layout-col_opt = 'X'.
  ENDMETHOD.

  METHOD display_alv.
    IF go_grid IS INITIAL.
      CREATE OBJECT go_container
        EXPORTING
          container_name = 'CC_ALV_LISTELE'.
      CREATE OBJECT go_grid
        EXPORTING
          i_parent = go_container.
      go_grid->set_table_for_first_display(
        EXPORTING
          is_layout       = gs_layout
        CHANGING
          it_outtab       = gt_alvtable_0200
          it_fieldcatalog = gt_fcat
      ).
    ELSE.
      CALL METHOD go_grid->refresh_table_display.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
