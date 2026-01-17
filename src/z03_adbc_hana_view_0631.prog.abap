*&---------------------------------------------------------------------*
*& Report z03_adbc_hana_view_0631
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z03_adbc_hana_view_0631.

** Crear tipo local/global con las columnas
TYPES: BEGIN OF gty_flights,
         carrid    TYPE s_carr_id,
         connid    TYPE s_conn_id,
         fldate    TYPE s_date,
         countryfr TYPE land1,
         cityfrom  TYPE s_from_cit,
         countryto TYPE land1,
         cityto    TYPE s_to_city,
         price     TYPE s_price,
         currency  TYPE s_currcode,
         deptime   TYPE s_dep_time,
         arrtime   TYPE s_arr_time,
       END OF gty_flights.

* ADBC - ABAP Database Connectivity
DATA: go_result    TYPE REF TO cl_sql_result_set,
      gx_sql_excep TYPE REF TO cx_sql_exception,
      gr_data      TYPE REF TO data,
      gt_flights   TYPE STANDARD TABLE OF gty_flights.

PARAMETERS pa_carr TYPE s_carr_id.

START-OF-SELECTION.

  TRY.
* soporta mi base de datos estas operaciones?
      IF NOT cl_abap_dbfeatures=>use_features(
                      EXPORTING
                        connection         = 'HANADB'
                        requested_features = VALUE #( ( cl_abap_dbfeatures=>external_views ) ) ).
        WRITE 'El sistema de base de datos no soporta el procedimiento invocado'.
        RETURN.
      ENDIF.
    CATCH cx_abap_invalid_param_value INTO DATA(gx_invalid_param).
      WRITE gx_invalid_param->get_text(  ).
      RETURN.
  ENDTRY.


  TRY.

** Obtenemos una conexion
** Creamos Statment que luego ejecuta la query

      DATA(go_statement) = NEW cl_sql_statement( con_ref = cl_sql_connection=>get_connection( 'HANADB' ) ).

      DATA(gv_sql) = |SELECT * FROM "_SYS_BIC"."ZABAP_SEC_HANA_TRAINING.ZT1009741/ZT1009741_FLIGHTS" where carrid = '{ pa_carr }'|.

      gr_data = REF #( gt_flights ).

      go_result = go_statement->execute_query( gv_sql ).

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
