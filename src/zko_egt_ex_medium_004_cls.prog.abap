*&---------------------------------------------------------------------*
*& Include          ZKO_EGT_EX_MEDIUM_004_CLS
*&---------------------------------------------------------------------*

CLASS lcl_cls DEFINITION.
  PUBLIC SECTION.
    METHODS : start_screen,
      pbo_0100,
      pai_0100 IMPORTING iv_ucomm TYPE sy-ucomm,
      randomize_number.
ENDCLASS.

CLASS lcl_cls IMPLEMENTATION.
  METHOD start_screen.
    CALL SCREEN 0100.
  ENDMETHOD.

  METHOD pbo_0100.
    SET PF-STATUS 'STATUS_0100'.
  ENDMETHOD.

  METHOD pai_0100.
    CASE iv_ucomm.
      WHEN '&BACK'.
        SET SCREEN 0.
      WHEN '&THMN'.
        IF gv_guessrnum NE gv_randnum.
          IF gv_guessrnum GT gv_randnum.
            MESSAGE i002.
          ELSE.
            MESSAGE i001.
          ENDIF.
          gv_oldguess = gv_oldguess && | | && gv_guessrnum.
        ELSE.
          MESSAGE i000.
          CLEAR gv_oldguess.
          go_main->randomize_number( ).
        ENDIF.
    ENDCASE.
  ENDMETHOD.

  METHOD randomize_number.
    CALL FUNCTION 'QF05_RANDOM_INTEGER'
      EXPORTING
        ran_int_max = 100
        ran_int_min = 1
      IMPORTING
        ran_int     = gv_randnum.

  ENDMETHOD.
ENDCLASS.
