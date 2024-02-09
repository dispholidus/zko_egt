*&---------------------------------------------------------------------*
*& Include          Z_KEMALO_EX_EASY_010_FORM
*&---------------------------------------------------------------------*


FORM iki_sayinin_orani.
  IF p_num1 GE p_num2  AND p_num2 NE 0.
    gv_sum = p_num1 / p_num2.
  ELSEIF p_num2 GT p_num1  AND p_num1 NE 0.
    gv_sum = p_num2 / p_num1.
  ELSE.
    WRITE: '0''a bölme işlemi yapılamaz.'.
  ENDIF.
  IF gv_sum IS NOT INITIAL.
    WRITE: gv_sum.
  ENDIF.

ENDFORM.
