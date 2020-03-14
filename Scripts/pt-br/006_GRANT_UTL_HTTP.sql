-- *********************************************

DECLARE
  V_ACL  VARCHAR2(100) := 'cdc.xml';
  V_USER VARCHAR2(100) := 'SIS_REPLICACAO';
BEGIN
  DBMS_NETWORK_ACL_ADMIN.CREATE_ACL(ACL         => V_ACL,
                                    DESCRIPTION => 'Permissões para Replicação',
                                    PRINCIPAL   => V_USER,
                                    IS_GRANT    => TRUE,
                                    PRIVILEGE   => 'connect');

END;

-- *********************************************

DECLARE
  V_ACL  VARCHAR2(100) := 'cdc.xml';
  V_USER VARCHAR2(100) := 'SIS_REPLICACAO';
BEGIN
  DBMS_NETWORK_ACL_ADMIN.ADD_PRIVILEGE(ACL       => V_ACL,
                                       PRINCIPAL => V_USER,
                                       IS_GRANT  => TRUE,
                                       PRIVILEGE => 'connect',
                                       POSITION  => NULL);
END;

DECLARE
  V_ACL  VARCHAR2(100) := 'cdc.xml';
  V_USER VARCHAR2(100) := 'SIS_REPLICACAO';
BEGIN
  DBMS_NETWORK_ACL_ADMIN.ADD_PRIVILEGE(ACL       => V_ACL,
                                       PRINCIPAL => V_USER,
                                       IS_GRANT  => TRUE,
                                       PRIVILEGE => 'resolve',
                                       POSITION  => NULL);
END;

-- *********************************************

DECLARE
  V_ACL VARCHAR2(100) := 'cdc.xml';
BEGIN
  DBMS_NETWORK_ACL_ADMIN.ASSIGN_ACL(ACL => V_ACL, HOST => '*');
END;

-- *********************************************

SELECT host,
       lower_port,
       upper_port,
       acl,
       DECODE(DBMS_NETWORK_ACL_ADMIN.CHECK_PRIVILEGE_ACLID(aclid,
                                                           'SIS_REPLICACAO',
                                                           'connect'),
              1,
              'GRANTED',
              0,
              'DENIED',
              null) privilege
  FROM dba_network_acls
 WHERE host IN (SELECT * FROM TABLE(DBMS_NETWORK_ACL_UTILITY.DOMAINS('*')));

-- *********************************************

SELECT host,
       acl,
       DECODE(DBMS_NETWORK_ACL_ADMIN.CHECK_PRIVILEGE_ACLID(aclid,
                                                           'SIS_REPLICACAO',
                                                           'resolve'),
              1,
              'GRANTED',
              0,
              'DENIED',
              NULL) privilege
  FROM dba_network_acls
 WHERE host IN (SELECT * FROM TABLE(DBMS_NETWORK_ACL_UTILITY.DOMAINS('*')))
   and lower_port IS NULL
   AND upper_port IS NULL;

-- *********************************************

BEGIN
  DBMS_NETWORK_ACL_ADMIN.delete_privilege(acl       => 'cdc.xml',
                                          principal => 'SIS_REPLICACAO',
                                          is_grant  => FALSE,
                                          privilege => 'connect');

  COMMIT;
END;

-- *********************************************

BEGIN
  DBMS_NETWORK_ACL_ADMIN.drop_acl(acl => 'cdc.xml');

  COMMIT;
END;

-- *********************************************

-- The DBA_NETWORK_ACLS view displays information about network and ACL assignments.

SELECT HOST, LOWER_PORT, UPPER_PORT, ACL FROM DBA_NETWORK_ACLS;

-- The DBA_NETWORK_ACL_PRIVILEGES view displays information about privileges associated with the ACL.

SELECT ACL,
       PRINCIPAL,
       PRIVILEGE,
       IS_GRANT,
       TO_CHAR(START_DATE, 'DD-MON-YYYY') AS START_DATE,
       TO_CHAR(END_DATE, 'DD-MON-YYYY') AS END_DATE
  FROM DBA_NETWORK_ACL_PRIVILEGES;

-- The USER_NETWORK_ACL_PRIVILEGES view displays the current users network ACL settings.

SELECT HOST, LOWER_PORT, UPPER_PORT, PRIVILEGE, STATUS
  FROM USER_NETWORK_ACL_PRIVILEGES;

-- In addition to the ACL views, privileges can be checked using the CHECK_PRIVILEGE and CHECK_PRIVILEGE_ACLID functions of the DBMS_NETWORK_ACL_ADMIN package.

SELECT DECODE(DBMS_NETWORK_ACL_ADMIN.CHECK_PRIVILEGE('cdc.xml',
                                                     'SIS_REPLICACAO',
                                                     'connect'),
              1,
              'GRANTED',
              0,
              'DENIED',
              NULL) PRIVILEGE
  FROM DUAL;
