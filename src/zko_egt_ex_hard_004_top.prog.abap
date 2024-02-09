*&---------------------------------------------------------------------*
*& Include          ZKO_EGT_EX_HARD_004_TOP
*&---------------------------------------------------------------------*
PARAMETERS: p_file TYPE rlgrap-filename.


SELECTION-SCREEN:
PUSHBUTTON /2(15) button USER-COMMAND but1.

TABLES: sscrfields.


TYPES: BEGIN OF gty_envlis,
         envanter_id TYPE zenvanter_id,
         adet        TYPE zadet,
       END OF gty_envlis.

TYPES: BEGIN OF gty_header,
         line TYPE char30,
       END OF gty_header.
CLASS lcl_cls DEFINITION DEFERRED.


DATA: go_main      TYPE REF TO lcl_cls,
      go_grid      TYPE REF TO cl_gui_alv_grid,
      go_container TYPE REF TO cl_gui_custom_container,

      gt_fcat      TYPE lvc_t_fcat,
      gs_layout    TYPE lvc_s_layo,

      gt_alvtable  TYPE TABLE OF zko_egt_s_alv_envlist,
      gs_alvtable  TYPE zko_egt_s_alv_envlist,

      gt_table     TYPE TABLE OF gty_envlis,
      gt_header    TYPE TABLE OF gty_header,
      gs_header    TYPE gty_header,

      gt_type      TYPE truxs_t_text_data,

      gv_file      TYPE string.
