DECLARE
  V_ACL  VARCHAR2(100) := 'cdc.xml';
  V_USER VARCHAR2(100) := 'REPLICACAO';
BEGIN
  DBMS_NETWORK_ACL_ADMIN.ADD_PRIVILEGE(ACL       => V_ACL,
                                       PRINCIPAL => V_USER,
                                       IS_GRANT  => TRUE,
                                       PRIVILEGE => 'connect',
                                       POSITION  => NULL);

  DBMS_NETWORK_ACL_ADMIN.ADD_PRIVILEGE(ACL       => V_ACL,
                                       PRINCIPAL => V_USER,
                                       IS_GRANT  => TRUE,
                                       PRIVILEGE => 'resolve',
                                       POSITION  => NULL);

  DBMS_NETWORK_ACL_ADMIN.ADD_PRIVILEGE(ACL       => V_ACL,
                                       PRINCIPAL => V_USER,
                                       IS_GRANT  => TRUE,
                                       PRIVILEGE => 'http',
                                       POSITION  => NULL);
END;
