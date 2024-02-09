*&---------------------------------------------------------------------*
*& Report Z_KEMALO_EX_EASY_003
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zko_ex_easy_003.

PARAMETERS p_maxnum TYPE i.

DATA gv_counter TYPE i.

START-OF-SELECTION.
  gv_counter = 0.
  DO p_maxnum + 1 TIMES.
    IF gv_counter MOD 2 EQ 0.
      WRITE: / 'Çift Sayı : ' , gv_counter.
    ELSE.
      WRITE: / 'Tek Sayı  : ' , gv_counter.
    ENDIF.
    gv_counter = gv_counter + 1.
  ENDDO.
