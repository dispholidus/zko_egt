*&---------------------------------------------------------------------*
*& Include          ZKO_EGT_EX_MEDIUM_006_TOP
*&---------------------------------------------------------------------*
CLASS lcl_class_0100 DEFINITION DEFERRED.
CLASS lcl_class_0200 DEFINITION DEFERRED.

TYPES: BEGIN OF gtt_alv_0100,
         personel_id           TYPE zpers_id,
         personel_ad           TYPE zpers_ad,
         personel_soyad        TYPE zpers_soyad,
         personel_departman_id TYPE zpers_departman_id,
         personel_title_id     TYPE zpers_title_id,
         toplam_tecrube        TYPE zpers_tecrube,
         line_color            TYPE char4,
         is_editable           TYPE lvc_t_styl,
       END OF gtt_alv_0100.

TYPES: BEGIN OF gtt_alv_0200,
         personel_id           TYPE zpers_id,
         personel_ad           TYPE zpers_ad,
         personel_soyad        TYPE zpers_soyad,
         personel_departman_ad TYPE zpers_departman_ad,
         personel_title_ad     TYPE zpers_title_ad,
         toplam_tecrube        TYPE zpers_tecrube,
         personel_maas         TYPE int4,
         personel_yillik_izin  TYPE char10,
       END OF gtt_alv_0200.

DATA: gv_pa  TYPE  zpers_ad,
      gv_psa TYPE  zpers_soyad,
      gv_pda TYPE  zpers_departman_ad,
      gv_pta TYPE  zpers_title_ad.

DATA: go_main_0100     TYPE REF TO lcl_class_0100,
      go_main_0200     TYPE REF TO lcl_class_0200,
      go_grid          TYPE REF TO cl_gui_alv_grid,
      go_container     TYPE REF TO cl_gui_custom_container,

      gt_fcat          TYPE lvc_t_fcat,
      gs_fcat          TYPE lvc_s_fcat,
      gs_layout        TYPE lvc_s_layo,

      gt_alvtable_0100 TYPE TABLE OF gtt_alv_0100,
      gs_alvtable_0100 TYPE gtt_alv_0100,
      gt_alvtable_0200 TYPE TABLE OF gtt_alv_0200,
      gs_alvtable_0200 TYPE gtt_alv_0200.

PARAMETERS: rb_yeni RADIOBUTTON GROUP rb1 USER-COMMAND usr1,
            rb_lstl RADIOBUTTON GROUP rb1.

SELECT-OPTIONS: gso_pa  FOR gv_pa  NO INTERVALS MODIF ID gso,
                gso_psa FOR gv_psa NO INTERVALS MODIF ID gso,
                gso_pda FOR gv_pda NO INTERVALS MODIF ID gso,
                gso_pta FOR gv_pta NO INTERVALS MODIF ID gso.
