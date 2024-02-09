*&---------------------------------------------------------------------*
*& Report Z_KEMALO_EX_EASY_007
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zko_ex_easy_007.

PARAMETERS: p_user TYPE char10,
            p_pass TYPE char20.

AT SELECTION-SCREEN OUTPUT.
  LOOP AT SCREEN.
    IF screen-name = 'P_PASS'.
      screen-invisible = '1'.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.

START-OF-SELECTION.
  IF p_user EQ 'SAPUSER' AND p_pass EQ '12345678'.
    WRITE:/ 'Başarılı bir şekilde sisteme girildi.'.
  ELSE.
    MESSAGE 'Hatalı Sifre' TYPE 'I' DISPLAY LIKE 'E'.
  ENDIF.
