*&---------------------------------------------------------------------*
*& Report ZKO_EGT_EX_HARD_5
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zko_egt_ex_hard_005.

INCLUDE zko_egt_ex_hard_005_top.
INCLUDE zko_egt_ex_hard_005_cls.
INCLUDE zko_egt_ex_hard_005_mdl.

START-OF-SELECTION.
  CREATE OBJECT go_main.
  CREATE OBJECT go_peris.

  go_main->start_screen( ).
