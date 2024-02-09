*&---------------------------------------------------------------------*
*& Include          ZKO_EGT_ODEV_005_TOP
*&---------------------------------------------------------------------*
CLASS lcl_class DEFINITION DEFERRED.

DATA: go_main           TYPE REF TO lcl_class,
      go_grid           TYPE REF TO cl_gui_alv_grid,
      go_grid_0300      TYPE REF TO cl_gui_alv_grid,
      go_grid_0400      TYPE REF TO cl_gui_alv_grid,
      go_container      TYPE REF TO cl_gui_custom_container,
      go_container_0300 TYPE REF TO cl_gui_custom_container,
      go_container_0400 TYPE REF TO cl_gui_custom_container,

      gt_fcat           TYPE lvc_t_fcat,
      gs_layout         TYPE lvc_s_layo,

      gt_alvtable       TYPE TABLE OF zko_lib_member,
      gt_alvtable_book  TYPE TABLE OF zko_lib_book,
      gt_alvtable_brrw  TYPE TABLE OF zko_lib_borrow,
      gs_kullanici      TYPE zko_lib_member.
