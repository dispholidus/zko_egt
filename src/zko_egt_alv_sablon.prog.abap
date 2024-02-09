*&---------------------------------------------------------------------*
*& Report ZKO_EGT_EX_MEDIUM_006
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zko_egt_alv_sablon.

INCLUDE zko_egt_sablon_top.
*INCLUDE: zko_egt_ex_medium_006_top,
INCLUDE zko_egt_sablon_cls.
*         zko_egt_ex_medium_006_cls,
INCLUDE zko_egt_sablon_mdl.
*         zko_egt_ex_medium_006_mdl.

START-OF-SELECTION.
  CREATE OBJECT go_main.
  go_main->start_screen( ).
