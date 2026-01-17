CLASS zcl_airlines_0631 DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES: if_amdp_marker_hdb, if_oo_adt_classrun .

    TYPES: BEGIN OF ty_airports,
             name  TYPE s_airpname,
             tzone TYPE s_tzone,
           END OF ty_airports,
           ty_airports_t TYPE TABLE OF ty_airports.

    CLASS-METHODS get_airports IMPORTING VALUE(iv_mandt)    TYPE mandt
                               EXPORTING VALUE(et_airports) TYPE ty_airports_t.

    CLASS-METHODS call_amdp IMPORTING VALUE(iv_mandt)    TYPE mandt
                            EXPORTING VALUE(et_airports) TYPE ty_airports_t.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_airlines_0631 IMPLEMENTATION.

  METHOD get_airports BY DATABASE PROCEDURE FOR HDB
                      LANGUAGE SQLSCRIPT
                      OPTIONS READ-ONLY
                      USING sairport.

    et_airports = select name,
                           time_zone as tzone
                      from sairport
                      where mandt = :iv_mandt;

  ENDMETHOD.

  METHOD if_oo_adt_classrun~main.
    zcl_airlines_0631=>call_amdp(
      EXPORTING
        iv_mandt    = sy-mandt
      IMPORTING
        et_airports = DATA(lt_airports) ).

    out->write( lt_airports ).
  ENDMETHOD.

  METHOD call_amdp BY DATABASE PROCEDURE FOR HDB
                      LANGUAGE SQLSCRIPT
                      OPTIONS READ-ONLY
                      USING zcl_airlines_0631=>get_airports.

    call "ZCL_AIRLINES_0631=>GET_AIRPORTS"( iv_mandt => :iv_mandt,
                                            et_airports => :et_airports );

  ENDMETHOD.

ENDCLASS.
