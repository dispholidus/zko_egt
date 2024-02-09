*&---------------------------------------------------------------------*
*& Include          ZKO_EGT_ODEV_002_CLS
*&---------------------------------------------------------------------*
CLASS lcl_main DEFINITION.
  PUBLIC SECTION.
    METHODS:
      start_screen,
      pbo_0100,
      pai_0100 IMPORTING iv_ucomm TYPE sy-ucomm,
      get_data,
      set_fcat,
      set_layout,
      display_alv
      .
ENDCLASS.
CLASS lcl_main IMPLEMENTATION.
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
    SELECT bkpf~bukrs, bkpf~belnr, bkpf~gjahr, bseg~pswsl, bseg~koart, bseg~kunnr, bseg~lifnr, kna1~name1, lfa1~name1 AS lname1, kna1~name2, lfa1~name2 AS lname2, bseg~wrbtr, bseg~shkzg, bseg~h_bldat
      FROM bkpf
      LEFT JOIN bseg ON bseg~bukrs EQ bkpf~bukrs AND bseg~belnr EQ bkpf~belnr AND  bseg~gjahr EQ bkpf~gjahr
      LEFT JOIN kna1 ON bseg~kunnr EQ kna1~kunnr
      LEFT JOIN lfa1 ON bseg~lifnr EQ lfa1~lifnr
      INTO TABLE @DATA(lt_alvtable)
      WHERE bkpf~bukrs EQ @p_bukrs AND
            bkpf~belnr IN @gso_beln AND
            bseg~pswsl IN @gso_psws AND
           ( bseg~koart EQ 'D' OR
            bseg~koart EQ 'K' ).

    LOOP AT lt_alvtable INTO DATA(ls_alvtable).
      gs_alvtable-bukrs = ls_alvtable-bukrs.
      gs_alvtable-belnr = ls_alvtable-belnr.
      gs_alvtable-gjahr = ls_alvtable-gjahr.
      gs_alvtable-pswsl = ls_alvtable-pswsl.
      gs_alvtable-bldat = ls_alvtable-h_bldat.
      IF ls_alvtable-koart EQ 'D'.
        gs_alvtable-kunnr = ls_alvtable-kunnr.
        gs_alvtable-name1 = ls_alvtable-name1 && | | && ls_alvtable-name2.
      ELSEIF ls_alvtable-koart EQ 'K'.
        gs_alvtable-kunnr = ls_alvtable-lifnr.
        gs_alvtable-name1 = ls_alvtable-lname1 && | | && ls_alvtable-lname2.
      ENDIF.
      IF ls_alvtable-shkzg EQ 'H'.
        gs_alvtable-wrbtr = ls_alvtable-wrbtr.
      ELSEIF ls_alvtable-shkzg EQ 'S'.
        gs_alvtable-wrbtr = - ls_alvtable-wrbtr.
      ENDIF.
      APPEND gs_alvtable TO gt_alvtable.
    ENDLOOP.
  ENDMETHOD.
  METHOD set_fcat.
    gs_fcat-ref_table = 'BKPF'.
    gs_fcat-ref_field = 'BUKRS'.
    gs_fcat-fieldname = 'BUKRS'.
    gs_fcat-key = 'X' .
    APPEND gs_fcat TO gt_fcat.
    CLEAR gs_fcat.
    gs_fcat-ref_table = 'BKPF'.
    gs_fcat-ref_field = 'BELNR'.
    gs_fcat-fieldname = 'BELNR'.
    gs_fcat-key = 'X' .
    APPEND gs_fcat TO gt_fcat.
    CLEAR gs_fcat.
    gs_fcat-ref_table = 'BKPF'.
    gs_fcat-ref_field = 'GJAHR'.
    gs_fcat-fieldname = 'GJAHR'.
    gs_fcat-key = 'X' .
    APPEND gs_fcat TO gt_fcat.
    CLEAR gs_fcat.
    gs_fcat-datatype = 'CHAR10'.
    gs_fcat-fieldname = 'KUNNR'.
    gs_fcat-seltext = 'KUNNR/LIFNR'.
    gs_fcat-reptext = 'KUNNR/LIFNR'.
    gs_fcat-scrtext_s = gs_fcat-scrtext_m = gs_fcat-scrtext_l = 'KUNNR/LIFNR'.
    APPEND gs_fcat TO gt_fcat.
    CLEAR gs_fcat.
    gs_fcat-datatype = 'CHAR61'.
    gs_fcat-fieldname = 'NAME1'.
    gs_fcat-seltext = 'NAME1'.
    gs_fcat-reptext = 'NAME1'.
    gs_fcat-scrtext_s = gs_fcat-scrtext_m = gs_fcat-scrtext_l = 'NAME1'.
    APPEND gs_fcat TO gt_fcat.
    CLEAR gs_fcat.
    gs_fcat-ref_table = 'BSEG'.
    gs_fcat-ref_field = 'PSWSL'.
    gs_fcat-fieldname = 'PSWSL'.
    APPEND gs_fcat TO gt_fcat.
    CLEAR gs_fcat.
    gs_fcat-ref_table = 'BSEG'.
    gs_fcat-ref_field = 'WRBTR'.
    gs_fcat-fieldname = 'WRBTR'.
    APPEND gs_fcat TO gt_fcat.
    CLEAR gs_fcat.
    gs_fcat-ref_table = 'BSEG'.
    gs_fcat-ref_field = 'H_BLDAT'.
    gs_fcat-fieldname = 'BLDAT'.
    APPEND gs_fcat TO gt_fcat.
    CLEAR gs_fcat.
  ENDMETHOD.
  METHOD set_layout.
    gs_layout-zebra = 'X'.
    gs_layout-col_opt = 'X'.
  ENDMETHOD..
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
  ENDMETHOD.
ENDCLASS.
