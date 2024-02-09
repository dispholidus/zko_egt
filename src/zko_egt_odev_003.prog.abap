*&---------------------------------------------------------------------*
*& Report ZKO_EGT_EX_MEDIUM_006
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zko_egt_odev_003.

INCLUDE: zko_egt_odev_003_top,
         zko_egt_odev_003_cls,
         zko_egt_odev_003_mdl.

START-OF-SELECTION.
  CREATE OBJECT go_main.
  go_main->start_screen( ).
