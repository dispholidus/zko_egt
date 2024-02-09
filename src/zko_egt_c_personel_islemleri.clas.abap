class ZKO_EGT_C_PERSONEL_ISLEMLERI definition
  public
  final
  create public .

public section.

  methods PERSONEL_KONTROLU
    importing
      !IV_PERNR type P_PERNR
    exporting
      !EV_SUCCESS type XFELD
      !EV_MESSAGE type BAPI_MSG .
  methods PERSONEL_AKTIVITE_EKLE
    importing
      !IV_PERNR type P_PERNR
      !IV_ACTDATE type DATUM
      !IV_DESCP type ZKO_EGT_DE_DESCP
    exporting
      !EV_SUCCESS type XFELD
      !EV_MESSAGE type BAPI_MSG .
protected section.
private section.
ENDCLASS.



CLASS ZKO_EGT_C_PERSONEL_ISLEMLERI IMPLEMENTATION.


METHOD personel_aktivite_ekle.

  DATA: ls_persakt TYPE zko_egt_t_perakt.

  SELECT SINGLE start_date FROM zko_egt_t_persv3
    INTO  @DATA(lv_pers)
    WHERE pernr EQ @iv_pernr.
  IF iv_actdate GE lv_pers.
    SELECT SINGLE * FROM zko_egt_t_perakt
    INTO @DATA(ls_perakt)
    WHERE act_date EQ @iv_actdate AND pernr EQ @iv_pernr.

    IF ls_perakt IS NOT INITIAL.
      ev_success = ''.
      ev_message =  iv_pernr && ' no''lu personelin ' && iv_actdate && ' tarihinde önceden aktivitesi girilmiş!'.
    ELSE.
      ls_persakt-pernr = iv_pernr.
      ls_persakt-act_date = iv_actdate.
      ls_persakt-descp = iv_descp.

      INSERT zko_egt_t_perakt FROM ls_persakt .
      ev_success = 'X'.
    ENDIF.

  ELSE.
    ev_success = ''.
    ev_message =  'Personel işe başlama tarihinden öncesine aktivite giremez!' .
  ENDIF.

ENDMETHOD.


  METHOD personel_kontrolu.

    SELECT SINGLE * FROM zko_egt_t_persv3
      INTO @DATA(lv_pers)
      WHERE pernr EQ @iv_pernr.
    IF sy-subrc EQ 0.
      ev_success = 'X'.
    ELSEIF sy-subrc EQ 4.
      ev_success = ''.
      ev_message = 'Personel numarası bulunamadı!'.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
