CREATE OR REPLACE TRIGGER REPLICACAO.TRG_MOEDA
 AFTER INSERT OR UPDATE OR DELETE ON REPLICACAO.MOEDA
   FOR EACH ROW
BEGIN
  IF INSERTING THEN
    REPLICACAO.CHANGE_DATA_CAPTURE.PUBLISH
    (
      P_ESQUEMA  => 'REPLICACAO',
      P_TABELA   => 'MOEDA', 
      P_OPERACAO => 1, 
      P_ID       => :NEW.ID, 
      P_CONTEUDO => '{ \"MOEDA\": \"' || :NEW.MOEDA || '\", \"SIMBOLO\": \"' || :NEW.SIMBOLO || '\" }'
    );
  ELSIF UPDATING THEN
    REPLICACAO.CHANGE_DATA_CAPTURE.PUBLISH
    (
      P_ESQUEMA  => 'REPLICACAO',
      P_TABELA   => 'MOEDA',
      P_OPERACAO => 2,
      P_ID       => :OLD.ID, 
      P_CONTEUDO => '{ \"MOEDA\": \"' || :NEW.MOEDA || '\", \"SIMBOLO\": \"' || :NEW.SIMBOLO || '\" }'
    );
  ELSIF DELETING THEN
    REPLICACAO.CHANGE_DATA_CAPTURE.PUBLISH
    (
      P_ESQUEMA  => '''REPLICACAO''', 
      P_TABELA   => '''MOEDA''', 
      P_OPERACAO => 3, 
      P_ID       => :OLD.ID,
      P_CONTEUDO => '''{ \"MOEDA\": \"''' || :OLD.MOEDA || '''\", \"SIMBOLO\": \"''' || :OLD.SIMBOLO || '''\" }'''
    );
  END IF;
END TRG_MOEDA;
