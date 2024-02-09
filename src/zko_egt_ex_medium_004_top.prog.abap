*&---------------------------------------------------------------------*
*& Include          ZKO_EGT_EX_MEDIUM_004_TOP
*&---------------------------------------------------------------------*

CLASS lcl_cls DEFINITION DEFERRED.

DATA: go_main      TYPE REF TO lcl_cls,

      gv_randnum   TYPE i,
      gv_guessrnum TYPE i,
      gv_oldguess  TYPE c LENGTH 200.
