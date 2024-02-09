*&---------------------------------------------------------------------*
*& Report ZKO_EGT_EX_MEDIUM_004
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zko_egt_ex_medium_004 MESSAGE-ID zko_egt_mc_med_004.

INCLUDE: zko_egt_ex_medium_004_top,
         zko_egt_ex_medium_004_cls,
         zko_egt_ex_medium_004_mdl.

START-OF-SELECTION.
  CREATE OBJECT go_main.
  go_main->randomize_number( ).
  go_main->start_screen( ).
