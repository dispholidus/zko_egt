*&---------------------------------------------------------------------*
*& Report Z_KEMALO_EX_EASY_014
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zko_egt_ex_easy_014.

INCLUDE ZKO_EGT_EX_EASY_014_TOP.
*INCLUDE: z_kemalo_ex_easy_014_top,
INCLUDE ZKO_EGT_EX_EASY_014_FORM.
*         z_kemalo_ex_easy_014_form.



START-OF-SELECTION.

  PERFORM hesapla.
