*&---------------------------------------------------------------------*
*& Report ZKO_EGT_EX_MEDIUM_006
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zko_egt_ex_adv_003.
* zkottlbak title bakım
* zkodepbak departman bakım
INCLUDE : zko_egt_ex_adv_003_top,
          zko_egt_ex_adv_003_cls,
          zko_egt_ex_adv_003_mdl.

AT SELECTION-SCREEN OUTPUT.
  IF rb_lstl EQ 'X'.
    LOOP AT SCREEN.
      IF screen-group1 EQ 'GSO'.
        screen-active = 1.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
  ELSE.
    LOOP AT SCREEN.
      IF screen-group1 EQ 'GSO'.
        screen-active = 0.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
  ENDIF.

START-OF-SELECTION.
  CREATE OBJECT go_main_0100.
  CREATE OBJECT go_main_0200.

  CASE 'X'.
    WHEN rb_yeni.
      go_main_0100->start_screen( ).
    WHEN rb_lstl.
      go_main_0200->start_screen( ).
  ENDCASE.
