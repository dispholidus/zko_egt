*&---------------------------------------------------------------------*
*& Include          ZKO_EGT_EX_MEDIUM_001_TOP
*&---------------------------------------------------------------------*

*PARAMETERS: p_matnr TYPE matnr18.

CLASS lcl_main DEFINITION DEFERRED.

DATA: go_main       TYPE REF TO lcl_main,
      go_grid       TYPE REF TO cl_gui_alv_grid,
      go_container  TYPE REF TO cl_gui_custom_container,

      gt_malzeme    TYPE TABLE OF zko_egt_s_malzeme,
      gs_malzeme    TYPE zko_egt_s_malzeme,
      gs_bapimatdoa TYPE bapimatdoa,

      gt_fcat       TYPE lvc_t_fcat,
      gs_fcat       TYPE lvc_s_fcat,
      gs_layout     TYPE lvc_s_layo,
      gv_matnr      TYPE matnr18.

SELECT-OPTIONS: s_matnr FOR gv_matnr NO INTERVALS.
