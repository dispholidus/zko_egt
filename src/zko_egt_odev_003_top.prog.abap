*&---------------------------------------------------------------------*
*& Include          ZKO_EGT_EX_MEDIUM_006_TOP
*&---------------------------------------------------------------------*
CLASS lcl_class DEFINITION DEFERRED.
TYPES: BEGIN OF gtt_alv,
         bname    TYPE xubname,
         agr_name TYPE agr_name,
         from_dat TYPE datum,
         to_dat   TYPE datum,
       END OF gtt_alv.
DATA gv_bname TYPE bname.
SELECT-OPTIONS:gso_bnam FOR gv_bname NO INTERVALS.

PARAMETERS: p_strtd TYPE datum OBLIGATORY,
            p_endd  TYPE datum OBLIGATORY.



DATA: go_main      TYPE REF TO lcl_class,
      go_grid      TYPE REF TO cl_gui_alv_grid,
      go_container TYPE REF TO cl_gui_custom_container,

      gt_fcat      TYPE lvc_t_fcat,
      gs_fcat      TYPE lvc_s_fcat,
      gs_layout    TYPE lvc_s_layo,

      gt_alvtable  TYPE TABLE OF gtt_alv,
      gs_alvtable  TYPE gtt_alv.
