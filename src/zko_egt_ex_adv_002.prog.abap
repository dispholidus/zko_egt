*&---------------------------------------------------------------------*
*& Report ZKO_EGT_EX_MEDIUM_006
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zko_egt_ex_adv_002.

INCLUDE: zko_egt_ex_adv_002_top,
         zko_egt_ex_adv_002_cls,
         zko_egt_ex_adv_002_mdl.

START-OF-SELECTION.
  CREATE OBJECT go_main.
  go_main->start_screen( ).
