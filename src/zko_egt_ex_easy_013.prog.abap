*&---------------------------------------------------------------------*
*& Report Z_KEMALO_EX_EASY_013
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zko_egt_ex_easy_013.

INCLUDE ZKO_EGT_EX_EASY_013_TOP.
*INCLUDE: z_kemalo_ex_easy_013_top,
INCLUDE ZKO_EGT_EX_EASY_013_FORM.
*         z_kemalo_ex_easy_013_form.



START-OF-SELECTION.

  gv_sum = 10.

  IF p_iki EQ abap_true.
    PERFORM iki_ekle.
  ENDIF.
  IF p_uc EQ abap_true.
    PERFORM uc_ekle.
  ENDIF.
  IF p_bes EQ abap_true.
    PERFORM bes_ekle.
  ENDIF.

  WRITE : gv_sum.
