*&---------------------------------------------------------------------*
*& Report z04_adbc_proced_0631
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z04_adbc_proced_0631.

** Crear tipo local/global con las columnas
TYPES: BEGIN OF gty_overview,
         param TYPE string,
         value TYPE string,
       END OF gty_overview.

TYPES: BEGIN OF gty_flights,
         carrid   TYPE s_carr_id,
         connid   TYPE s_conn_id,
         fldate   TYPE s_date,
         price    TYPE s_price,
         cityfrom TYPE s_from_cit,
         cityto   TYPE s_to_city,
       END OF gty_flights.

* ADBC - ABAP Database Connectivity
DATA: gv_sql      TYPE string,
      gt_overview TYPE STANDARD TABLE OF gty_overview,
      gt_flights  TYPE STANDARD TABLE OF gty_flights.

DATA: go_result    TYPE REF TO cl_sql_result_set,
      gx_sql_excep TYPE REF TO cx_sql_exception,
      gr_data      TYPE REF TO data.

paramETERS: p_c_from type land1,
            p_c_to   type land1.

start-OF-SELECTION.

TRY.
* soporta mi base de datos estas operaciones?
    IF NOT cl_abap_dbfeatures=>use_features(
                    EXPORTING
                      connection         = 'HANADB'
                      requested_features = VALUE #( ( cl_abap_dbfeatures=>call_database_procedure ) ) ).
      WRITE 'El sistema de base de datos no soporta el procedimiento invocado'.
      RETURN.
    ENDIF.
  CATCH cx_abap_invalid_param_value INTO DATA(gx_invalid_param).
    WRITE gx_invalid_param->get_text(  ).
    RETURN.
ENDTRY.

try.
** Obtenemos una conexion
** Creamos Statment que luego ejecuta la query

      DATA(go_statement) = NEW cl_sql_statement( con_ref = cl_sql_connection=>get_connection( 'HANADB' ) ).

      gv_sql = |call "_SYS_BIC"."ZABAP_SEC_HANA_TRAINING.ZMH2509::sp_mh2509_flights"('{ sy-mandt }','{ p_c_from }','{ p_c_to }',NULL) with overview|.

      go_result = go_statement->execute_query( gv_sql ).

      gr_data = REF #( gt_overview ).

      go_result->set_param_table( gr_data ).

      go_result->next_package(  ).

      gv_sql = |select * from { gt_overview[ param = 'ET_FLIGHTS' ]-value }|.

      go_result = go_statement->execute_query( gv_sql ).

      gr_data = REF #( gt_flights ).

      go_result->set_param_table( gr_data ).

      go_result->next_package(  ).

      go_result->close( ).

    CATCH cx_sql_exception INTO gx_sql_excep.
      WRITE gx_sql_excep->get_text(  ).
      RETURN.
  ENDTRY.

  IF NOT gt_flights IS INITIAL.
    cl_demo_output=>display( gt_flights ).
  ELSE.
    WRITE 'no data'.
  ENDIF.
