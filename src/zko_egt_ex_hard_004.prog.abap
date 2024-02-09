*&---------------------------------------------------------------------*
*& Report ZKO_EGT_EX_HARD_004
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zko_egt_ex_hard_004.

INCLUDE: zko_egt_ex_hard_004_top,
         zko_egt_ex_hard_004_cls,
         zko_egt_ex_hard_004_mdl.


INITIALIZATION.
  CREATE OBJECT go_main.
  button =  'Örnek Excel'.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.

  CALL FUNCTION 'F4_FILENAME'
    EXPORTING
      field_name = 'P_FILE'
    IMPORTING
      file_name  = p_file.

AT SELECTION-SCREEN.
  CASE sscrfields.
    WHEN 'BUT1'.
      go_main->generate_excel( ).
  ENDCASE.

START-OF-SELECTION.
  go_main->read_excel( ).
  go_main->insert_excel( ).
  go_main->start_screen( ).
