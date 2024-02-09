*&---------------------------------------------------------------------*
*& Include          ZKO_EGT_EX_MEDIUM_006_TOP
*&---------------------------------------------------------------------*
CLASS lcl_class DEFINITION DEFERRED.

DATA: go_main      TYPE REF TO lcl_class,
      gs_ogrtable  TYPE zko_egt_t_ogrnl,

      gt_alvtable  TYPE TABLE OF zko_egt_s_ogr_not_detay,
      gs_alvtable  TYPE zko_egt_s_ogr_not_detay,

      go_grid      TYPE REF TO cl_gui_alv_grid,
      go_container TYPE REF TO cl_gui_custom_container,

      gt_fcat      TYPE lvc_t_fcat,
      gs_layout    TYPE lvc_s_layo,

      gv_ogrid     TYPE zko_egt_de_ogrenci_id,
      gv_ograd     TYPE zko_egt_de_ogrenci_ad,
      gv_ogrsoyad  TYPE zko_egt_de_ogrenci_soyad,
      gv_dersid    TYPE zko_egt_de_ders_id,
      gv_puan      TYPE zko_egt_de_puan,
      gv_titletext TYPE char50.

PARAMETERS: rb_slct  RADIOBUTTON GROUP rb1,
            rb_insrt RADIOBUTTON GROUP rb1,
            rb_updt  RADIOBUTTON GROUP rb1,
            rb_dlt   RADIOBUTTON GROUP rb1.
