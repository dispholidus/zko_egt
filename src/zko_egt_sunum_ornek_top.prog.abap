*&---------------------------------------------------------------------*
*& Include          ZKO_EGT_EX_MEDIUM_006_TOP
*&---------------------------------------------------------------------*
CLASS lcl_class DEFINITION DEFERRED.

*TYPES:
*  BEGIN OF gtt_alv,
*    matnr type matnr,
*    maktx type maktx,
*    labst type labst,
*    werks type werks_d,
*    NAME1 type NAME1,
*    lgort type lgort_d,
*    lgobe type lgobe,
*  END OF gtt_alv.

DATA: go_main  TYPE REF TO lcl_class,
      go_grid      TYPE REF TO cl_gui_alv_grid,
*      go_container TYPE REF TO cl_gui_custom_container,
*
      gt_alvtable  TYPE TABLE OF zko_egt_s_malzeme_s3,
      gs_alvtable  TYPE zko_egt_s_malzeme_s3,
*
      gt_fcat      TYPE lvc_t_fcat,
      gs_fcat      TYPE lvc_s_fcat,

      gs_layout    TYPE lvc_s_layo,
      gv_matnr TYPE matnr.

SELECT-OPTIONS s_matnr FOR gv_matnr.

PARAMETERS: p_lang TYPE spras.
