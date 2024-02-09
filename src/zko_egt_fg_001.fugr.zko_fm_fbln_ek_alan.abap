FUNCTION zko_fm_fbln_ek_alan.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(I_POSTAB) LIKE  RFPOS STRUCTURE  RFPOS
*"  EXPORTING
*"     VALUE(E_POSTAB) LIKE  RFPOS STRUCTURE  RFPOS
*"----------------------------------------------------------------------
*
  DATA: lv_isim TYPE name1.

  e_postab = i_postab.

  IF i_postab-koart EQ 'K'.
    SELECT SINGLE name1 FROM lfa1 INTO lv_isim WHERE lifnr EQ i_postab-konto.
  ELSEIF i_postab-koart EQ 'D'.
    SELECT SINGLE name1 FROM kna1 INTO lv_isim WHERE kunnr EQ i_postab-konto.
  ELSEIF i_postab-koart EQ 'S'.
    SELECT SINGLE txt50 FROM skat INTO lv_isim WHERE saknr EQ i_postab-konto.
  ENDIF.

  e_postab-zko_ad = lv_isim.
*  -------------- initialize Output by using the following line ----------
*   e_postab = i_posta!b.

ENDFUNCTION.
