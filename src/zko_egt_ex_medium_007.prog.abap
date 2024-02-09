*&---------------------------------------------------------------------*
*& Report ZKO_EGT_EX_MEDIUM_007
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zko_egt_ex_medium_007.



.
PARAMETERS: p_value TYPE char20.

DATA: gv_htype TYPE dd01v-datatype.

START-OF-SELECTION.
  CALL FUNCTION 'NUMERIC_CHECK'
    EXPORTING
      string_in = p_value
    IMPORTING
      htype     = gv_htype.

  IF gv_htype EQ 'CHAR'.
    WRITE: 'Sayısal olmayan bir değer girdiniz!'.
  ELSEIF gv_htype EQ 'NUMC'.
    WRITE: 'Sayısal bir değer girdiniz!'.
  ENDIF.
