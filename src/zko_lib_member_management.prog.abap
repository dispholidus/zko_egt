*&---------------------------------------------------------------------*
*& Report ZKO_EGT_ODEV_005
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zko_lib_member_management.

INCLUDE ZKO_LIB_MEMBER_MANAGEMENT_TOP.
*INCLUDE: zko_egt_odev_005_top,
INCLUDE ZKO_LIB_MEMBER_MANAGEMENT_CLS.
*         zko_egt_odev_005_cls,
INCLUDE ZKO_LIB_MEMBER_MANAGEMENT_MDL.
*         zko_egt_odev_005_mdl.

START-OF-SELECTION.
  CREATE OBJECT go_main.
  go_main->start_screen( ).
