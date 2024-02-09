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
      display_alv..
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
    DATA lt_agr TYPE TABLE OF agr_users.
    IF gso_bnam IS NOT INITIAL.
      SELECT bname FROM usr02
        INTO TABLE @DATA(lt_data)
        WHERE bname IN @gso_bnam.
    ELSE.
      SELECT bname FROM usr02
        INTO TABLE @lt_data.
    ENDIF.
    LOOP AT lt_data INTO DATA(ls_data).
      CLEAR lt_agr.
      CALL FUNCTION 'CKEXUTIL_USER_TO_ROLE'
        EXPORTING
          i_uname      = ls_data-bname
        TABLES
          et_agr_users = lt_agr.

      LOOP AT lt_agr INTO DATA(ls_agr) WHERE from_dat >= p_strtd AND to_dat <= p_endd.
        gs_alvtable-bname = ls_agr-uname.
        gs_alvtable-agr_name = ls_agr-agr_name.
        gs_alvtable-from_dat = ls_agr-from_dat.
        gs_alvtable-to_dat = ls_agr-to_dat.
        APPEND gs_alvtable TO gt_alvtable.
      ENDLOOP.

    ENDLOOP.
  ENDMETHOD.
  METHOD set_fcat.
    gs_fcat-ref_table = 'USR02'.
    gs_fcat-ref_field = 'BNAME'.
    gs_fcat-fieldname = 'BNAME'.
    gs_fcat-key = 'X' .
    APPEND gs_fcat TO gt_fcat.
    CLEAR gs_fcat.
    gs_fcat-ref_table = 'AGR_USERS'.
    gs_fcat-ref_field = 'AGR_NAME'.
    gs_fcat-fieldname = 'AGR_NAME'.
    APPEND gs_fcat TO gt_fcat.
    CLEAR gs_fcat.
    gs_fcat-datatype = 'DATUM'.
    gs_fcat-fieldname = 'FROM_DAT'.
    gs_fcat-seltext = 'Başlangıç Tarihi'.
    gs_fcat-reptext = 'Başlangıç Tarihi'.
    gs_fcat-scrtext_s = gs_fcat-scrtext_m = gs_fcat-scrtext_l = 'Başlangıç Tarihi'.
    APPEND gs_fcat TO gt_fcat.
    CLEAR gs_fcat.
    gs_fcat-datatype = 'DATUM'.
    gs_fcat-fieldname = 'TO_DAT'.
    gs_fcat-seltext = 'Bitiş Tarihi'.
    gs_fcat-reptext = 'Bitiş Tarihi'.
    gs_fcat-scrtext_s = gs_fcat-scrtext_m = gs_fcat-scrtext_l = 'Bitiş Tarihi'.
    APPEND gs_fcat TO gt_fcat.
    CLEAR gs_fcat.
  ENDMETHOD.
  METHOD set_layout.
    gs_layout-zebra = 'X'.
    gs_layout-cwidth_opt = 'X'.
*    gs_layout-col_opt = 'X'.
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

  ENDMETHOD.                   .
ENDCLASS.
