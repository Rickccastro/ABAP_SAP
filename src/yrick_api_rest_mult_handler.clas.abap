class YRICK_API_REST_MULT_HANDLER definition
  public
  inheriting from CL_REST_HTTP_HANDLER
  final
  create public .

public section.

  methods IF_REST_APPLICATION~GET_ROOT_HANDLER
    redefinition .
protected section.
private section.
ENDCLASS.



CLASS YRICK_API_REST_MULT_HANDLER IMPLEMENTATION.


  method IF_REST_APPLICATION~GET_ROOT_HANDLER.

      DATA(lo_route) =  NEW cl_rest_router( ).

      lo_route->attach( iv_template = `/resource1/get` iv_handler_class = `YRICK_API_ROUTES_RESOURCE_1` ).

      lo_route->attach( iv_template = `/resource2/get_time` iv_handler_class = `YRICK_API_ROUTES_RESOURCE_2` ).

      ro_root_handler = lo_route.


  endmethod.
ENDCLASS.
