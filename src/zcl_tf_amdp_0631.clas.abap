CLASS zcl_tf_amdp_0631 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_amdp_marker_hdb.

    CLASS-METHODS get_planes FOR TABLE FUNCTION zcds_tf_amdp_0631.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_tf_amdp_0631 IMPLEMENTATION.

  METHOD get_planes BY DATABASE FUNCTION FOR HDB
                      LANGUAGE SQLSCRIPT
                      OPTIONS READ-ONLY
                      USING saplane.

    RETURN SELECT mandt,
                  planetype,
                  seatsmax,
                  producer
            FROM saplane
            WHERE mandt = :p_clnt;

  ENDMETHOD.

ENDCLASS.
