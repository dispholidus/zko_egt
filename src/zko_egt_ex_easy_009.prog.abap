*&---------------------------------------------------------------------*
*& Report Z_KEMALO_EX_EASY_009
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zko_egt_ex_easy_009.

PARAMETERS: p_num1  TYPE i,
            p_num2  TYPE i,
            p_islem TYPE ZKo_egt_de_islem.
DATA: gv_sum TYPE i.

START-OF-SELECTION.

  CASE p_islem.
    WHEN '+'.
      gv_sum = p_num1 + p_num2.
    WHEN '-'.
      gv_sum = p_num1 - p_num2.
    WHEN '*'.
      gv_sum = p_num1 * p_num2.
    WHEN '/'.
      IF p_num2 EQ 0.
        WRITE: '0''a bölemezsiniz!'.
      ELSE.
        gv_sum = p_num1 / p_num2.
      ENDIF.

    WHEN OTHERS.
      WRITE: 'Geçerli bir işlem girin.'.
  ENDCASE.
  IF gv_sum IS NOT INITIAL.
    WRITE: / gv_sum.
  ENDIF.
