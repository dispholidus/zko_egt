*&---------------------------------------------------------------------*
*& Report ZKO_EGT_ODEV_004
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zko_egt_odev_004.

INCLUDE:zko_egt_odev_004_top,
        zko_egt_odev_004_cls,
        zko_egt_odev_004_mdl.

START-OF-SELECTION.
  CREATE OBJECT go_main.
  gv_parac = gv_para && | | && 'TL'.
  go_main->start_screen( ).
