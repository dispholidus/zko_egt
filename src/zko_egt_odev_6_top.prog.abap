*&---------------------------------------------------------------------*
*& Include          ZKO_EGT_ODEV_6_TOP
*&---------------------------------------------------------------------*
CLASS lcl_class DEFINITION DEFERRED.

DATA: gv_bukrs TYPE bukrs,
      gv_bstyp TYPE bstyp,
      gv_bsart TYPE bsart.

SELECT-OPTIONS: gso_bukr FOR gv_bukrs,
                gso_bsty FOR gv_bstyp,
                gso_bsar FOR gv_bsart.




DATA: go_main      TYPE REF TO lcl_class,
      go_grid      TYPE REF TO cl_gui_alv_grid,
      go_container TYPE REF TO cl_gui_custom_container,

      gt_fcat      TYPE lvc_t_fcat,
      gs_layout    TYPE lvc_s_layo,

      gt_alvtable  TYPE TABLE OF zko_egt_s_belg,
      gt_insert    TYPE TABLE OF zko_egt_t_belg.
