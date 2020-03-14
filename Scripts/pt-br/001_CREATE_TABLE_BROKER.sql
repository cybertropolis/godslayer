CREATE SEQUENCE REPLICACAO.SEQ_BROKER
       MINVALUE 1
       MAXVALUE 999999999
          START WITH 1
      INCREMENT BY 1
        NOCACHE;

GRANT SELECT ON REPLICACAO.SEQ_BROKER TO SIS_REPLICACAO;

CREATE TABLE REPLICACAO.BROKER
(
    ID                 NUMBER(9) DEFAULT REPLICACAO.SEQ_BROKER.NEXTVAL NOT NULL,
    NOME               VARCHAR2(64) NOT NULL,
    HOST               VARCHAR2(64) NOT NULL,
    SITUACAO           NUMBER(1) DEFAULT 1 NOT NULL,
    DATA_ESCALONAMENTO TIMESTAMP(6) WITH TIME ZONE DEFAULT SYSTIMESTAMP NOT NULL
)
TABLESPACE TBS_REPLICACAO
   PCTFREE 10
  INITRANS 1
  MAXTRANS 255
   STORAGE
   (
       INITIAL 64K
       NEXT 1M
       MINEXTENTS 1
       MAXEXTENTS UNLIMITED
   );

COMMENT ON TABLE REPLICACAO.BROKER                     IS 'Define um broker que receberá mensagens.';

COMMENT ON COLUMN REPLICACAO.BROKER.ID                 IS 'Identificação do broker.';
COMMENT ON COLUMN REPLICACAO.BROKER.NOME               IS 'Nome do broker, é apenas uma descrição sugestiva.';
COMMENT ON COLUMN REPLICACAO.BROKER.HOST               IS 'Host do broker, pode ser um IP ou um nome de domínio como google.com ou https://google.com, pode também conter ou não a porta mais recurso como http://seudominio.com.br:8822/api/fazalgo';
COMMENT ON COLUMN REPLICACAO.BROKER.SITUACAO           IS 'Define se o broker está (0) desativado ou (1) ativado.';
COMMENT ON COLUMN REPLICACAO.BROKER.DATA_ESCALONAMENTO IS 'Data da última vez em que o broker foi escalonado, usado para definir qual nó do cluster vai processar a mensagem.';

ALTER TABLE REPLICACAO.BROKER
        ADD CONSTRAINT PK_BROKER
    PRIMARY KEY (ID)
      USING INDEX TABLESPACE TBS_REPLICACAO;

ALTER TABLE REPLICACAO.BROKER
        ADD CONSTRAINT CK_BROKER_SITUACAO
      CHECK (SITUACAO IN (0, 1));

GRANT SELECT, INSERT, UPDATE, DELETE ON REPLICACAO.BROKER TO SIS_REPLICACAO;
