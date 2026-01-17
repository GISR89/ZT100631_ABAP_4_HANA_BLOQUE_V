*&---------------------------------------------------------------------*
*& Report z01_sec_hana_0631
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z01_sec_hana_0631.

SELECT * FROM spfli
CONNECTION hanadb
INTO TABLE @DATA(gt_flights).

IF sy-subrc EQ 0.
  cl_demo_output=>display( gt_flights ).
ENDIF.
