class ZCL_API_SALES definition
  public
  inheriting from CL_REST_RESOURCE
  final
  create public .

public section.

  methods GET_CUSTOMERS .
  methods GET_ORDERS .
  methods POST_ORDER .
  methods PUT_ORDER .

  methods IF_REST_RESOURCE~GET
    redefinition .
  methods IF_REST_RESOURCE~POST
    redefinition .
  methods IF_REST_RESOURCE~PUT
    redefinition .
protected section.
private section.
ENDCLASS.



CLASS ZCL_API_SALES IMPLEMENTATION.


  METHOD get_customers.
    DATA(lt_parameters) = mo_request->get_uri_query_parameters( ).

    DATA(lv_filter_id) = VALUE #( lt_parameters[ name = 'id' ] OPTIONAL ).

    DATA(lo_entity) = mo_response->create_entity( ).

    lo_entity->set_string_data( |Selecionando Clientes.| ).


  ENDMETHOD.


  METHOD get_orders.

    DATA(lt_parameters) = mo_request->get_uri_query_parameters( ).

    DATA(lv_filter_id) = VALUE #( lt_parameters[ name = 'id' ] OPTIONAL ).

    " obs crie um range com o valor do id e nao precise tratar quando for initial se não 2x selects...
    IF lv_filter_id IS NOT INITIAL.
      DATA(lv_id) = CONV vbeln( lv_filter_id-value ).
      lv_id = |{ lv_id ALPHA = IN }|.
      DATA(lr_ids) = VALUE rseloption(
        ( sign = 'I' option = 'EQ' low = lv_id ) ).
    ENDIF.

    SELECT * FROM vbak INTO TABLE @DATA(lt_orders)
      WHERE vbeln IN @lr_ids.

    DATA(lo_entity) = mo_response->create_entity( ).

    lo_entity->set_content_type( 'application/json; charset-UTF-8').

    IF LINES( lt_orders ) EQ 1.
      DATA(ls_order) = lt_orders[ 1 ].

      DATA(ls_json_response_line) = /ui2/cl_json=>serialize( data = ls_order ).
      lo_entity->set_string_data( ls_json_response_line ).

    ELSE.
      DATA(ls_json_response_table) = /ui2/cl_json=>serialize( data = lt_orders ).
      lo_entity->set_string_data( ls_json_response_table ).

    ENDIF.
  ENDMETHOD.


  method IF_REST_RESOURCE~GET.

      " Rota ATUAL
      DATA(lv_route) = mo_request->get_uri_path( ).

      lv_route = lv_route+7.

      TRANSLATE lv_route TO UPPER CASE.

      CALL METHOD (lv_route).


  endmethod.


  method IF_REST_RESOURCE~POST.
 " Rota ATUAL
      DATA(lv_route) = mo_request->get_uri_path( ).

      lv_route = lv_route+7.

      TRANSLATE lv_route TO UPPER CASE.

      CALL METHOD (lv_route).
  endmethod.


  method IF_REST_RESOURCE~PUT.
      DATA(lv_route) = mo_request->get_uri_path( ).

      lv_route = lv_route+7.

      TRANSLATE lv_route TO UPPER CASE.

      CALL METHOD (lv_route).
  endmethod.


  method POST_ORDER.
  endmethod.


  method PUT_ORDER.
  endmethod.
ENDCLASS.
