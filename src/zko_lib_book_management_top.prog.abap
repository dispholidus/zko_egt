*&---------------------------------------------------------------------*
*& Include          ZKO_LIB_BOOK_MANAGEMENT_TOP
*&---------------------------------------------------------------------*
CLASS lcl_cls DEFINITION DEFERRED.

DATA: go_main             TYPE REF TO lcl_cls,
      go_grid             TYPE REF TO cl_gui_alv_grid,
      go_container        TYPE REF TO cl_gui_custom_container,
      go_grid_insert      TYPE REF TO cl_gui_alv_grid,
      go_container_insert TYPE REF TO cl_gui_custom_container,

      gt_fcat             TYPE lvc_t_fcat,
      gs_layout           TYPE lvc_s_layo,

      gt_alvtable         TYPE TABLE OF zko_lib_book,
      gs_insert           TYPE zko_lib_book.
