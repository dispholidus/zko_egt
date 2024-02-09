*&---------------------------------------------------------------------*
*& Report Z_KEMALO_EX_EASY_012
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zko_egt_ex_easy_012.

INCLUDE ZKO_EGT_EX_EASY_012_TOP.
*INCLUDE: z_kemalo_ex_easy_012_top,
INCLUDE ZKO_EGT_EX_EASY_012_FORM.
*         z_kemalo_ex_easy_012_form.

START-OF-SELECTION.
  PERFORM hesapla.
