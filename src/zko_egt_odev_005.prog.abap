*&---------------------------------------------------------------------*
*& Report ZKO_EGT_ODEV_005
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zko_egt_odev_005.

INCLUDE: zko_egt_odev_005_top,
         zko_egt_odev_005_cls,
         zko_egt_odev_005_mdl.

START-OF-SELECTION.
  CREATE OBJECT go_main.
  go_main->start_screen( ).
