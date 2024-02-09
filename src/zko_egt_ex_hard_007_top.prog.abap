*&---------------------------------------------------------------------*
*& Include          ZKO_EGT_EX_MEDIUM_006_TOP
*&---------------------------------------------------------------------*
CLASS lcl_class DEFINITION DEFERRED.

DATA: go_main                TYPE REF TO lcl_class,
      go_kullanici_grid      TYPE REF TO cl_gui_alv_grid,
      go_profil_grid         TYPE REF TO cl_gui_alv_grid,
      go_kullanici_container TYPE REF TO cl_gui_custom_container,
      go_profil_container    TYPE REF TO cl_gui_custom_container,

      gt_fcat                TYPE lvc_t_fcat,
      gs_fcat                TYPE lvc_s_fcat,
      gs_layout              TYPE lvc_s_layo,

      gt_kullanici_alvtable  TYPE TABLE OF zko_egt_s_user_alv,
      gs_kullanici_alvtable  TYPE zko_egt_s_user_alv,
      gt_profil_alvtable     TYPE TABLE OF zko_egt_s_profil_alv,
      gs_profil_alvtable     TYPE zko_egt_s_profil_alv.
