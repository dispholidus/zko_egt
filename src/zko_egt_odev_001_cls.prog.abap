*&---------------------------------------------------------------------*
*& Include          ZKO_EGT_KURA_001_CLS
*&---------------------------------------------------------------------*


CLASS select_screen_opereations DEFINITION.
  PUBLIC SECTION.
    METHODS: add_data,
      get_winners,
      null_check_fields.
ENDCLASS.
CLASS screen_opereations DEFINITION.
  PUBLIC SECTION.
    METHODS: start_screen,
      pbo_0100,
      pai_0100 IMPORTING iv_ucomm TYPE sy-ucomm,
      get_data,
      set_fcat IMPORTING iv_iseditable TYPE xfeld,
      set_layout,
      display_alv.

ENDCLASS.
CLASS select_screen_opereations  IMPLEMENTATION.
  METHOD add_data.
    DATA ls_data TYPE zko_egt_t_kura.
    ls_data-tc_no = p_tc.
    ls_data-ad = p_ad.
    ls_data-soyad = p_syd.
    ls_data-descp = p_desc.

    INSERT zko_egt_t_kura FROM ls_data .
    IF sy-subrc EQ 4.
      MESSAGE i000 DISPLAY LIKE 'W'.
    ELSEIF sy-subrc EQ 0.
      go_sop->get_data( ).
      go_sop->set_fcat( iv_iseditable = '').
      go_sop->start_screen( ).
    ENDIF.
  ENDMETHOD.
  METHOD get_winners.
    DATA: lt_alvtable TYPE TABLE OF zko_egt_t_kura.
    go_sop->get_data( ).
    DATA(lv_counter) = 0.
    LOOP AT gt_alvtable INTO DATA(ls_alvtable).
      lv_counter = lv_counter + 1.
    ENDLOOP.
    IF p_winc GT lv_counter.
      MESSAGE i001 DISPLAY LIKE 'W'.
    ELSEIF p_winc LE 0.
      MESSAGE i002 DISPLAY LIKE 'W'.
    ELSE.
      DO p_winc TIMES.
        DATA(rand_num) = 1.
        CALL FUNCTION 'QF05_RANDOM_INTEGER'
          EXPORTING
            ran_int_max = lv_counter
            ran_int_min = 1
          IMPORTING
            ran_int     = rand_num.
        READ TABLE gt_alvtable INTO ls_alvtable INDEX rand_num.
        DELETE TABLE gt_alvtable FROM ls_alvtable  .
        APPEND ls_alvtable TO lt_alvtable.
        lv_counter = lv_counter - 1.
      ENDDO.
      gt_alvtable = lt_alvtable.
      go_sop->set_fcat( iv_iseditable = 'X').
      go_sop->start_screen( ).
    ENDIF.
  ENDMETHOD.
  METHOD null_check_fields.

    CASE 'X'.
      WHEN rb_add.
        IF p_tc IS INITIAL OR p_ad IS INITIAL OR p_syd IS INITIAL.
          MESSAGE s003 DISPLAY LIKE 'W'.
        ELSE.
          go_ssop->add_data( ).
        ENDIF.
      WHEN rb_slct.
        go_ssop->get_winners( ).
    ENDCASE.
  ENDMETHOD.

ENDCLASS.
CLASS screen_opereations IMPLEMENTATION.
  METHOD start_screen.
    CALL SCREEN 0100.
  ENDMETHOD.
  METHOD pbo_0100.
    SET PF-STATUS 'STATUS_0100'.

    go_sop->set_layout( ).
    go_sop->display_alv( ).
  ENDMETHOD.
  METHOD pai_0100.
    CASE iv_ucomm.
      WHEN '&BACK'.
        SET SCREEN 0.
      WHEN '&KAYDET'.
        UPDATE zko_egt_t_kura FROM TABLE gt_alvtable.
    ENDCASE.
  ENDMETHOD.
  METHOD get_data.
    SELECT tc_no,ad,soyad,descp FROM zko_egt_t_kura
      INTO CORRESPONDING FIELDS OF TABLE @gt_alvtable.
  ENDMETHOD.
  METHOD set_fcat.
    gs_fcat-ref_table = 'ZKO_EGT_T_KURA'.
    gs_fcat-ref_field = 'TC_NO'.
    gs_fcat-fieldname = 'TC_NO'.
    gs_fcat-seltext = 'TC NO'.
    gs_fcat-reptext = 'TC NO'.
    gs_fcat-scrtext_s = gs_fcat-scrtext_m = gs_fcat-scrtext_l = 'TC NO'.
    APPEND gs_fcat TO gt_fcat.
    CLEAR gs_fcat.
    gs_fcat-ref_table = 'ZKO_EGT_T_KURA'.
    gs_fcat-ref_field = 'AD'.
    gs_fcat-fieldname = 'AD'.
    APPEND gs_fcat TO gt_fcat.
    CLEAR gs_fcat.
    gs_fcat-ref_table = 'ZKO_EGT_T_KURA'.
    gs_fcat-ref_field = 'SOYAD'.
    gs_fcat-fieldname = 'SOYAD'.
    APPEND gs_fcat TO gt_fcat.
    CLEAR gs_fcat.
    gs_fcat-ref_table = 'ZKO_EGT_T_KURA'.
    gs_fcat-ref_field = 'DESCP'.
    gs_fcat-fieldname = 'DESCP'.
    gs_fcat-seltext = 'Açıklama'.
    gs_fcat-reptext = 'Açıklama'.
    gs_fcat-scrtext_s = gs_fcat-scrtext_m = gs_fcat-scrtext_l = 'Açıklama'.
    IF iv_iseditable EQ 'X'.
      gs_fcat-edit = 'X'.
    ENDIF.
    APPEND gs_fcat TO gt_fcat.
    CLEAR gs_fcat.
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
ENDCLASS.
