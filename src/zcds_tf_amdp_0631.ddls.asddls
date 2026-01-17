@EndUserText.label: 'Table Functions'
define table function ZCDS_TF_AMDP_0631
  with parameters
    @Environment.systemField: #CLIENT
    p_clnt : abap.clnt
returns
{
  mandt     : abap.clnt;
  planetype : s_planetye;
  seatsmax  : s_seatsmax;
  producer  : s_prod;

}
implemented by method
  ZCL_TF_AMDP_0631=>get_planes;
