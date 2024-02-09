*&---------------------------------------------------------------------*
*& Include          ZKO_EGT_EX_HARD_5_TOP
*&---------------------------------------------------------------------*

CLASS lcl_class DEFINITION DEFERRED.

DATA: go_main  TYPE REF TO lcl_class,
      go_peris TYPE REF TO zko_egt_c_personel_islemleri,

      gv_pernr TYPE p_pernr,
      gv_descp  TYPE zko_egt_de_descp.
