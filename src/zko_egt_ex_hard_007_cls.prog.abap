*&---------------------------------------------------------------------*
*& Include          ZKO_EGT_EX_MEDIUM_006_CLS
*&---------------------------------------------------------------------*
CLASS lcl_class DEFINITION.
  PUBLIC SECTION.
    DATA: lv_isrowselected TYPE xfeld.
    METHODS: start_screen,
      pbo_0100,
      pbo_0200,
      pai_0100 IMPORTING iv_ucomm TYPE sy-ucomm,
      pai_0200 IMPORTING iv_ucomm TYPE sy-ucomm,
      get_kullanici_data,
      get_profil_data,
      set_fcat IMPORTING iv_screenno TYPE numc1,
      set_layout,
      display_alv IMPORTING iv_screenno TYPE numc1.
ENDCLASS.

CLASS lcl_class  IMPLEMENTATION.
  METHOD start_screen.
    CALL SCREEN 0100.
  ENDMETHOD.

  METHOD pbo_0100.
    SET PF-STATUS 'STATUS_0100'.
    go_main->get_kullanici_data( ).
    go_main->set_fcat( iv_screenno = 1 ).
    go_main->set_layout( ).
    go_main->display_alv( iv_screenno = 1 ).

  ENDMETHOD.

  METHOD pai_0100.
    CASE iv_ucomm.
      WHEN '&BACK'.
        SET SCREEN 0.
      WHEN '&LIST'.
        go_main->get_profil_data(  ).
        IF lv_isrowselected EQ 'X'.
          CALL SCREEN 0200 STARTING AT 10 10.
          lv_isrowselected = ''.
        ENDIF.
    ENDCASE.
  ENDMETHOD.

  METHOD pbo_0200.
    SET PF-STATUS 'STATUS_0200'.
    go_main->set_fcat( iv_screenno = 2 ).
    go_main->set_layout( ).
    go_main->display_alv( iv_screenno = 2 ).
    lv_isrowselected = ''.
  ENDMETHOD.

  METHOD pai_0200.
    CASE iv_ucomm.
      WHEN '&BACK'.
        SET SCREEN 0.
    ENDCASE.
  ENDMETHOD.

  METHOD get_kullanici_data.
    SELECT bname, ustyp, aname, erdat, trdat, ltime FROM usr02
      INTO TABLE @gt_kullanici_alvtable.
  ENDMETHOD.

  METHOD get_profil_data.
    DATA:lt_index_rows TYPE lvc_t_row.
    go_kullanici_grid->get_selected_rows(
      IMPORTING
        et_index_rows =  lt_index_rows   " Indexes of Selected Rows
    ).
    IF lt_index_rows IS INITIAL.
      lv_isrowselected = ''.
      MESSAGE 'Lütfen kolon seçiniz!' TYPE 'I' DISPLAY LIKE 'E'.
    ELSE.
      LOOP AT lt_index_rows INTO DATA(ls_index).
        READ TABLE gt_kullanici_alvtable INTO DATA(ls_selectedrow) INDEX ls_index.
      ENDLOOP.

      SELECT usr~bname, ust~profile FROM usr02 AS usr
        INNER JOIN ust04 AS ust ON usr~bname EQ ust~bname
        WHERE usr~bname EQ @ls_selectedrow-bname
        INTO TABLE @gt_profil_alvtable.
      lv_isrowselected = 'X'.
    ENDIF.
  ENDMETHOD.

  METHOD set_fcat.
    IF iv_screenno EQ 1.
      CLEAR gt_fcat.
      CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
        EXPORTING
          i_structure_name = 'ZKO_EGT_S_USER_ALV'
        CHANGING
          ct_fieldcat      = gt_fcat.
    ELSEIF iv_screenno EQ 2.
      CLEAR gt_fcat.
      CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
        EXPORTING
          i_structure_name = 'ZKO_EGT_S_PROFIL_ALV'
        CHANGING
          ct_fieldcat      = gt_fcat.
    ENDIF.
  ENDMETHOD.

  METHOD set_layout.
    gs_layout-zebra = 'X'.
    gs_layout-cwidth_opt = 'X'.
    gs_layout-col_opt = 'X'.
    gs_layout-sel_mode = 'B'.
  ENDMETHOD.

  METHOD display_alv.
    IF iv_screenno EQ 1.
      IF go_kullanici_grid IS INITIAL.
        CREATE OBJECT go_kullanici_container
          EXPORTING
            container_name = 'CC_ALV'.
        CREATE OBJECT go_kullanici_grid
          EXPORTING
            i_parent = go_kullanici_container.
        go_kullanici_grid->set_table_for_first_display(
          EXPORTING
            is_layout       = gs_layout
          CHANGING
            it_outtab       = gt_kullanici_alvtable
            it_fieldcatalog = gt_fcat
        ).
      ELSE.
        CALL METHOD go_kullanici_grid->refresh_table_display.
      ENDIF.
    ELSEIF iv_screenno EQ 2.
      IF go_profil_grid IS INITIAL.
        CREATE OBJECT go_profil_container
          EXPORTING
            container_name = 'CC_ALV_POPUP'.
        CREATE OBJECT go_profil_grid
          EXPORTING
            i_parent = go_profil_container.
        go_profil_grid->set_table_for_first_display(
          EXPORTING
            is_layout       = gs_layout
          CHANGING
            it_outtab       = gt_profil_alvtable
            it_fieldcatalog = gt_fcat
        ).
      ELSE.
        CALL METHOD go_profil_grid->refresh_table_display.
      ENDIF.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
