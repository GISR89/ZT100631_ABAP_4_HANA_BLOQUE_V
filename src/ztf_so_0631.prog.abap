*&---------------------------------------------------------------------*
*& Report ztf_so_0631
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ztf_so_0631.

DATA: gs_data    TYPE scustom,
      gv_sel_opt TYPE string.

SELECT-OPTIONS: so_sel FOR gs_data-country.

START-OF-SELECTION.

  TRY.

      gv_sel_opt = cl_shdb_seltab=>combine_seltabs(
          EXPORTING it_named_seltabs = VALUE #( ( name = 'COUNTRY' dref = REF #( so_sel[] ) ) )
                    iv_client_field  = 'MANDT' ).

    CATCH cx_shdb_exception INTO DATA(lx_error).

      WRITE: lx_error->get_text(  ).

  ENDTRY.

  SELECT *
  FROM ztf_so_0631( sel_opt = @gv_sel_opt )
  INTO TABLE @DATA(gt_results).

  IF gt_results IS NOT INITIAL.
    cl_demo_output=>display( gt_results ).
  ENDIF.
