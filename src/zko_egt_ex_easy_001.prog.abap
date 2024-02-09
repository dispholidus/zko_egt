*&---------------------------------------------------------------------*
*& Report Z_KEMALO_EX_EASY_001
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zko_egt_ex_easy_001.


PARAMETERS: p_num1 TYPE i,
            p_num2 TYPE i,
            p_num3 TYPE i.

START-OF-SELECTION.

  IF p_num1 LE p_num2 AND p_num2 LE p_num3.
    WRITE: p_num1 , p_num2, p_num3.
  ELSEIF p_num3 LE p_num2 AND p_num2 LE p_num1.
    WRITE: p_num3, p_num2, p_num1.
  ELSEIF: p_num2 LE p_num3 AND p_num3 LE p_num1.
    WRITE: p_num2 , p_num3, p_num1.

  ELSEIF p_num1 LE p_num2 AND p_num3 LE p_num2 AND p_num1 LE p_num3.
    WRITE: p_num1 , p_num3, p_num2.
  ELSEIF p_num3 LE p_num2 AND p_num1 LE p_num2 AND p_num3 LE p_num1.
    WRITE: p_num3, p_num1, p_num2.
  ELSEIF: p_num2 LE p_num3 AND p_num1 LE p_num3 AND p_num2 LE p_num1.
    WRITE: p_num2 , p_num1, p_num3.

  ENDIF.
