*&---------------------------------------------------------------------*
*& Report ZKO_EGT_EX_MEDIUM_006
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zko_egt_ex_hard_001 MESSAGE-ID ZKO_EGT_HRD_001.

INCLUDE zko_egt_ex_hard_001_top.
INCLUDE zko_egt_ex_hard_001_cls.
INCLUDE zko_egt_ex_hard_001_mdl.

START-OF-SELECTION.
  CREATE OBJECT go_main.
  go_main->start_screen( ).
