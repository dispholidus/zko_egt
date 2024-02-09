*&---------------------------------------------------------------------*
*& Report Z_KEMALO_EX_EASY_005
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zko_ex_easy_005.

PARAMETERS: p_num1 TYPE i.

START-OF-SELECTION.

  IF p_num1 GE 0 AND p_num1 LE 25.
    WRITE:/ 'Sayı 0 ve 25 arasında'.
  ELSEIF p_num1 GT 25 AND p_num1 LE 50.
    WRITE:/ 'Sayı 25 ve 50 arasında'.
  ELSEIF p_num1 GT 50 AND p_num1 LE 75.
    WRITE:/ 'Sayı 50 ve 75 arasında'.
  ELSEIF p_num1 GT 75 AND p_num1 LE 100.
    WRITE:/ 'Sayı 75 ve 100 arasında'.
  ELSEIF p_num1 GT 100.
    WRITE:/ 'Sayı 100''den büyük.'.
  ENDIF.
