*&---------------------------------------------------------------------*
*& Report ZKO_LIB_BOOK_MANAGEMENT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zko_lib_book_management.

INCLUDE: zko_lib_book_management_top,
          zko_lib_book_management_cls,
          zko_lib_book_management_mdl.

START-OF-SELECTION.
  CREATE OBJECT go_main.
  go_main->start_screen( ).

* Kitap Ekle popup ayarla.
