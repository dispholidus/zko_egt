*&---------------------------------------------------------------------*
*& Report ZKO_EGT_EX_MEDIUM_005
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zko_egt_ex_medium_005.

INCLUDE: zko_egt_ex_medium_005_top,
         zko_egt_ex_medium_005_cls,
         zko_egt_ex_medium_005_mdl.

START-OF-SELECTION.
  CREATE OBJECT go_main.
  go_main->start_screen( ).
