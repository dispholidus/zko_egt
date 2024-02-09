*&---------------------------------------------------------------------*
*& Include          ZKO_EGT_EX_MEDIUM_006_TOP
*&---------------------------------------------------------------------*
CLASS lcl_class DEFINITION DEFERRED.

TYPES: BEGIN OF gtt_alv,
         matnr      TYPE matnr,
         maktx      TYPE maktx,
         labst      TYPE labst,
         button TYPE char50,
       END OF gtt_alv.
FIELD-SYMBOLS: <gfs_serbest_alv>  TYPE gtt_alv,
               <gfs_demirbas_alv> TYPE gtt_alv.

DATA: go_main               TYPE REF TO lcl_class,
      go_serbest_grid       TYPE REF TO cl_gui_alv_grid,
      go_demirbas_grid      TYPE REF TO cl_gui_alv_grid,
      go_serbest_container  TYPE REF TO cl_gui_custom_container,
      go_demirbas_container TYPE REF TO cl_gui_custom_container,

      gt_serbest_fcat       TYPE lvc_t_fcat,
      gt_demirbas_fcat      TYPE lvc_t_fcat,
      gs_fcat               TYPE lvc_s_fcat,
      gs_layout             TYPE lvc_s_layo,

      gt_serbest_alvtable   TYPE TABLE OF gtt_alv,
      gt_demirbas_alvtable  TYPE TABLE OF gtt_alv,
      gs_serbest_alvtable   TYPE gtt_alv,
      gs_demirbas_alvtable  TYPE gtt_alv.
