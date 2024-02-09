*&---------------------------------------------------------------------*
*& Report Z_KEMALO_EX_EASY_004
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zko_ex_easy_004.

DATA gv_counter TYPE i.

START-OF-SELECTION.

  gv_counter = 1.
  WRITE: / '2''ye tam bölünen sayılar:'.
  WHILE gv_counter LE 100.

    IF gv_counter MOD 2 EQ 0.
      WRITE: gv_counter.
    ENDIF.
    gv_counter = gv_counter + 1.
  ENDWHILE.
  gv_counter = 1.
  WRITE: / '3''e tam bölünen sayılar:'.
  WHILE gv_counter LE 100.

    IF gv_counter MOD 3 EQ 0.
      WRITE: gv_counter.
    ENDIF.
    gv_counter = gv_counter + 1.
  ENDWHILE.
  gv_counter = 1.
  WRITE: / '5''e tam bölünen sayılar:'.
  WHILE gv_counter LE 100.

    IF gv_counter MOD 5 EQ 0.
      WRITE: gv_counter.
    ENDIF.
    gv_counter = gv_counter + 1.
  ENDWHILE.
