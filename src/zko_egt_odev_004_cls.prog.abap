*&---------------------------------------------------------------------*
*& Include          ZKO_EGT_ODEV_004_CLS
*&---------------------------------------------------------------------*
CLASS lcl_cls DEFINITION.
  PUBLIC SECTION.
    METHODS: start_screen,
      pbo_0100,
      pai_0100 IMPORTING iv_ucomm TYPE sy-ucomm,

      pbo_0200,
      pai_0200 IMPORTING iv_ucomm TYPE sy-ucomm,

      get_random_numbers,
      generate_prime EXPORTING ev_flag TYPE i,
      get_inputs,
      display_winner_numbers,
      get_lucky_count EXPORTING ev_luckycount TYPE i,
      check_money,
      check_prize.
ENDCLASS.
CLASS lcl_cls IMPLEMENTATION.

  METHOD start_screen.
    CALL SCREEN 0100.
  ENDMETHOD.
  METHOD pbo_0100.
    SET PF-STATUS 'STATUS_0100'.
    go_main->check_money( ).
  ENDMETHOD.
  METHOD pai_0100.
    CASE iv_ucomm.
      WHEN '&BACK'.
        SET SCREEN 0.
      WHEN '&CEK'.

        go_main->get_random_numbers( ).
        go_main->get_inputs( ).

        go_main->check_prize( ).
        go_main->check_money( ).
      WHEN '&PARAYUK'.
        IF gv_eklenecekpara GT 0.
          CALL SCREEN 0200 STARTING AT 10 10.
        ELSE.
          MESSAGE 'Geçerli bir para miktarı giriniz!' TYPE 'I'.
        ENDIF.
    ENDCASE.
  ENDMETHOD.
  METHOD pbo_0200.
    SET PF-STATUS 'STATUS_0200'.
  ENDMETHOD.
  METHOD pai_0200.
    CASE iv_ucomm.
      WHEN '&BACK'.
        SET SCREEN 0.
      WHEN '&EXEC'.
        IF gv_kartno IS NOT INITIAL AND gv_kartccv IS NOT INITIAL.
          ASSIGN gv_parac TO <gfs_parac>.
          gv_para = gv_para + gv_eklenecekpara.
          <gfs_parac> = gv_para && | | && 'TL'.
          SET SCREEN 0.
        ENDIF.
    ENDCASE.
  ENDMETHOD.

  METHOD get_random_numbers.
    CLEAR gt_winner.
    DATA lv_randnum TYPE zko_egt_de_sayi VALUE 1.
    DATA(lv_flag) = 0.
    WHILE lv_flag = 0.

      go_main->generate_prime(
        IMPORTING
          ev_flag = lv_flag
      ).
    ENDWHILE.
    APPEND lv_flag TO gt_winner.
    CALL FUNCTION 'QF05_RANDOM_INTEGER'
      EXPORTING
        ran_int_max = 24
        ran_int_min = 1
      IMPORTING
        ran_int     = lv_randnum.
    lv_randnum = lv_randnum * 2.

    APPEND lv_randnum TO gt_winner.
    CALL FUNCTION 'QF05_RANDOM_INTEGER'
      EXPORTING
        ran_int_max = 24
        ran_int_min = 0
      IMPORTING
        ran_int     = lv_randnum.

    lv_randnum = lv_randnum * 2 + 1.
    APPEND lv_randnum TO gt_winner.

    DO 3 TIMES.
      lv_randnum = 1.
      CALL FUNCTION 'QF05_RANDOM_INTEGER'
        EXPORTING
          ran_int_max = 49
          ran_int_min = 1
        IMPORTING
          ran_int     = lv_randnum.

      APPEND lv_randnum TO gt_winner.
    ENDDO.
    SORT gt_winner ASCENDING BY table_line.
    DELETE ADJACENT DUPLICATES FROM gt_winner.
    DATA(lv_counter) = 0.
    LOOP AT gt_winner INTO DATA(gs_winner).
      lv_counter = lv_counter + 1.
    ENDLOOP.
    IF lv_counter LT 6.
      go_main->get_random_numbers( ).
    ENDIF.
  ENDMETHOD.

  METHOD generate_prime.
    DATA(lv_rand_num) = cl_abap_random_int=>create( EXPORTING seed = CONV i( sy-uzeit ) min = 1 max = 49 ).
    DATA lv_randnum TYPE zko_egt_de_sayi.
    CALL FUNCTION 'QF05_RANDOM_INTEGER'
      EXPORTING
        ran_int_max = 49
        ran_int_min = 1
      IMPORTING
        ran_int     = lv_randnum.

    DATA(lv_counter) = 2.
    ev_flag = lv_randnum.
    WHILE lv_counter LT lv_randnum / 2.
      IF lv_randnum MOD ( lv_counter ) EQ 0.
        ev_flag = 0.
        EXIT.
      ENDIF.
      lv_counter = lv_counter + 1.
    ENDWHILE.
    IF ev_flag NE 0.
      ev_flag = lv_randnum.
    ENDIF.

  ENDMETHOD.
  METHOD get_inputs.
    CLEAR gt_guess.

    DATA(lv_flag) = 0.
    APPEND gv_guess1 TO gt_guess.
    APPEND gv_guess2 TO gt_guess.
    APPEND gv_guess3 TO gt_guess.
    APPEND gv_guess4 TO gt_guess.
    APPEND gv_guess5 TO gt_guess.
    APPEND gv_guess6 TO gt_guess.

    SORT gt_guess ASCENDING BY table_line.
    DELETE ADJACENT DUPLICATES FROM gt_guess.
    DATA(lv_counter) = 0.
    LOOP AT gt_guess INTO DATA(gs_guess).
      IF gs_guess GE 1 AND gs_guess LE 49.
        lv_counter = lv_counter + 1.
      ENDIF.
    ENDLOOP.
    IF lv_counter LT 6.
      MESSAGE 'Aynı veya 1-49 aralığı dışındaki sayılar girilmez.' TYPE 'I' DISPLAY LIKE 'W'.
      CLEAR: gv_guess1,
             gv_guess2,
             gv_guess3,
             gv_guess4,
             gv_guess5,
             gv_guess6.
      EXIT.
    ENDIF.
    LOOP AT gt_guess INTO DATA(ls_guess).
      IF sy-tabix GT 1 AND sy-tabix LT 6.
        DATA(lv_previndex) = sy-tabix - 1.
        DATA(lv_nextindex) = sy-tabix + 1.
        READ TABLE gt_guess INTO DATA(ls_prevguess) INDEX lv_previndex.
        READ TABLE gt_guess INTO DATA(ls_nextguess) INDEX lv_nextindex.
        IF ls_nextguess - ls_guess EQ 1 AND ls_guess - ls_prevguess EQ 1.
          lv_flag = 1.
          EXIT.
        ENDIF.
      ENDIF.
    ENDLOOP.

    IF lv_flag EQ 1.
      MESSAGE 'Ard arda 3 sayı girilemez!' TYPE 'I' DISPLAY LIKE 'W'.
      CLEAR: gv_guess1,
             gv_guess2,
             gv_guess3,
             gv_guess4,
             gv_guess5,
             gv_guess6.
      EXIT.
    ENDIF.
    go_main->display_winner_numbers( ).
  ENDMETHOD.
  METHOD display_winner_numbers.
    LOOP AT gt_winner INTO DATA(gs_winner).
      IF sy-tabix EQ 1.
        gv_winner1 = gs_winner.
        CONTINUE.
      ENDIF.
      IF sy-tabix EQ 2.
        gv_winner2 = gs_winner.
        CONTINUE.
      ENDIF.
      IF sy-tabix EQ 3.
        gv_winner3 = gs_winner.
        CONTINUE.
      ENDIF.
      IF sy-tabix EQ 4.
        gv_winner4 = gs_winner.
        CONTINUE.
      ENDIF.
      IF sy-tabix EQ 5.
        gv_winner5 = gs_winner.
        CONTINUE.
      ENDIF.
      IF sy-tabix EQ 6.
        gv_winner6 = gs_winner.
        CONTINUE.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.
  METHOD get_lucky_count.
    LOOP AT gt_guess INTO DATA(ls_guess).
      READ TABLE gt_winner INTO DATA(ls_winner) WITH KEY table_line = ls_guess.
      IF sy-subrc EQ 0.
        ev_luckycount = ev_luckycount + 1.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.
  METHOD check_money.
    IF gv_para LT 50.
      LOOP AT SCREEN.
        IF screen-name EQ '%#AUTOTEXT005'.
          screen-invisible = 1.
          MODIFY SCREEN.
        ENDIF.
      ENDLOOP.
    ENDIF.
    IF gv_para GE 50.
      LOOP AT SCREEN.
        IF screen-name EQ '%#AUTOTEXT005'.
          screen-invisible = 0.
          MODIFY SCREEN.
        ENDIF.
      ENDLOOP.
    ENDIF.
  ENDMETHOD.
  METHOD check_prize.

    DATA(lv_luckycount) = 0.
    DATA ls_odul TYPE zko_egt_t_odul.

    ASSIGN gv_parac TO <gfs_parac>.

    go_main->get_lucky_count(
          IMPORTING
            ev_luckycount = lv_luckycount
        ).

    IF lv_luckycount LE 1.
      gv_para = gv_para - 50.
      <gfs_parac> = gv_para && | | && 'TL'.
    ELSEIF lv_luckycount EQ 2.
      SELECT SINGLE * FROM zko_egt_t_odul INTO @ls_odul WHERE sayi EQ @lv_luckycount.
      gv_para = gv_para + ls_odul-odul.
      <gfs_parac> = gv_para && | | && 'TL'.
    ELSEIF lv_luckycount EQ 3.
      SELECT SINGLE * FROM zko_egt_t_odul INTO @ls_odul WHERE sayi EQ @lv_luckycount.
      gv_para = gv_para + ls_odul-odul.
      <gfs_parac> = gv_para && | | && 'TL'.
    ELSEIF lv_luckycount EQ 4.
      SELECT SINGLE * FROM zko_egt_t_odul INTO @ls_odul WHERE sayi EQ @lv_luckycount.
      gv_para = gv_para + ls_odul-odul.
      <gfs_parac> = gv_para && | | && 'TL'.
    ELSEIF lv_luckycount EQ 5.
      SELECT SINGLE * FROM zko_egt_t_odul INTO @ls_odul WHERE sayi EQ @lv_luckycount.
      gv_para = gv_para + ls_odul-odul.
      <gfs_parac> = gv_para && | | && 'TL'.
    ELSEIF lv_luckycount EQ 6.
      SELECT SINGLE * FROM zko_egt_t_odul INTO @ls_odul WHERE sayi EQ @lv_luckycount.
      gv_para = gv_para + ls_odul-odul.
      <gfs_parac> = gv_para && | | && 'TL'.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
