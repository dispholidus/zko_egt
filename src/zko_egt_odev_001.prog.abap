*&---------------------------------------------------------------------*
*& Report ZKO_EGT_KURA_001
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zko_egt_odev_001 MESSAGE-ID zko_egt_mc_kura.

INCLUDE ZKO_EGT_ODEV_001_TOP.
*INCLUDE: zko_egt_kura_001_top,
INCLUDE ZKO_EGT_ODEV_001_CLS.
*         zko_egt_kura_001_cls,
INCLUDE ZKO_EGT_ODEV_001_MDL.
*         zko_egt_kura_001_mdl.

AT SELECTION-SCREEN OUTPUT.

  IF rb_add EQ 'X'.
    LOOP AT SCREEN.
      IF screen-group1 EQ 'BLG'.
        screen-active = 1.
        MODIFY SCREEN.
      ELSEIF screen-group1 EQ 'SLC'.
        screen-required = 0.
        screen-active = 0.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
  ELSEIF rb_slct EQ 'X'.
    LOOP AT SCREEN.
      IF screen-group1 EQ 'BLG'.
        screen-active = 0.
        MODIFY SCREEN.
      ELSEIF screen-group1 EQ 'SLC'.
        screen-active = 1.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
  ENDIF.


START-OF-SELECTION.
  CREATE OBJECT: go_ssop,
                 go_sop.

  go_ssop->null_check_fields( ).
