*&---------------------------------------------------------------------*
*& Report ZKO_EGT_EX_MEDIUM_003
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zko_egt_ex_medium_003.

INCLUDE: zko_egt_ex_medium_003_top,
         zko_egt_ex_medium_003_cls,
         zko_egt_ex_medium_003_mdl.


START-OF-SELECTION.
  CREATE OBJECT go_main.
  go_main->start_screen( ).
