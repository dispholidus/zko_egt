*&---------------------------------------------------------------------*
*& Report ZKO_EGT_EX_MEDIUM_001
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zko_egt_ex_medium_001.

INCLUDE: zko_egt_ex_medium_001_top,
         zko_egt_ex_medium_001_cls,
         zko_egt_ex_medium_001_mdl.

START-OF-SELECTION.


  CREATE OBJECT go_main.
  go_main->start_screen( ).
