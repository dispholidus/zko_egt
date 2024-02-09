*&---------------------------------------------------------------------*
*& Report Z_KEMALO_EX_EASY_008
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZKO_EX_EASY_008.

PARAMETERS: p_num1 TYPE i,
            p_num2 TYPE i,
            p_num3 TYPE i.

START-OF-SELECTION.

  IF p_num1 LE p_num2 AND p_num2 LE p_num3.
    WRITE: 'İkinci sayı diğer iki sayının ortasındadır.'.
  ELSEIF p_num3 LE p_num2 AND p_num2 LE p_num1.
    WRITE: 'İkinci sayı diğer iki sayının ortasındadır.'.
  ELSEIF: p_num2 LE p_num3 AND p_num3 LE p_num1.
    WRITE: 'Üçüncü sayı diğer iki sayının ortasındadır.'.

  ELSEIF p_num1 LE p_num2 AND p_num3 LE p_num2 AND p_num1 LE p_num3.
    WRITE: 'Üçüncü sayı diğer iki sayının ortasındadır.'.
  ELSEIF p_num3 LE p_num2 AND p_num1 LE p_num2 AND p_num3 LE p_num1.
    WRITE: 'Birinci sayı diğer iki sayının ortasındadır.'.
  ELSEIF: p_num2 LE p_num3 AND p_num1 LE p_num3 AND p_num2 LE p_num1.
    WRITE: 'Birinci sayı diğer iki sayının ortasındadır.'.
  ENDIF.
