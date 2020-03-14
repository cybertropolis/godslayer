CREATE SEQUENCE replication.seq_broker
       MINVALUE 1
       MAXVALUE 999999999
          START WITH 1
      INCREMENT BY 1
        NOCACHE;

CREATE TABLE replication.broker
(
    id         NUMBER(9) DEFAULT replication.seq_broker.NEXTVAL NOT NULL,
    name       VARCHAR2(64) NOT NULL,
    host       VARCHAR2(64) NOT NULL,
    situation  NUMBER(1) DEFAULT 1 NOT NULL,
    last_scale TIMESTAMP(6) WITH TIME ZONE DEFAULT SYSTIMESTAMP NOT NULL
)
TABLESPACE tbs_replication
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

COMMENT ON TABLE replication.broker             IS 'Defines a broker that will receive messages.';

COMMENT ON COLUMN replication.broker.id         IS 'Broker identification.';
COMMENT ON COLUMN replication.broker.name       IS 'Broker name is just a suggestive description.';
COMMENT ON COLUMN replication.broker.host       IS 'Broker host, it can be an IP or a domain name like google.com or https://google.com, it can also contain or not the port plus resource like http://yourdomain.com.br:8822/api/...';
COMMENT ON COLUMN replication.broker.situation  IS 'Defines whether the broker is (0) disabled or (1) enabled.';
COMMENT ON COLUMN replication.broker.last_scale IS 'Date of the last time the broker was scheduled, used to define which cluster node will process the message.';

ALTER TABLE replication.broker
        ADD CONSTRAINT pk_broker
    PRIMARY KEY (id)
      USING INDEX TABLESPACE tbs_replication;

ALTER TABLE replication.broker
        ADD CONSTRAINT ck_broker_situation
      CHECK (situation IN (0, 1));
