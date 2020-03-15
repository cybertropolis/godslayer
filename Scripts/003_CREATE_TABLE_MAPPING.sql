CREATE SEQUENCE replication.seq_resource
       MINVALUE 1
       MAXVALUE 999999999
          START WITH 1
      INCREMENT BY 1
        NOCACHE;

CREATE TABLE replication.mapping
(
    id          NUMBER(9) DEFAULT replication.seq_resource.NEXTVAL NOT NULL,
    scheme_name VARCHAR2(30) NOT NULL,
    table_name  VARCHAR2(30) NOT NULL,
    topic_id    NUMBER(9) NOT NULL,
    situation   NUMBER(1) DEFAULT 1 NOT NULL
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

COMMENT ON TABLE replication.mapping              IS 'Resource used to integrate oracle with the broker.';

COMMENT ON COLUMN replication.mapping.id          IS 'Resource identification.';
COMMENT ON COLUMN replication.mapping.scheme_name IS 'Schema name.';
COMMENT ON COLUMN replication.mapping.table_name  IS 'Table name.';
COMMENT ON COLUMN replication.mapping.topic_id     IS 'Topic identification.';
COMMENT ON COLUMN replication.mapping.situation   IS 'Defines whether the topic is (0) disabled or (1) enabled.';

ALTER TABLE replication.mapping
        ADD CONSTRAINT pk_mapping
    PRIMARY KEY (id)
      USING INDEX TABLESPACE tbs_replication;

ALTER TABLE replication.mapping
        ADD CONSTRAINT fk_mapping_topic
    FOREIGN KEY (topic_id)
 REFERENCES replication.topic (id);

ALTER TABLE replication.mapping
        ADD CONSTRAINT ck_mapping_situation
      CHECK (situation IN (0, 1));
