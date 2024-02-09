*&---------------------------------------------------------------------*
*& Report ZKO_EGT_EX_EASY_018
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zko_egt_ex_easy_018.

DATA: gv_rand TYPE i.

CALL FUNCTION 'QF05_RANDOM_INTEGER'
  EXPORTING
    ran_int_max   = 150
    ran_int_min   = 1
  IMPORTING
    ran_int       = gv_rand
  EXCEPTIONS
    invalid_input = 1
    OTHERS        = 2.
IF sy-subrc EQ 0.
  IF gv_rand GE 0 AND gv_rand LE 25.
    WRITE:/ 'Sayı 0 ve 25 arasında'.
  ELSEIF gv_rand GT 25 AND gv_rand LE 50.
    WRITE:/ 'Sayı 25 ve 50 arasında'.
  ELSEIF gv_rand GT 50 AND gv_rand LE 75.
    WRITE:/ 'Sayı 50 ve 75 arasında'.
  ELSEIF gv_rand GT 75 AND gv_rand LE 100.
    WRITE:/ 'Sayı 75 ve 100 arasında'.
  ELSEIF gv_rand GT 100.
    WRITE:/ 'Sayı 100''den büyük.'.
  ENDIF.
ENDIF.
