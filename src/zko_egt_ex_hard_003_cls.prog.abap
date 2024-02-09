*&---------------------------------------------------------------------*
*& Include          ZKO_EGT_EX_MEDIUM_006_CLS
*&---------------------------------------------------------------------*

CLASS lcl_class DEFINITION.
  PUBLIC SECTION.
    DATA: ls_stok  TYPE zko_egt_t_strez.
    METHODS: start_screen,
      pbo_0100,
      pai_0100 IMPORTING iv_ucomm TYPE sy-ucomm,
      get_data,
      rezerve_stok,
      delete_stok,
*      check_mard,
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
      WHEN '&REZET'.
        IF gv_matnr IS NOT INITIAL AND gv_rezmik IS NOT INITIAL.
          go_main->rezerve_stok( ).
        ENDIF.
      WHEN '&REZSIL'.
        IF gv_matnr IS NOT INITIAL AND gv_rezmik IS NOT INITIAL.
          go_main->delete_stok( )..
        ENDIF.
    ENDCASE.
  ENDMETHOD.

  METHOD get_data.
    SELECT
      s~matnr,
      m~maktx,
      s~rezerve_stok,
      s~cname,
      s~cdate,
      s~ctime
      FROM zko_egt_t_strez AS s
      LEFT JOIN makt AS m ON s~matnr EQ m~matnr
      WHERE m~spras EQ 'T'
      INTO CORRESPONDING FIELDS OF TABLE @gt_alvtable.
  ENDMETHOD.

  METHOD rezerve_stok.
    CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
      EXPORTING
        input  = gv_matnr
      IMPORTING
        output = gv_matnr.

    SELECT SINGLE SUM( labst ) FROM mard
      INTO  @DATA(lv_labst)
      WHERE matnr EQ @gv_matnr.

    SELECT SINGLE rezerve_stok FROM zko_egt_t_strez
      WHERE matnr EQ @gv_matnr
      INTO @DATA(lv_tablostok).

    IF lv_tablostok IS NOT INITIAL.
      lv_labst = lv_labst - lv_tablostok.
    ENDIF.

    IF lv_labst GE gv_rezmik.
      ls_stok-matnr = gv_matnr.
      ls_stok-cname = sy-uname.
      ls_stok-cdate = sy-datum.
      ls_stok-ctime = sy-uzeit.
      IF sy-subrc EQ 4.
        ls_stok-rezerve_stok = gv_rezmik.
        INSERT zko_egt_t_strez FROM ls_stok.
      ELSEIF sy-subrc EQ 0.
        ls_stok-rezerve_stok = lv_tablostok + gv_rezmik.
        UPDATE zko_egt_t_strez SET rezerve_stok = ls_stok-rezerve_stok
          WHERE matnr EQ ls_stok-matnr.
      ENDIF.
    ENDIF.
    CLEAR ls_stok.
    go_main->display_alv( ).
  ENDMETHOD.

  METHOD delete_stok.
    CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
      EXPORTING
        input  = gv_matnr
      IMPORTING
        output = gv_matnr.


    SELECT SINGLE rezerve_stok FROM zko_egt_t_strez
      WHERE matnr EQ @gv_matnr
      INTO @DATA(lv_tablostok).

    IF lv_tablostok GE gv_rezmik.
       ls_stok-matnr = gv_matnr.
       ls_stok-cname = sy-uname.
       ls_stok-cdate = sy-datum.
       ls_stok-ctime = sy-uzeit.
       ls_stok-rezerve_stok = lv_tablostok - gv_rezmik.

      IF ls_stok-rezerve_stok EQ 0.
        DELETE FROM zko_egt_t_strez WHERE matnr EQ ls_stok-matnr.
      ELSE .
        UPDATE zko_egt_t_strez SET rezerve_stok = ls_stok-rezerve_stok
          WHERE matnr EQ ls_stok-matnr.
      ENDIF.
    ELSE.
      MESSAGE 'Rezerve kaydı yok veya rezerve kaydından büyük bir veri girdiniz'
      TYPE 'I' DISPLAY LIKE 'E'.
    ENDIF.
    CLEAR ls_stok.
    go_main->display_alv( ).
  ENDMETHOD.

  METHOD set_fcat.
    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
      EXPORTING
        i_structure_name = 'ZKO_EGT_S_HARD_003_ALV'
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
      go_main->get_data( ).
      CALL METHOD go_grid->refresh_table_display.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
