*&---------------------------------------------------------------------*
*& Report z_airlines_0631
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_airlines_0631.

zcl_airlines_0631=>get_airports(
  EXPORTING
    iv_mandt    = SY-mandt
  IMPORTING
    et_airports = data(gt_airports) ).

check not gt_airports is initiAL.

cl_demo_output=>display( gt_airports ).
