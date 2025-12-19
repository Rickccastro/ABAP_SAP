class YRICK_API_ROUTES_RESOURCE_1 definition
  public
  inheriting from CL_REST_RESOURCE
  final
  create public .

public section.

  methods IF_REST_RESOURCE~GET
    redefinition .
protected section.
private section.
ENDCLASS.



CLASS YRICK_API_ROUTES_RESOURCE_1 IMPLEMENTATION.


  method IF_REST_RESOURCE~GET.
       DATA(lo_entity) = mo_response->create_entity( ).

       lo_entity->set_string_data( |\{ "hora": "{ sy-uzeit TIME = USER }" \}| ).

       lo_entity->set_content_type( 'application/json; charset=UTF-8' ) .

  endmethod.
ENDCLASS.
