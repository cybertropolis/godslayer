CREATE SEQUENCE replication.seq_queue
       MINVALUE 1
       MAXVALUE 999999999
          START WITH 1
      INCREMENT BY 1
        NOCACHE;

CREATE TABLE replication.queue
(
    id            NUMBER(9) DEFAULT replication.seq_queue.NEXTVAL NOT NULL,
    squeme_name   VARCHAR2(30) NOT NULL,
    table_name    VARCHAR2(30) NOT NULL,
    operation     NUMBER(1) NOT NULL,
    message       VARCHAR2(4000) NOT NULL,
    processed     NUMBER(1) DEFAULT 0 NOT NULL,
    registered_at TIMESTAMP(6)WITH TIME ZONE DEFAULT SYSTIMESTAMP NOT NULL
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
   )
PARTITION BY LIST (processed)
(
    PARTITION p_processed_not VALUES (0),
    PARTITION p_processed_yes VALUES (1)
);

COMMENT ON TABLE replication.queue                IS 'Define queue of messages that must be reprocessed.';

COMMENT ON COLUMN replication.queue.id            IS 'Queue identification.';
COMMENT ON COLUMN replication.queue.squeme_name   IS 'Name of the schema that contains the table that must be reprocessed.';
COMMENT ON COLUMN replication.queue.table_name    IS 'Name of the table that must be reprocessed.';
COMMENT ON COLUMN replication.queue.operation     IS 'Defines whether the topic will be used for a (1) creation or (2) update or (3) deletion operation.';
COMMENT ON COLUMN replication.queue.message       IS 'Content that must be processed.';
COMMENT ON COLUMN replication.queue.processed     IS 'Indicates whether the queue has been properly processed (0) not or (1) yes.';
COMMENT ON COLUMN replication.queue.registered_at IS 'Defines whether the broker is (0) disabled or (1) enabled.';

ALTER TABLE replication.queue
        ADD CONSTRAINT pk_queue
    PRIMARY KEY (id)
      USING INDEX TABLESPACE tbs_replication;

ALTER TABLE replication.queue
        ADD CONSTRAINT ck_queue_operation
      CHECK (operation IN (1, 2, 3));

ALTER TABLE replication.queue
        ADD CONSTRAINT ck_queue_processed
      CHECK (processed IN (0, 1));
