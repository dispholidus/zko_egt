*&---------------------------------------------------------------------*
*& Include          ZKO_EGT_EX_MEDIUM_006_TOP
*&---------------------------------------------------------------------*
CLASS lcl_class DEFINITION DEFERRED.

FIELD-SYMBOLS: <gt_alv> TYPE STANDARD TABLE,
               <gs_alv>,
               <gf_alv>.

DATA: go_main      TYPE REF TO lcl_class,
      go_grid      TYPE REF TO cl_gui_alv_grid,
      go_container TYPE REF TO cl_gui_custom_container,

      gt_fcat      TYPE lvc_t_fcat,
      gs_fcat      TYPE lvc_s_fcat,
      gs_layout    TYPE lvc_s_layo.
