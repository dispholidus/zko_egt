*&---------------------------------------------------------------------*
*& Report Z_KEMALO_EX_EASY_015
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zko_egt_ex_easy_015.

INCLUDE ZKO_EGT_EX_EASY_015_TOP.
*INCLUDE: z_kemalo_ex_easy_015_top,
INCLUDE ZKO_EGT_EX_EASY_015_FORM.
*         z_kemalo_ex_easy_015_form.


START-OF-SELECTION.

  gv_num = 10.

  PERFORM uc_carp.
  PERFORM iki_bol.
  PERFORM dort_cikar.
  PERFORM yedi_ekle.
  PERFORM dort_cikar.
  PERFORM uc_carp.

  WRITE: gv_num.
