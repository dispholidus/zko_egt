*&---------------------------------------------------------------------*
*& Report ZKO_EGT_EX_MEDIUM_006
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zko_egt_ex_hard_007.

INCLUDE: zko_egt_ex_hard_007_top,
         zko_egt_ex_hard_007_cls,
         zko_egt_ex_hard_007_mdl.

START-OF-SELECTION.
  CREATE OBJECT go_main.
  go_main->start_screen( ).
