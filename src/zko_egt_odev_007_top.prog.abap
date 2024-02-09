*&---------------------------------------------------------------------*
*& Include          ZKO_EGT_ODEV_007_TOP
*&---------------------------------------------------------------------*

CLASS lcl_class DEFINITION DEFERRED.
DATA: gv_audat TYPE audat,
      gv_vbtyp TYPE vbtyp,
      gv_auart TYPE auart.

SELECT-OPTIONS: gso_auda FOR gv_audat,
                gso_vbty FOR gv_vbtyp,
                gso_auar FOR gv_auart.

DATA: go_main      TYPE REF TO lcl_class,
      go_grid      TYPE REF TO cl_gui_alv_grid,
      go_container TYPE REF TO cl_gui_custom_container,

      gt_fcat      TYPE lvc_t_fcat,
      gs_layout    TYPE lvc_s_layo,

      gt_alvtable  TYPE TABLE OF zko_egt_t_odev_7,
      gt_insert    TYPE TABLE OF zko_egt_t_odev_7.
