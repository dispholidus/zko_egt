*&---------------------------------------------------------------------*
*& Include          Z_KEMALO_EX_EASY_012_FORM
*&---------------------------------------------------------------------*

FORM hesapla.
  CASE 'X'.
    WHEN rb_top.
      gv_sum = p_num1 + p_num2.
    WHEN rb_cik.
      gv_sum = p_num1 - p_num2.
    WHEN rb_carp.
      gv_sum = p_num1 * p_num2.
    WHEN rb_bol.
      IF p_num2 NE 0.
        gv_sum = p_num1 / p_num2.
      ENDIF.
  ENDCASE.

  IF gv_sum IS NOT INITIAL.
    WRITE: gv_sum.
  ENDIF.
ENDFORM.
