*&---------------------------------------------------------------------*
*& Include          ZKO_EGT_EX_MEDIUM_006_TOP
*&---------------------------------------------------------------------*
CLASS lcl_class DEFINITION DEFERRED.
FIELD-SYMBOLS: <gfs_fcat> TYPE lvc_s_fcat.
DATA: go_main                 TYPE REF TO lcl_class,
      go_progcount_grid       TYPE REF TO cl_gui_alv_grid,
      go_progdetail_grid      TYPE REF TO cl_gui_alv_grid,
      go_progcount_container  TYPE REF TO cl_gui_custom_container,
      go_progdetail_container TYPE REF TO cl_gui_custom_container,

      gt_fcat                 TYPE lvc_t_fcat,
      gs_layout               TYPE lvc_s_layo,

      gt_progcount_alvtable   TYPE TABLE OF zko_egt_s_alvprogcount,
      gs_progcount_alvtable   TYPE zko_egt_s_alvprogcount,
      gt_progdetail_alvtable  TYPE TABLE OF zko_egt_s_alvprogdetail,
      gs_progdetail_alvtable  TYPE zko_egt_s_alvprogdetail.
