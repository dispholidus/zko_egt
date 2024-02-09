*&---------------------------------------------------------------------*
*& Include          ZKO_EGT_ODEV_002_TOP
*&---------------------------------------------------------------------*
CLASS lcl_main DEFINITION DEFERRED.
PARAMETERS:
  p_bukrs TYPE bukrs OBLIGATORY.

DATA:
  gv_belnr TYPE belnr_d,
  gv_pswsl TYPE pswsl.

SELECT-OPTIONS:
  gso_beln FOR gv_belnr,
  gso_psws       FOR gv_pswsl.


TYPES:
  BEGIN OF gtt_alv,
    bukrs TYPE bukrs,
    belnr TYPE belnr_d,
    gjahr TYPE gjahr,
    kunnr TYPE char10,
    name1 TYPE char61,
    pswsl TYPE pswsl,
    wrbtr TYPE wrbtr,
    bldat TYPE bldat,
  END OF gtt_alv.

DATA:
  go_main      TYPE REF TO lcl_main,
  go_grid      TYPE REF TO cl_gui_alv_grid,
  go_container TYPE REF TO cl_gui_custom_container,

  gt_fcat      TYPE lvc_t_fcat,
  gs_fcat      TYPE lvc_s_fcat,
  gs_layout    TYPE lvc_s_layo,

  gt_alvtable  TYPE TABLE OF gtt_alv,
  gs_alvtable  TYPE gtt_alv.
