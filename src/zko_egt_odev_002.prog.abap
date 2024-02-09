*&---------------------------------------------------------------------*
*& Report ZKO_EGT_ODEV_002
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zko_egt_odev_002.

INCLUDE: zko_egt_odev_002_top,
         zko_egt_odev_002_cls,
         zko_egt_odev_002_mdl.

START-OF-SELECTION.
  CREATE OBJECT go_main.
  go_main->start_screen( ).
