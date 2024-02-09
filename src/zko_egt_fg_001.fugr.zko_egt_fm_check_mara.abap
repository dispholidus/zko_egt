FUNCTION zko_egt_fm_check_mara .
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IT_MATNR_TABLE) TYPE  ZKO_EGT_TT_MATNR_INPUT
*"  EXPORTING
*"     REFERENCE(EV_STATUS_OUTPUT) TYPE  ZKO_EGT_TT_MATNR_OUTPUT
*"----------------------------------------------------------------------
  DATA: lt_mara   TYPE TABLE OF mara,
        ls_output TYPE zko_egt_s_matnr_output.

  SELECT matnr FROM mara
    FOR ALL ENTRIES IN @it_matnr_table
    WHERE matnr EQ @it_matnr_table-matnr
    INTO CORRESPONDING FIELDS OF TABLE @lt_mara.

  LOOP AT it_matnr_table INTO DATA(ls_matnr).
    ls_output-matnr = ls_matnr-matnr.

    READ TABLE lt_mara INTO DATA(ls_mara) WITH KEY matnr = ls_matnr-matnr.
    IF sy-subrc EQ 0.
      ls_output-output = 'VAR'.
    ELSE.
      ls_output-output = 'YOK'.
    ENDIF.
    APPEND ls_output TO ev_status_output.
  ENDLOOP.
ENDFUNCTION.
