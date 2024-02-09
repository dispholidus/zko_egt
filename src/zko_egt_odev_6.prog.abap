*&---------------------------------------------------------------------*
*& Report ZKO_EGT_ODEV_6
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zko_egt_odev_6.

INCLUDE: zko_egt_odev_6_top,
         zko_egt_odev_6_cls,
         zko_egt_odev_6_mdl.

START-OF-SELECTION.
  CREATE OBJECT go_main.
  go_main->start_screen( ).
