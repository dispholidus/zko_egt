*&---------------------------------------------------------------------*
*& Include          ZKO_EGT_EX_MEDIUM_003_TOP
*&---------------------------------------------------------------------*


CLASS lcl_cls DEFINITION DEFERRED.

DATA: go_main      TYPE REF TO lcl_cls,
      go_grid      TYPE REF TO cl_gui_alv_grid,
      go_container TYPE REF TO cl_gui_custom_container,

      gt_alvtable  TYPE TABLE OF zko_egt_s_malzeme_s3,
      gs_alvtable  TYPE zko_egt_s_malzeme_s3,

      gt_fcat      TYPE lvc_t_fcat,
      gs_layout    TYPE lvc_s_layo,

      gv_matnr     TYPE matnr.

SELECT-OPTIONS s_matnr FOR gv_matnr NO INTERVALS.

PARAMETERS: p_lang TYPE spras.
