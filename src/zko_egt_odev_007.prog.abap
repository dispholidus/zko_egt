*&---------------------------------------------------------------------*
*& Report ZKO_EGT_ODEV_007
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zko_egt_odev_007.

INCLUDE:zko_egt_odev_007_top,
        zko_egt_odev_007_cls,
        zko_egt_odev_007_mdl.

START-OF-SELECTION.
  CREATE OBJECT go_main.
  go_main->start_screen( ).
