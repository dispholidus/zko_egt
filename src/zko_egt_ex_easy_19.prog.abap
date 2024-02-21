*&---------------------------------------------------------------------*
*& Report ZKO_EGT_EX_EASY_19
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zko_egt_ex_easy_19.

PARAMETERS: p_num1 TYPE i,
            p_num2 TYPE i.
DATA: gv_result TYPE p DECIMALS 2.
IF p_num1 GE p_num2.
  IF p_num2 NE 0.
    gv_result = p_num1 / p_num2.
  ENDIF.
ELSE.
  IF p_num1 NE 0.
    gv_result = p_num2 / p_num1.
  ENDIF.
ENDIF.

WRITE gv_result.
