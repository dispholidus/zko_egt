*&---------------------------------------------------------------------*
*& Include          ZKO_EGT_KURA_001_TOP
*&---------------------------------------------------------------------*
CLASS select_screen_opereations DEFINITION DEFERRED.
CLASS screen_opereations DEFINITION DEFERRED.

PARAMETERS: rb_add  RADIOBUTTON GROUP rb1 USER-COMMAND radiobuttonchange DEFAULT 'X',
            rb_slct RADIOBUTTON GROUP rb1,

            p_winc  TYPE int4 MODIF ID slc,

            p_tc    TYPE zko_egt_de_tcno             MODIF ID blg,
            p_ad    TYPE zko_egt_de_personel_ad      MODIF ID blg,
            p_syd   TYPE zko_egt_de_personel_soyad   MODIF ID blg,
            p_desc  TYPE char200                     MODIF ID blg.



DATA: go_ssop                TYPE REF TO select_screen_opereations,
      go_sop                 TYPE REF TO screen_opereations,
      go_grid                TYPE REF TO cl_gui_alv_grid,
      go_container           TYPE REF TO cl_gui_custom_container,

      gt_fcat                TYPE lvc_t_fcat,
      gs_fcat                TYPE lvc_s_fcat,
      gs_layout              TYPE lvc_s_layo,

      gt_alvtable            TYPE TABLE OF zko_egt_t_kura,

      gv_is_add_seleceted    TYPE xfeld,
      gv_is_select_seleceted TYPE xfeld.
