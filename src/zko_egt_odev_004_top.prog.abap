*&---------------------------------------------------------------------*
*& Include          ZKO_EGT_ODEV_004_TOP
*&---------------------------------------------------------------------*
CLASS lcl_cls DEFINITION DEFERRED.

DATA: go_main          TYPE REF TO lcl_cls,

      gt_guess         TYPE TABLE OF zko_egt_de_sayi,
      gt_winner        TYPE TABLE OF zko_egt_de_sayi,
      gv_para          TYPE int4 value 50,
      gv_parac         TYPE char10,
      gv_eklenecekpara TYPE int4,

      gv_kartno        TYPE n LENGTH 16,
      gv_kartccv       TYPE numc3,

      gv_guess1        TYPE  zko_egt_de_sayi,
      gv_guess2        TYPE  zko_egt_de_sayi,
      gv_guess3        TYPE  zko_egt_de_sayi,
      gv_guess4        TYPE  zko_egt_de_sayi,
      gv_guess5        TYPE  zko_egt_de_sayi,
      gv_guess6        TYPE  zko_egt_de_sayi,

      gv_winner1       TYPE  zko_egt_de_sayi,
      gv_winner2       TYPE  zko_egt_de_sayi,
      gv_winner3       TYPE  zko_egt_de_sayi,
      gv_winner4       TYPE  zko_egt_de_sayi,
      gv_winner5       TYPE  zko_egt_de_sayi,
      gv_winner6       TYPE  zko_egt_de_sayi,

      gv_iscardlegit   TYPE  xfeld VALUE ''.

FIELD-SYMBOLS <gfs_parac> TYPE char10.
