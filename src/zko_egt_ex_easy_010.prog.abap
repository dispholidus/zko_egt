*&---------------------------------------------------------------------*
*& Report Z_KEMALO_EX_EASY_010
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zko_egt_ex_easy_010.

INCLUDE ZKO_EGT_EX_EASY_010_TOP.
*INCLUDE: z_kemalo_ex_easy_010_top,
INCLUDE ZKO_EGT_EX_EASY_010_FORM.
*         z_kemalo_ex_easy_010_form.



START-OF-SELECTION.

  PERFORM iki_sayinin_orani.
