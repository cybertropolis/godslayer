BEGIN
  DBMS_NETWORK_ACL_ADMIN.CREATE_ACL(ACL         => 'cdc.xml', -- or any other name
                                    DESCRIPTION => 'Habilita funcionalidade ACL para o CDC',
                                    PRINCIPAL   => 'REPLICACAO',
                                    IS_GRANT    => TRUE,
                                    PRIVILEGE   => 'connect',
                                    START_DATE  => SYSTIMESTAMP,
                                    END_DATE    => NULL);
END;

BEGIN
  DBMS_NETWORK_ACL_ADMIN.ASSIGN_ACL(ACL        => 'cdc.xml', -- or any other name
                                    HOST       => '10.0.17.221',
                                    LOWER_PORT => 9002,
                                    UPPER_PORT => NULL);
END;

-- NEW

BEGIN
  DBMS_NETWORK_ACL_ADMIN.append_host_ace(host       => '10.0.17.221',
                                         lower_port => 80,
                                         upper_port => 80,
                                         ace        => xs$ace_type(privilege_list => xs$name_list('http'),
                                                                   principal_name => 'SIS_REPLICACAO',
                                                                   principal_type => xs_acl.ptype_db));
END;

BEGIN
  DBMS_NETWORK_ACL_ADMIN.CREATE_ACL(ACL         => 'http_permissions.xml', -- or any other name
                                    DESCRIPTION => 'HTTP Access',
                                    PRINCIPAL   => 'DELTA', -- the user name trying to access the network resource
                                    IS_GRANT    => TRUE,
                                    PRIVILEGE   => 'connect',
                                    START_DATE  => null,
                                    END_DATE    => null);
END;

-- to check user permissions
-- SELECT A.*, A.ROWID FROM DBA_NETWORK_ACLS A;
-- SELECT A.* FROM DBA_NETWORK_ACL_PRIVILEGES A WHERE PRINCIPAL = 'SIS_REPLICACAO' OR PRINCIPAL = 'DELTA';

BEGIN
  DBMS_NETWORK_ACL_ADMIN.ADD_PRIVILEGE(acl       => 'cdc.xml',
                                       principal => 'DELTA',
                                       is_grant  => true,
                                       privilege => 'resolve');
END;

BEGIN
  DBMS_NETWORK_ACL_ADMIN.ADD_PRIVILEGE(acl       => 'cdc.xml',
                                       principal => 'SIS_REPLICACAO',
                                       is_grant  => true,
                                       privilege => 'resolve');
END;

BEGIN
  DBMS_NETWORK_ACL_ADMIN.ADD_PRIVILEGE(acl       => 'cdc.xml',
                                       principal => 'REPLICACAO',
                                       is_grant  => true,
                                       privilege => 'resolve');
END;

BEGIN
  dbms_network_acl_admin.assign_acl(acl        => 'cdc.xml',
                                    host       => '*', /*can be computer name or IP , wildcards are accepted as well for example - '*.us.oracle.com'*/
                                    lower_port => 1,
                                    upper_port => 9999);

END;
