@EndUserText.label: 'Table Functions - Select Options'
define table function ZTF_SO_0631
  with parameters
    @Environment.systemField: #CLIENT
    p_clnt  : abap.clnt,
    sel_opt : abap.char(1000)
returns
{
  mandt    : abap.clnt;
  id       : s_customer;
  name     : s_custname;
  form     : s_form;
  street   : s_street;
  postbox  : s_postbox;
  postcode : postcode;
  city     : city;
  country  : s_country;


}
implemented by method
  ZCL_TF_SO_0631=>get_data;
