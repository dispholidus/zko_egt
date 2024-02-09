FUNCTION zko_egt_fm_ex_hard_2.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IT_EBELN) TYPE  ZKO_EGT_TT_EBELN
*"  EXPORTING
*"     REFERENCE(ET_OUTPUT) TYPE  ZKO_EGT_TT_EX_HARD_OUTPUT_002
*"----------------------------------------------------------------------
  DATA : lt_output TYPE  TABLE OF zko_egt_s_ex_hard_output_002,
         ls_output TYPE zko_egt_s_ex_hard_output_002.

  SELECT sas~ebeln, mlg~mblnr, mlg~mjahr, fat~belnr, fat~gjahr
    FROM zko_egt_t_sas AS sas
    LEFT JOIN zko_egt_t_mlg    AS mlg ON sas~ebeln EQ mlg~ebeln
    LEFT JOIN zko_egt_t_fatura AS fat ON fat~mblnr EQ mlg~mblnr
                                     AND fat~mjahr EQ mlg~mjahr
    INTO CORRESPONDING FIELDS OF TABLE @lt_output
    FOR ALL ENTRIES IN @it_ebeln
    WHERE sas~ebeln EQ @it_ebeln-ebeln.

  LOOP AT lt_output INTO ls_output.
    IF ls_output-mblnr IS INITIAL.
      ls_output-durum = 'SAS Mevcut.'.
    ELSEIF ls_output-belnr IS INITIAL.
      ls_output-durum = 'SAS ve Mal Girişi Mevcut.'.
    ELSE.
      ls_output-durum = 'SAS, Mal Girişi ve Fatura Mevcut '.
    ENDIF.
    APPEND ls_output TO et_output.
  ENDLOOP.

  CLEAR ls_output.

  LOOP AT it_ebeln INTO DATA(ls_ebeln).
    READ TABLE lt_output INTO ls_output WITH KEY ebeln = ls_ebeln-ebeln.
    IF sy-subrc NE 0.
      ls_output-ebeln = ls_ebeln-ebeln.
      ls_output-durum = 'SAS Bulunamadı.'.
      APPEND ls_output TO et_output.
    ENDIF.
  ENDLOOP.

  SORT et_output ASCENDING BY ebeln ASCENDING mblnr ASCENDING belnr.
ENDFUNCTION.
