CREATE SEQUENCE replication.seq_topic
       MINVALUE 1
       MAXVALUE 999999999
          START WITH 1
      INCREMENT BY 1
        NOCACHE;

CREATE TABLE replication.topic
(
    id         NUMBER(9) DEFAULT replication.seq_topic.NEXTVAL NOT NULL,
    name       VARCHAR2(128) NOT NULL,
    replicas   NUMBER(2) NULL,
    partitions NUMBER(2) NULL,
    situation   NUMBER(1) DEFAULT 1 NOT NULL,
    operation   NUMBER(1) NOT NULL
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

COMMENT ON TABLE replication.topic             IS 'Defines a topic.';

COMMENT ON COLUMN replication.topic.id         IS 'Topic identification.';
COMMENT ON COLUMN replication.topic.nome       IS 'Topic name, Kafka''s exclusive resource.';
COMMENT ON COLUMN replication.topic.replicas   IS 'Number of replicas, exclusive feature of Kafka.';
COMMENT ON COLUMN replication.topic.partitions IS 'Number of partitions, exclusive feature of Kafka.';
COMMENT ON COLUMN replication.topic.situation  IS 'Defines whether the topic is (0) disabled or (1) enabled.';
COMMENT ON COLUMN replication.topic.operation  IS 'Defines whether the topic will be used for a (1) creation or (2) update or (3) deletion operation.';

ALTER TABLE replication.topic
        ADD CONSTRAINT pk_topic
    PRIMARY KEY (id)
      USING INDEX TABLESPACE tbs_replication;

ALTER TABLE replication.topic
        ADD CONSTRAINT ck_topic_situation
      CHECK (situation IN (0, 1));

ALTER TABLE replication.topic
        ADD CONSTRAINT ck_topic_operation
      CHECK (operation IN (1, 2, 3));

