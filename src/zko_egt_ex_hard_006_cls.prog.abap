*&---------------------------------------------------------------------*
*& Include          ZKO_EGT_EX_MEDIUM_006_CLS
*&---------------------------------------------------------------------*

CLASS lcl_class DEFINITION.
  PUBLIC SECTION.
    METHODS: start_screen,
      pbo_0100,
      pai_0100 IMPORTING iv_ucomm TYPE sy-ucomm,
      get_data_for_alv,
      siparis_ver,
      insert_sip,
      set_fcat,
      set_layout,
      display_alv,
      get_vbeln EXPORTING ev_next_number TYPE vbeln_va.
ENDCLASS.

CLASS lcl_class  IMPLEMENTATION.
  METHOD start_screen.
    CALL SCREEN 0100.
  ENDMETHOD.

  METHOD pbo_0100.
    SET PF-STATUS 'STATUS_0100'.
    go_main->get_data_for_alv( ).
    go_main->set_fcat( ).
    go_main->set_layout( ).
    go_main->display_alv( ).
  ENDMETHOD.

  METHOD pai_0100.
    CASE iv_ucomm.
      WHEN '&BACK'.
        SET SCREEN 0.
      WHEN '&SIPVER'.
        go_main->siparis_ver( ).
      WHEN '&TEMIZLE'.
        CLEAR: gv_vbeln,
               gv_matnr,
               gv_labst.
    ENDCASE.
  ENDMETHOD.

  METHOD get_data_for_alv.
    SELECT
      vbeln,
      matnr,
      labst,
      cname,
      cdate,
      ctime
      FROM zko_egt_t_spris
      INTO CORRESPONDING FIELDS OF TABLE @gt_alvtable.
  ENDMETHOD.

  METHOD siparis_ver.
    CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
      EXPORTING
        input  = gv_matnr
      IMPORTING
        output = gv_matnr.

    SELECT SINGLE matnr FROM mara
      INTO @DATA(lv_matnr)
      WHERE matnr = @gv_matnr.
    IF    sy-subrc EQ 0
      AND gv_matnr IS NOT INITIAL
      AND gv_labst IS NOT INITIAL.
      go_main->insert_sip( ).
    ENDIF.
  ENDMETHOD.

  METHOD insert_sip.
    DATA: ls_data TYPE zko_egt_t_spris.
    go_main->get_vbeln(
      IMPORTING
        ev_next_number = gv_vbeln
    ).
    ls_data-vbeln = gv_vbeln.
    ls_data-matnr = gv_matnr.
    ls_data-labst = gv_labst.
    ls_data-cname = sy-uname.
    ls_data-cdate = sy-datum.
    ls_data-ctime = sy-uzeit.
    BREAK-POINT.
    INSERT zko_egt_t_spris FROM ls_data.
    go_main->display_alv( ).
  ENDMETHOD.

  METHOD set_fcat.
    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
      EXPORTING
        i_structure_name = 'ZKO_EGT_S_ALV_SIPARIS_BILGI'
      CHANGING
        ct_fieldcat      = gt_fcat.
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
          is_layout                     =  gs_layout
        CHANGING
          it_outtab                     = gt_alvtable
          it_fieldcatalog               = gt_fcat
      ).
    ELSE.
      go_main->get_data_for_alv( ).
      CALL METHOD go_grid->refresh_table_display.
    ENDIF.
  ENDMETHOD.

  METHOD get_vbeln.
    CALL FUNCTION 'NUMBER_GET_NEXT'
      EXPORTING
        nr_range_nr = '01'
        object      = 'ZKO_EGT_NR'
      IMPORTING
        number      = ev_next_number.
  ENDMETHOD.
ENDCLASS.
