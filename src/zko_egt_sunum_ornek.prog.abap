*&---------------------------------------------------------------------*
*& Report ZKO_EGT_EX_MEDIUM_006
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zko_egt_sunum_ornek.

INCLUDE: zko_egt_sunum_ornek_top,
         zko_egt_sunum_ornek_cls,
         zko_egt_sunum_ornek_mdl.

START-OF-SELECTION.
  CREATE OBJECT go_main.
  go_main->start_screen( ).