*&---------------------------------------------------------------------*
*& Report Z_KEMALO_EX_EASY_002
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zko_egt_ex_easy_002.


PARAMETERS: p_width TYPE i.

DATA: gv_counter TYPE i.

START-OF-SELECTION.

  gv_counter = 1.
  WHILE gv_counter LE p_width.
    DO gv_counter  TIMES.
      WRITE: '*'.
    ENDDO.
    WRITE : /.
    gv_counter = gv_counter + 1.
  ENDWHILE.
  WHILE gv_counter GT 0.
    DO gv_counter  TIMES.
      WRITE: '*'.
    ENDDO.
    WRITE : /.
    gv_counter = gv_counter - 1.
  ENDWHILE.
