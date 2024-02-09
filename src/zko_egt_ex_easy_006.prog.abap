*&---------------------------------------------------------------------*
*& Report Z_KEMALO_EX_EASY_006
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zko_ex_easy_006.

PARAMETERS: p_num1 TYPE i.

START-OF-SELECTION.

  IF p_num1 GE 0 AND p_num1 LE 20.
    WRITE:/ 'Harf Notu: FF'.
  ELSEIF p_num1 GT 20 AND p_num1 LE 40.
    WRITE:/ 'Harf Notu: DD'.
  ELSEIF p_num1 GT 40 AND p_num1 LE 60.
    WRITE:/ 'Harf Notu: CC'.
  ELSEIF p_num1 GT 60 AND p_num1 LE 80.
    WRITE:/ 'Harf Notu: BB'.
  ELSEIF p_num1 GT 80 AND p_num1 LE 100.
    WRITE:/ 'Harf Notu: AA'.
  ELSE.
    WRITE: / 'Geçerli Not Giriniz!'.
  ENDIF.
