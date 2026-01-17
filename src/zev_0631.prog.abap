*&---------------------------------------------------------------------*
*& Report zev_0631
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zev_0631.

SELECT * FROM zev_0631
    INTO TABLE @DATA(gt_flights)
    WHERE countryfr EQ 'US'
         AND countryto EQ 'US'.

IF sy-subrc EQ 0.
  cl_demo_output=>display( gt_flights ).
ENDIF.
