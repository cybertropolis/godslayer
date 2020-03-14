CREATE OR REPLACE TRIGGER REPLICACAO.TRG_MOEDA
 AFTER INSERT OR UPDATE OR DELETE ON REPLICACAO.MOEDA
   FOR EACH ROW
BEGIN
  IF INSERTING THEN
    DBMS_SCHEDULER.CREATE_JOB
    (
      JOB_NAME   => 'CDC_POST_REPLICACAO_MOEDA_' || :NEW.ID || '_' || TO_CHAR(SYSTIMESTAMP),
      JOB_TYPE   => 'PLSQL_BLOCK',
      JOB_ACTION => '
      BEGIN 
        REPLICACAO.CHANGE_DATA_CAPTURE.PUBLISH
        (
          P_ESQUEMA  => ''REPLICACAO'',
          P_TABELA   => ''MOEDA'',
          P_OPERACAO => 1,
          P_ID       => ' || TO_CHAR(:NEW.ID) || ',
          P_CONTEUDO => ''{ \"MOEDA\": \"' || :NEW.MOEDA || '\", \"SIMBOLO\": \"' || :NEW.SIMBOLO || '\" }''
        );
      END;',
      ENABLED    => TRUE,
      AUTO_DROP  => TRUE,
      COMMENTS   => 'Processo de Inclusão do POST REPLICACAO.MOEDA.ID ' || :NEW.ID
    );
  ELSIF UPDATING THEN
    DBMS_SCHEDULER.CREATE_JOB
    (
      JOB_NAME   => 'CDC_DELETE_REPLICACAO_MOEDA_' || :NEW.ID || '_' || TO_CHAR(SYSTIMESTAMP),
      JOB_TYPE   => 'PLSQL_BLOCK',
      JOB_ACTION => '
      BEGIN
        REPLICACAO.CHANGE_DATA_CAPTURE.PUBLISH
        (
          P_ESQUEMA  => 'REPLICACAO',
          P_TABELA   => 'MOEDA',
          P_OPERACAO => 2,
          P_ID       => ' || TO_CHAR(:OLD.ID) || ', 
          P_CONTEUDO => ''{ \"MOEDA\": \"' || :NEW.MOEDA || '\", \"SIMBOLO\": \"' || :NEW.SIMBOLO || '\" }''
        );
      END;',
      ENABLED    => TRUE,
      AUTO_DROP  => TRUE,
      COMMENTS   => 'Processo de Atualização do REPLICACAO.MOEDA.ID ' || :OLD.ID
    );
  ELSIF DELETING THEN
    DBMS_SCHEDULER.CREATE_JOB
    (
      JOB_NAME   => 'CDC_DELETE_REPLICACAO_MOEDA_' || :NEW.ID || '_' || TO_CHAR(SYSTIMESTAMP),
      JOB_TYPE   => 'PLSQL_BLOCK',
      JOB_ACTION => '
      BEGIN
        REPLICACAO.CHANGE_DATA_CAPTURE.PUBLISH
        (
          P_ESQUEMA  => ''REPLICACAO'',
          P_TABELA   => ''MOEDA'',
          P_OPERACAO => 3, 
          P_ID       => ' || TO_CHAR(:OLD.ID) || ',
          P_CONTEUDO => ''{ \"MOEDA\": \"' || :OLD.MOEDA || '\", \"SIMBOLO\": \"' || :OLD.SIMBOLO || '\" }''
        );
      END;',
      ENABLED    => TRUE,
      AUTO_DROP  => TRUE,
      COMMENTS   => 'Processo de Exclusão do REPLICACAO.MOEDA.ID ' || :OLD.ID
    );
  END IF;
END TRG_MOEDA;
