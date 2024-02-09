*&---------------------------------------------------------------------*
*& Include          ZKO_EGT_EX_MEDIUM_003_CLS
*&---------------------------------------------------------------------*

CLASS lcl_cls DEFINITION.
  PUBLIC SECTION.
    METHODS:
      pbo_0100,
      pai_0100 IMPORTING iv_ucomm TYPE sy-ucomm,
      start_screen,
      get_data,
      set_fcat,
      set_layout,
      display_alv.
ENDCLASS.

CLASS lcl_cls IMPLEMENTATION.
  METHOD pbo_0100.
    SET PF-STATUS 'GUI_STATUS_0100'.
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

  METHOD start_screen.
    CALL SCREEN 0100.
  ENDMETHOD.

  METHOD get_data.
    SELECT
      mra~matnr,
      mkt~maktx,
      mrd~labst,
      mrd~werks,
      tw~name1,
      mrd~lgort,
      tl~lgobe
      FROM mara AS mra
      LEFT JOIN makt AS mkt ON mra~matnr EQ mkt~matnr
      LEFT JOIN mard AS mrd ON mra~matnr EQ mrd~matnr
      LEFT JOIN t001w AS tw ON mrd~werks EQ tw~werks
      LEFT JOIN t001l AS tl ON mrd~lgort EQ tl~lgort
                           AND mrd~werks EQ tl~werks
      WHERE mkt~spras EQ @p_lang AND mra~matnr IN @s_matnr
      INTO CORRESPONDING FIELDS OF TABLE @gt_alvtable.
    IF sy-subrc NE 0.
      MESSAGE 'Error' TYPE 'E'.
    ENDIF.
  ENDMETHOD.

  METHOD set_fcat.
    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
      EXPORTING
        i_structure_name = 'ZKO_EGT_S_MALZEME_S3'
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
