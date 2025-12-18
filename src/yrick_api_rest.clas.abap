class YRICK_API_REST definition
  public
  final
  create public .

public section.

  interfaces IF_HTTP_EXTENSION .
protected section.
private section.
ENDCLASS.



CLASS YRICK_API_REST IMPLEMENTATION.


  method IF_HTTP_EXTENSION~HANDLE_REQUEST.

    DATA(v_type_crud) = server->request->get_header_field( name = `~request_method` ).

    CASE v_type_crud.
      WHEN 'GET'.
        SELECT * UP TO 10 ROWS FROM MARA INTO TABLE @DATA(lt_mara).

          DATA(ls_json_response) = /ui2/cl_json=>serialize( EXPORTING data = lt_mara ).

          server->response->set_cdata( data = ls_json_response ).
      WHEN OTHERS.
    ENDCASE.


  endmethod.
ENDCLASS.
