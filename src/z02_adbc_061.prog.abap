*&---------------------------------------------------------------------*
*& Report z02_adbc_061
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z02_adbc_061.

** Crear tipo local/global con las columnas

** ADBC - ABAP Database Connectivity
DATA : go_connection TYPE REF TO cl_sql_connection,
       go_statement  TYPE REF TO cl_sql_statement,
       go_result     TYPE REF TO cl_sql_result_set,
       gx_sql_excep  TYPE REF TO cx_sql_exception,
       gv_sql        TYPE string,
       gt_spfli      TYPE STANDARD TABLE OF spfli,
       gr_spfli      TYPE REF TO data.

** soporta mi base de datos estas operaciones?
TRY.
    IF NOT cl_abap_dbfeatures=>use_features( EXPORTING
            connection         = 'HANADB'
            requested_features = VALUE #( ( cl_abap_dbfeatures=>external_views ) ) ). "Soporte de vistas externas

      WRITE 'el sistema no soporta en procedimeinto invocado'.
      RETURN.
    ENDIF.
  CATCH cx_abap_invalid_param_value INTO DATA(gx_invalid_param).
    WRITE gx_invalid_param->get_text(  ).
    RETURN.
ENDTRY.

TRY.
** Obtenemos una conexion
    go_connection = cl_sql_connection=>get_connection( 'HANADB' ).

** Creamos Statment que luego ejecuta la query

    CREATE OBJECT go_statement EXPORTING con_ref = go_connection.

    gv_sql = |SELECT * FROM "_SYS_BIC". "SPFLI" WHERE carrid = 'SQ'|.
    go_result = go_statement->execute_query( gv_sql ).
    GET REFERENCE OF gt_spfli INTO gr_spfli.
    go_result->set_param_table( gr_spfli ).
    go_result->next_package( ).
    go_result->close( ).

  CATCH cx_sql_exception INTO gx_sql_excep.
    WRITE gx_sql_excep->get_text( ).
ENDTRY.


IF NOT gt_spfli IS INITIAL.
  cl_demo_output=>display( gt_spfli ).
ELSE.
  WRITE 'no hay datos'.
ENDIF.
