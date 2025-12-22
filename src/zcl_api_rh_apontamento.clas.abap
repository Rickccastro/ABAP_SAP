class ZCL_API_RH_APONTAMENTO definition
  public
  inheriting from CL_REST_RESOURCE
  final
  create public .

public section.

  methods GET_RELATORIO .
  methods GET_FUNCIONARIOS .
  methods POST_FUNCIONARIO .
  methods PUT_FUNCIONARIO .
  methods DELETE_FUNCIONARIO .
  methods POST_APONTAMENTO .
  methods GET_APONTAMENTO .
  methods PUT_APONTAMENTO .

  methods IF_REST_RESOURCE~DELETE
    redefinition .
  methods IF_REST_RESOURCE~GET
    redefinition .
  methods IF_REST_RESOURCE~POST
    redefinition .
  methods IF_REST_RESOURCE~PUT
    redefinition .
protected section.
private section.
ENDCLASS.



CLASS ZCL_API_RH_APONTAMENTO IMPLEMENTATION.


  method DELETE_FUNCIONARIO.

    DATA(lo_entity) = mo_response->create_entity( ).
    lo_entity->set_content_type( 'application/json; charset-UTF-8').
    DATA(lt_parameters) = mo_request->get_uri_query_parameters( ).

    DATA(ls_func) = VALUE #( lt_parameters[ name = 'id' ] OPTIONAL ).

    DELETE FROM ZRH_TB_EMPREGADO WHERE ID = ls_func-value.

    IF sy-subrc EQ 0 .
      DATA(ls_json_response_table) = /ui2/cl_json=>serialize( `{ "msg": "Sucesso ao apagar o registro"}` ).
      lo_entity->set_string_data( ls_json_response_table ).
    ELSE.
      lo_entity->set_string_data( `ERRO` ).

    ENDIF.

  endmethod.


  METHOD GET_APONTAMENTO.
    DATA(lt_parameters) = mo_request->get_uri_query_parameters( ).

    DATA(lv_filter_id) = VALUE #( lt_parameters[ name = 'id' ] OPTIONAL ).

    " obs crie um range com o valor do id e nao precise tratar quando for initial se não 2x selects...
    IF lv_filter_id IS NOT INITIAL.
      DATA(lv_id) = CONV vbeln( lv_filter_id-value ).
      lv_id = |{ lv_id ALPHA = IN }|.
      DATA(lr_ids) = VALUE rseloption(
        ( sign = 'I' option = 'EQ' low = lv_id ) ).
    ENDIF.

    SELECT * FROM zrh_tb_horas INTO TABLE @DATA(lt_aponta)
      WHERE id IN @lr_ids.

    DATA(lo_entity) = mo_response->create_entity( ).

    lo_entity->set_content_type( 'application/json; charset-UTF-8').

    IF LINES( lt_aponta ) EQ 1.
      DATA(ls_aponta) = lt_aponta[ 1 ].

      DATA(ls_json_response_line) = /ui2/cl_json=>serialize( data = ls_aponta ).
      lo_entity->set_string_data( ls_json_response_line ).

    ELSE.
      DATA(ls_json_response_table) = /ui2/cl_json=>serialize( data = lt_aponta ).
      lo_entity->set_string_data( ls_json_response_table ).

    ENDIF.
  ENDMETHOD.


  METHOD GET_FUNCIONARIOS.

  DATA(lt_parameters) = mo_request->get_uri_query_parameters( ).

    DATA(lv_filter_id) = VALUE #( lt_parameters[ name = 'id' ] OPTIONAL ).

    " obs crie um range com o valor do id e nao precise tratar quando for initial se não 2x selects...
    IF lv_filter_id IS NOT INITIAL.
      DATA(lv_id) = CONV vbeln( lv_filter_id-value ).
      lv_id = |{ lv_id ALPHA = IN }|.
      DATA(lr_ids) = VALUE rseloption(
        ( sign = 'I' option = 'EQ' low = lv_id ) ).
    ENDIF.

    SELECT * FROM ZRH_TB_EMPREGADO INTO TABLE @DATA(lt_func)
      WHERE ID IN @lr_ids.

    DATA(lo_entity) = mo_response->create_entity( ).

    lo_entity->set_content_type( 'application/json; charset-UTF-8').

    IF lines( lt_func ) EQ 1.
      DATA(ls_func) = lt_func[ 1 ].

      DATA(ls_json_response_line) = /ui2/cl_json=>serialize( data = ls_func ).
      lo_entity->set_string_data( ls_json_response_line ).

    ELSE.
      DATA(ls_json_response_table) = /ui2/cl_json=>serialize( data = lt_func ).
      lo_entity->set_string_data( ls_json_response_table ).

    ENDIF.

  ENDMETHOD.


  METHOD get_relatorio.
    DATA: lt_relatorio TYPE TABLE OF zc_rh_apontamentos.
    SELECT *  FROM zc_rh_apontamentos INTO CORRESPONDING FIELDS OF TABLE @lt_relatorio.

    DATA(lo_entity) = mo_response->create_entity( ).

    lo_entity->set_content_type( 'application/json; charset-UTF-8').

    DATA(ls_json_response_table) = /ui2/cl_json=>serialize( data = lt_relatorio ).
    lo_entity->set_string_data( ls_json_response_table ).
  ENDMETHOD.


  method IF_REST_RESOURCE~DELETE.
    " Rota ATUAL
    DATA(lv_route) = mo_request->get_uri_path( ).

    lv_route = lv_route+6.

    TRANSLATE lv_route TO UPPER CASE.

    IF lv_route NS 'DELETE'.
      DATA(lo_entity) = mo_response->create_entity( ).
      lo_entity->set_string_data( '{"msg": "Rota Necessita ser DELETE!" }').
      lo_entity->set_content_type( 'application/json; charset-UTF-8').
      RETURN.
    ENDIF.

    CALL METHOD (lv_route).
  endmethod.


  METHOD if_rest_resource~get.

    " Rota ATUAL
    DATA(lv_route) = mo_request->get_uri_path( ).

    lv_route = lv_route+6.

    TRANSLATE lv_route TO UPPER CASE.

    IF lv_route NS 'GET'.
      DATA(lo_entity) = mo_response->create_entity( ).
      lo_entity->set_string_data( '{"msg": "Rota Necessita ser GET!" }').
      lo_entity->set_content_type( 'application/json; charset-UTF-8').
      RETURN.
    ENDIF.

    CALL METHOD (lv_route).


  ENDMETHOD.


  METHOD IF_REST_RESOURCE~POST.
    " Rota ATUAL
    DATA(lv_route) = mo_request->get_uri_path( ).

    lv_route = lv_route+6.

    TRANSLATE lv_route TO UPPER CASE.

    IF lv_route NS 'POST'.
      DATA(lo_entity) = mo_response->create_entity( ).
      lo_entity->set_string_data( '{"msg": "Rota Necessita ser POST!" }').
      lo_entity->set_content_type( 'application/json; charset-UTF-8').
      RETURN.

    ENDIF.

    CALL METHOD (lv_route).
  ENDMETHOD.


  METHOD IF_REST_RESOURCE~PUT.
    DATA(lv_route) = mo_request->get_uri_path( ).

    lv_route = lv_route+6.

    TRANSLATE lv_route TO UPPER CASE.

    IF lv_route NS 'PUT'.
      DATA(lo_entity) = mo_response->create_entity( ).
      lo_entity->set_string_data( '{"msg": "Rota Necessita ser PUT!" }').
      lo_entity->set_content_type( 'application/json; charset-UTF-8').

      RETURN.
    ENDIF.

    CALL METHOD (lv_route).
  ENDMETHOD.


  method POST_APONTAMENTO.
    DATA: ls_request TYPE zrh_tb_horas.

    DATA(ls_request_body) = mo_request->get_entity( )->get_string_data( ).
    /ui2/cl_json=>deserialize( EXPORTING json = ls_request_body
                               CHANGING data  = ls_request ).

    INSERT zrh_tb_horas FROM ls_request.

    DATA(lo_entity) = mo_response->create_entity( ).
    lo_entity->set_content_type( 'application/json; charset-UTF-8').

    IF sy-subrc EQ 0 .
      DATA(ls_json_response_table) = /ui2/cl_json=>serialize( data = ls_request ).
      lo_entity->set_string_data( ls_json_response_table ).
    ELSE.
      lo_entity->set_string_data( `ERRO` ).

    ENDIF.
  endmethod.


  METHOD POST_FUNCIONARIO.
    DATA: ls_request TYPE ZRH_TB_EMPREGADO.

    DATA(ls_request_body) = mo_request->get_entity( )->get_string_data( ).
    /ui2/cl_json=>deserialize( EXPORTING json = ls_request_body
                               CHANGING data  = ls_request ).

    INSERT ZRH_TB_EMPREGADO FROM ls_request.

    DATA(lo_entity) = mo_response->create_entity( ).
    lo_entity->set_content_type( 'application/json; charset-UTF-8').

    IF sy-subrc EQ 0 .
      DATA(ls_json_response_table) = /ui2/cl_json=>serialize( data = ls_request ).
      lo_entity->set_string_data( ls_json_response_table ).
    ELSE.
      lo_entity->set_string_data( `ERRO` ).

    ENDIF.

  ENDMETHOD.


  METHOD put_apontamento.
    DATA: ls_request TYPE zrh_tb_horas.

    DATA(lt_parameters) = mo_request->get_uri_query_parameters( ).

    DATA(ls_aponta) = VALUE #( lt_parameters[ name = 'id' ] OPTIONAL ).

    DATA(lo_entity) = mo_response->create_entity( ).
    lo_entity->set_content_type( 'application/json; charset-UTF-8').


    DATA(ls_request_body) = mo_request->get_entity( )->get_string_data( ).
    /ui2/cl_json=>deserialize( EXPORTING json = ls_request_body
                               CHANGING data  = ls_request ).

    ls_request-id    = ls_aponta-value.

    UPDATE zrh_tb_horas FROM ls_request.

    IF sy-subrc EQ 0 .
      DATA(ls_json_response_table) = /ui2/cl_json=>serialize( data = ls_request-id ).
      lo_entity->set_string_data( ls_json_response_table ).
    ELSE.
      lo_entity->set_string_data( `ERRO` ).

    ENDIF.
  ENDMETHOD.


  METHOD PUT_FUNCIONARIO.
    DATA: ls_request TYPE ZRH_TB_EMPREGADO.

    DATA(lt_parameters) = mo_request->get_uri_query_parameters( ).

    DATA(ls_func) = VALUE #( lt_parameters[ name = 'id' ] OPTIONAL ).

    DATA(lo_entity) = mo_response->create_entity( ).
    lo_entity->set_content_type( 'application/json; charset-UTF-8').


    DATA(ls_request_body) = mo_request->get_entity( )->get_string_data( ).
    /ui2/cl_json=>deserialize( EXPORTING json = ls_request_body
                               CHANGING data  = ls_request ).

    ls_request-id    = ls_func-value.

    UPDATE ZRH_TB_EMPREGADO FROM ls_request.

    IF sy-subrc EQ 0 .
      DATA(ls_json_response_table) = /ui2/cl_json=>serialize( data = ls_request-id ).
      lo_entity->set_string_data( ls_json_response_table ).
    ELSE.
      lo_entity->set_string_data( `ERRO` ).

    ENDIF.
  ENDMETHOD.
ENDCLASS.
