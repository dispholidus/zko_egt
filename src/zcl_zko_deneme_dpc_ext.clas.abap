class ZCL_ZKO_DENEME_DPC_EXT definition
  public
  inheriting from ZCL_ZKO_DENEME_DPC
  create public .

public section.
protected section.

  methods RFIDSET_GET_ENTITY
    redefinition .
  methods RFIDSET_GET_ENTITYSET
    redefinition .
  methods RFIDSET_CREATE_ENTITY
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_ZKO_DENEME_DPC_EXT IMPLEMENTATION.


  METHOD rfidset_create_entity.
    DATA : wa_entity LIKE er_entity,
           wa_post   TYPE zko_t_rfid,
           i_rfid    TYPE TABLE OF zko_t_rfid,
           wa_rfid   TYPE zko_t_rfid.
    io_data_provider->read_entry_data(
     IMPORTING
       es_data = wa_entity
    ).
    IF wa_entity-id IS NOT INITIAL.
      SELECT * FROM zko_t_rfid INTO TABLE i_rfid WHERE id = wa_entity-id.
    ENDIF.
    LOOP AT i_rfid INTO wa_rfid.
      wa_post-id = wa_entity-id.
      wa_post-data = wa_rfid-data.
      MODIFY zko_t_rfid FROM wa_post.
      CLEAR: wa_rfid, wa_post.
    ENDLOOP.
    er_entity = wa_entity.
**TRY.
*CALL METHOD SUPER->RFIDSET_CREATE_ENTITY
*  EXPORTING
*    IV_ENTITY_NAME          =
*    IV_ENTITY_SET_NAME      =
*    IV_SOURCE_NAME          =
*    IT_KEY_TAB              =
**    io_tech_request_context =
*    IT_NAVIGATION_PATH      =
**    io_data_provider        =
**  IMPORTING
**    er_entity               =
*    .
** CATCH /iwbep/cx_mgw_busi_exception .
** CATCH /iwbep/cx_mgw_tech_exception .
**ENDTRY.
  ENDMETHOD.


  METHOD rfidset_get_entity.
    DATA : wa_key TYPE /iwbep/s_mgw_name_value_pair.
    READ TABLE it_key_tab INTO wa_key WITH KEY name = 'ID'.
    IF sy-subrc = 0.
      SELECT SINGLE * FROM zko_t_rfid
        INTO CORRESPONDING FIELDS OF er_entity
        WHERE id = wa_key-value.
    ENDIF.
**TRY.
*CALL METHOD SUPER->RFIDSET_GET_ENTITY
*  EXPORTING
*    IV_ENTITY_NAME          =
*    IV_ENTITY_SET_NAME      =
*    IV_SOURCE_NAME          =
*    IT_KEY_TAB              =
**    io_request_object       =
**    io_tech_request_context =
*    IT_NAVIGATION_PATH      =
**  IMPORTING
**    er_entity               =
**    es_response_context     =
*    .
** CATCH /iwbep/cx_mgw_busi_exception .
** CATCH /iwbep/cx_mgw_tech_exception .
**ENDTRY.
  ENDMETHOD.


  method RFIDSET_GET_ENTITYSET.
    select * from ZKO_T_RFID into CORRESPONDING FIELDS OF TABLE et_entityset.
**TRY.
*CALL METHOD SUPER->RFIDSET_GET_ENTITYSET
*  EXPORTING
*    IV_ENTITY_NAME           =
*    IV_ENTITY_SET_NAME       =
*    IV_SOURCE_NAME           =
*    IT_FILTER_SELECT_OPTIONS =
*    IS_PAGING                =
*    IT_KEY_TAB               =
*    IT_NAVIGATION_PATH       =
*    IT_ORDER                 =
*    IV_FILTER_STRING         =
*    IV_SEARCH_STRING         =
**    io_tech_request_context  =
**  IMPORTING
**    et_entityset             =
**    es_response_context      =
*    .
** CATCH /iwbep/cx_mgw_busi_exception .
** CATCH /iwbep/cx_mgw_tech_exception .
**ENDTRY.
  endmethod.
ENDCLASS.
