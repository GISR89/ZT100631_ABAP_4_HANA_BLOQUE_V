CLASS zcl_tf_so_0631 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

  INTERFACES if_amdp_marker_hdb.

  CLASS-METHODS get_data FOR TABLE FUNCTION ZTF_SO_0631.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_tf_so_0631 IMPLEMENTATION.
  METHOD get_data BY DATABASE FUNCTION FOR HDB
                     LANGUAGE SQLSCRIPT
                     OPTIONS READ-ONLY
                     USING scustom.

 lt_filters = apply_filter ( scustom, :sel_opt );

    RETURN SELECT so.mandt,
                  so.id,
                  so.name,
                  so.form,
                  so.street,
                  so.postbox,
                  so.postcode,
                  so.city,
                  so.country
    from :lt_filters as so;

  ENDMETHOD.

ENDCLASS.
