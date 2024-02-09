*&---------------------------------------------------------------------*
*& Include          ZKO_EGT_EX_MEDIUM_006_CLS
*&---------------------------------------------------------------------*
CLASS lcl_class DEFINITION.
  PUBLIC SECTION.
    DATA: lv_columntoaddcount TYPE int4.
    METHODS: start_screen,
      pbo_0100,
      pai_0100 IMPORTING iv_ucomm TYPE sy-ucomm,
      get_data,
      set_fcat,
      set_layout,
      display_alv,
      get_alv_structure.
ENDCLASS.

CLASS lcl_class  IMPLEMENTATION.
  METHOD start_screen.
    CALL SCREEN 0100.
  ENDMETHOD.

  METHOD pbo_0100.
    SET PF-STATUS 'STATUS_0100'.
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
    SELECT
      il~il_kodu, il~il_tanim,
      COUNT( * ) AS ilcecount
      FROM zko_egt_t_il AS il
    LEFT JOIN zko_egt_t_ililce AS ililce ON il~il_kodu EQ ililce~il_kodu
    LEFT JOIN zko_egt_t_ilce AS ilce ON ililce~ilce_kodu EQ ilce~ilce_kodu
    INTO TABLE @DATA(lt_ilcecount)
    GROUP BY il~il_kodu, il~il_tanim.

    SORT lt_ilcecount DESCENDING BY ilcecount.

    READ TABLE lt_ilcecount INTO DATA(ls_ilcecount) INDEX 1.

    lv_columntoaddcount = ls_ilcecount-ilcecount.

    go_main->set_fcat( ).
    go_main->get_alv_structure( ).

    SORT lt_ilcecount ASCENDING BY il_kodu.

    SELECT
      il~il_kodu,
      ilce~ilce_tanim
      FROM zko_egt_t_il AS il
      LEFT JOIN zko_egt_t_ililce AS ililce ON il~il_kodu EQ ililce~il_kodu
      LEFT JOIN zko_egt_t_ilce AS ilce ON ililce~ilce_kodu EQ ilce~ilce_kodu
      INTO TABLE @DATA(lt_data).

    LOOP AT lt_ilcecount INTO ls_ilcecount.
      ASSIGN COMPONENT 'IL_KODU' OF STRUCTURE <gs_alv> TO <gf_alv>.
      <gf_alv> = ls_ilcecount-il_kodu.
      ASSIGN COMPONENT 'IL_TANIM' OF STRUCTURE <gs_alv> TO <gf_alv>.
      <gf_alv> = ls_ilcecount-il_tanim.
      DATA(counter) = 1.
      LOOP AT lt_data INTO DATA(ls_data).
        IF ls_ilcecount-il_kodu EQ ls_data-il_kodu.
          DATA(columnname) = 'ILCE' && counter.
          ASSIGN COMPONENT columnname OF STRUCTURE <gs_alv> TO <gf_alv>.
          <gf_alv> = ls_data-ilce_tanim.
          counter = counter + 1.
        ENDIF.
      ENDLOOP.
      INSERT <gs_alv> INTO TABLE <gt_alv>.
      CLEAR <gs_alv>.
    ENDLOOP.
  ENDMETHOD.

  METHOD set_fcat.
    gs_fcat-ref_table = 'ZKO_EGT_T_IL'.
    gs_fcat-ref_field = 'IL_KODU'.
    gs_fcat-fieldname = 'IL_KODU'.
    APPEND gs_fcat TO gt_fcat.
    CLEAR gs_fcat.

    gs_fcat-ref_table = 'ZKO_EGT_T_IL'.
    gs_fcat-ref_field = 'IL_TANIM'.
    gs_fcat-fieldname = 'IL_TANIM'.
    APPEND gs_fcat TO gt_fcat.
    CLEAR gs_fcat.

    DATA(lv_columncount) = 1.

    DO lv_columntoaddcount TIMES.
      gs_fcat-ref_table = 'ZKO_EGT_T_ILCE'.
      gs_fcat-ref_field = 'ILCE_TANIM'.
      gs_fcat-fieldname = 'ILCE' &&  lv_columncount.
      gs_fcat-seltext = 'Ilce ' && | | && lv_columncount.
      gs_fcat-reptext = 'Ilce ' && | | && lv_columncount.
      gs_fcat-scrtext_s = 'Ilce ' && | | && lv_columncount.
      gs_fcat-scrtext_m = 'Ilce ' && | | && lv_columncount.
      gs_fcat-scrtext_l = 'Ilce ' && | | && lv_columncount.

      APPEND gs_fcat TO gt_fcat.
      CLEAR gs_fcat.
      lv_columncount = lv_columncount + 1.
    ENDDO.
  ENDMETHOD.

  METHOD set_layout.
    gs_layout-zebra      = 'X'.
    gs_layout-cwidth_opt = 'X'.
    gs_layout-col_opt    = 'X'.
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
          it_outtab       = <gt_alv>
          it_fieldcatalog = gt_fcat
      ).
    ELSE.
      CALL METHOD go_grid->refresh_table_display.
    ENDIF.
  ENDMETHOD.

  METHOD get_alv_structure.
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
