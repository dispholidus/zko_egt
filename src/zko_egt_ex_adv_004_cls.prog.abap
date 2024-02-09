*&---------------------------------------------------------------------*
*& Include          ZKO_EGT_EX_MEDIUM_006_CLS
*&---------------------------------------------------------------------*
CLASS lcl_class DEFINITION.
  PUBLIC SECTION.
    DATA: lt_uagaci             TYPE TABLE OF zko_egt_t_uagaci,
          lt_stok               TYPE TABLE OF zko_egt_t_stok,
          lv_stok_malzeme_count TYPE int4.
    METHODS: start_screen,
      pbo_0100,
      pai_0100 IMPORTING iv_ucomm TYPE sy-ucomm,
      get_data,
      set_fcat,
      set_layout,
      display_alv,
      set_alv_structure.
ENDCLASS.

CLASS lcl_class  IMPLEMENTATION.
  METHOD start_screen.
    CALL SCREEN 0100.
  ENDMETHOD.

  METHOD pbo_0100.
    SET PF-STATUS 'STATUS_0100'.
    SET TITLEBAR 'TITLEBAR_0100'.
    go_main->get_data( ).
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
    SELECT * FROM zko_egt_t_uagaci INTO TABLE @lt_uagaci.
    SELECT * FROM zko_egt_t_stok INTO TABLE @lt_stok.

    LOOP AT lt_stok INTO DATA(ls_stok).
      lv_stok_malzeme_count = lv_stok_malzeme_count + 1.
    ENDLOOP.
    go_main->set_fcat( ).
    go_main->set_alv_structure( ).

    CLEAR: ls_stok.
    LOOP AT lt_uagaci INTO DATA(ls_uagaci) GROUP BY ls_uagaci-ana_malzeme.
      DATA: lv_min TYPE labst.

      ASSIGN COMPONENT 'ANA_MALZEME' OF STRUCTURE <gs_alv> TO <gf_alv>.
      <gf_alv> = ls_uagaci-ana_malzeme.
      lv_min = 99999.
      LOOP AT lt_uagaci INTO DATA(ls_uagaci2).
        IF ls_uagaci2-ana_malzeme EQ ls_uagaci-ana_malzeme.
          READ TABLE lt_stok INTO ls_stok WITH KEY alt_malzeme = ls_uagaci2-alt_malzeme.
          DATA(lv_temp) = floor( ls_stok-stok_miktari / ls_uagaci2-alt_malzeme_miktar ).
          IF lv_temp LE lv_min.
            lv_min =  lv_temp .
          ENDIF.
        ENDIF.
      ENDLOOP.
      ASSIGN COMPONENT 'URETILEBILECEK_MIKTAR' OF STRUCTURE <gs_alv> TO <gf_alv>.
      <gf_alv> = lv_min.
      CLEAR ls_stok.
      LOOP AT lt_stok INTO ls_stok.
        READ TABLE lt_uagaci INTO ls_uagaci2 WITH KEY alt_malzeme = ls_stok-alt_malzeme
                                                      ana_malzeme = ls_uagaci-ana_malzeme.
        IF sy-subrc EQ 0.
          ASSIGN COMPONENT ls_stok-alt_malzeme OF STRUCTURE <gs_alv> TO <gf_alv>.
          <gf_alv> = lv_min * ls_uagaci2-alt_malzeme_miktar.
        ELSEIF sy-subrc EQ 4.
          ASSIGN COMPONENT ls_stok-alt_malzeme OF STRUCTURE <gs_alv> TO <gf_alv>.
          <gf_alv> = 0.
        ENDIF.
      ENDLOOP.

      INSERT <gs_alv> INTO TABLE <gt_alv>.
    ENDLOOP.
  ENDMETHOD.

  METHOD set_fcat.
    gs_fcat-ref_table = 'ZKO_EGT_T_UAGACI'.
    gs_fcat-ref_field = 'ANA_MALZEME'.
    gs_fcat-fieldname = 'ANA_MALZEME'.
    gs_fcat-key = 'X' .
    APPEND gs_fcat TO gt_fcat.
    CLEAR gs_fcat.

    gs_fcat-ref_table = 'MARD'.
    gs_fcat-ref_field = 'LABST'.
    gs_fcat-fieldname = 'URETILEBILECEK_MIKTAR'.
    gs_fcat-seltext = 'Üretilebilecek Miktar'.
    gs_fcat-reptext = 'Üretilebilecek Miktar'.
    gs_fcat-scrtext_s = 'Üretilebilecek Miktar'.
    gs_fcat-scrtext_m = 'Üretilebilecek Miktar'.
    gs_fcat-scrtext_l = 'Üretilebilecek Miktar'.
    APPEND gs_fcat TO gt_fcat.
    CLEAR gs_fcat.

    LOOP AT lt_stok INTO DATA(ls_stok).
      gs_fcat-ref_table = 'MARD'.
      gs_fcat-ref_field = 'LABST'.
      gs_fcat-fieldname = ls_stok-alt_malzeme.
      gs_fcat-seltext = ls_stok-alt_malzeme.
      gs_fcat-reptext = ls_stok-alt_malzeme.
      gs_fcat-scrtext_s = ls_stok-alt_malzeme.
      gs_fcat-scrtext_m = ls_stok-alt_malzeme.
      gs_fcat-scrtext_l = ls_stok-alt_malzeme.
      gs_fcat-seltext = ls_stok-alt_malzeme.
      APPEND gs_fcat TO gt_fcat.
      CLEAR gs_fcat.
    ENDLOOP.
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
          is_layout                     = gs_layout
        CHANGING
          it_outtab                     = <gt_alv>
          it_fieldcatalog               = gt_fcat
      ).
    ELSE.
      CALL METHOD go_grid->refresh_table_display.
    ENDIF.
  ENDMETHOD.

  METHOD set_alv_structure.
    DATA: lt_table TYPE REF TO data,
          ls_line  TYPE REF TO data.

    CALL METHOD cl_alv_table_create=>create_dynamic_table
      EXPORTING
        it_fieldcatalog = gt_fcat
      IMPORTING
        ep_table        = lt_table.

    ASSIGN lt_table->* TO <gt_alv>.
    CREATE DATA ls_line LIKE LINE OF <gt_alv>.
    ASSIGN ls_line->* TO <gs_alv>.
  ENDMETHOD.
ENDCLASS.
