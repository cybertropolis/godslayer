grant execute on utl_http to schema_name
grant execute on dbms_lock to schema_name



BEGIN
DBMS_NETWORK_ACL_ADMIN.create_acl (
acl => 'scim_api_dev.xml',
description => 'A test of the API DEV - ACL functionality',
principal => 'schema_name',
is_grant => TRUE,
privilege => 'connect',
start_date => SYSTIMESTAMP,
end_date => NULL);
end;

DBMS_NETWORK_ACL_ADMIN.ADD_PRIVILEGE (acl => 'scim_api_dev.xml'
, principal => 'schema_name'
, is_grant => TRUE
, privilege => 'resolve');
begin
DBMS_NETWORK_ACL_ADMIN.assign_acl (
acl => 'scim_api_dev.xml',
host => ' https://hs-identity-api.example.com/scim/v1/dev/Users',
lower_port => 1,
upper_port => 50000);
end;
commit;



UTL_HTTP.SET_PROXY('webproxy.mycompany.com:8080','');

declare
req UTL_HTTP.REQ;
resp UTL_HTTP.RESP;
val VARCHAR2(2000);
str varchar2(1000);
begin
UTL_HTTP.SET_PROXY('webproxy.mycompany.com:8080','');
req := UTL_HTTP.BEGIN_REQUEST(' https://hs-identity-api.company.com/' );
resp := UTL_HTTP.GET_RESPONSE(req);
LOOP
UTL_HTTP.READ_LINE(resp, val, TRUE);
DBMS_OUTPUT.PUT_LINE(val);
END LOOP;
UTL_HTTP.END_RESPONSE(resp);
EXCEPTION
WHEN UTL_HTTP.END_OF_BODY
THEN
UTL_HTTP.END_RESPONSE(resp);
END;
