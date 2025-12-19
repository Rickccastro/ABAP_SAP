class YCL_HANDLER definition
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



CLASS YCL_HANDLER IMPLEMENTATION.


  METHOD if_rest_application~get_root_handler.

    DATA(lo_router) = NEW cl_rest_router( ).

    SELECT * FROM ydlapit_001 INTO TABLE @DATA(lt_rotas).


    LOOP AT lt_rotas REFERENCE INTO DATA(lrf_rota).

      lo_router->attach(
        iv_template = |{ lrf_rota->classe }|
        iv_handler_class = lrf_rota->classe
      ).

    ENDLOOP.

    ro_root_handler = lo_router.


  ENDMETHOD.
ENDCLASS.
