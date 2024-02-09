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
    SET TITLEBAR 'TITLEBAR_0100'.
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
    SELECT uagaci~ana_malzeme,
      MIN(
          ( CAST( stok~stok_miktari AS FLTP  )  /  CAST( uagaci~alt_malzeme_miktar AS FLTP  )
         )
      ) AS minstok
      FROM zko_egt_t_uagaci AS uagaci
      INNER JOIN zko_egt_t_stok AS stok ON stok~alt_malzeme EQ uagaci~alt_malzeme
      INTO TABLE @DATA(lt_table)
      GROUP BY uagaci~ana_malzeme.

    LOOP AT lt_table INTO DATA(ls_table).
      gs_alvtable-matnr = ls_table-ana_malzeme.
      gs_alvtable-labst = floor( ls_table-minstok ).
      APPEND gs_alvtable TO gt_alvtable.
      CLEAR gs_alvtable.
    ENDLOOP.
  ENDMETHOD.

  METHOD set_fcat.
    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
      EXPORTING
        i_structure_name = 'ZKO_EGT_S_ALVADETRAP'
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
          is_layout       = gs_layout
        CHANGING
          it_outtab       = gt_alvtable
          it_fieldcatalog = gt_fcat
      ).
    ELSE.
      CALL METHOD go_grid->refresh_table_display.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
