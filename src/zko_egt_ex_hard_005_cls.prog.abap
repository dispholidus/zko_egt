*&---------------------------------------------------------------------*
*& Include          ZKO_EGT_EX_HARD_5_CLS
*&---------------------------------------------------------------------*
CLASS lcl_class DEFINITION.
  PUBLIC SECTION.
    METHODS: start_screen,
      pbo_0100,
      pai_0100 IMPORTING iv_ucomm TYPE sy-ucomm,
      ekle.
ENDCLASS.

CLASS lcl_class  IMPLEMENTATION.
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
      WHEN '&EKLE'.
        go_main->ekle( ).
    ENDCASE.
  ENDMETHOD.

  METHOD ekle.
    DATA: lv_success TYPE xfeld,
          lv_message TYPE bapi_msg.
    IF gv_descp IS NOT INITIAL AND gv_pernr IS NOT INITIAL.
      go_peris->personel_kontrolu(
        EXPORTING
          iv_pernr   = gv_pernr
        IMPORTING
          ev_success = lv_success
          ev_message = lv_message
      ).

      IF lv_success EQ 'X'.
        go_peris->personel_aktivite_ekle(
          EXPORTING
            iv_pernr   = gv_pernr
            iv_actdate = sy-datum
            iv_descp   = gv_descp
          IMPORTING
            ev_success = lv_success
            ev_message = lv_message
        ).
        IF lv_success EQ 'X'.
          MESSAGE 'Başarı ile eklendi!' TYPE 'I' DISPLAY LIKE 'S'.
        ELSE.
          MESSAGE lv_message TYPE 'I' DISPLAY LIKE 'E'.
        ENDIF.
      ELSE.
        MESSAGE lv_message TYPE 'I' DISPLAY LIKE 'E'.
      ENDIF.
    ELSE.
      MESSAGE 'ALANLAR BOŞ BIRAKILAMAZ!' TYPE 'I' DISPLAY LIKE 'E'.
    ENDIF.
  ENDMETHOD.

ENDCLASS.
