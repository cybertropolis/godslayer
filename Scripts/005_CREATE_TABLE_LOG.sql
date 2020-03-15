CREATE SEQUENCE replication.seq_log
       MINVALUE 1
       MAXVALUE 999999999
          START WITH 1
      INCREMENT BY 1
        NOCACHE;

CREATE TABLE replication.log
(
    id             NUMBER(9) DEFAULT replication.seq_log.NEXTVAL NOT NULL,
    title          VARCHAR2(200) NOT NULL,
    description    VARCHAR2(4000) NOT NULL,
    queue_id       NUMBER(9) NOT NULL,
    origin         NUMBER(9) NOT NULL,
    registered_at  TIMESTAMP(6) WITH TIME ZONE DEFAULT SYSTIMESTAMP NOT NULL
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

COMMENT ON TABLE replication.log                IS 'Define a log.';

COMMENT ON COLUMN replication.log.id            IS 'Log identification.';
COMMENT ON COLUMN replication.log.title         IS 'Log title with a summary of the problem that occurred.';
COMMENT ON COLUMN replication.log.description   IS 'Description of the failure at the system level, can be a stacktrace, exception, etc.';
COMMENT ON COLUMN replication.log.queue_id      IS 'Queue identification derived from the error occurred.';
COMMENT ON COLUMN replication.log.origin        IS 'Defines the fault source layer, (1) Oracle Trigger, (2) Oracle CDC Package or (3) Integration API.';
COMMENT ON COLUMN replication.log.registered_at IS 'Log record date.';

ALTER TABLE replication.log
        ADD CONSTRAINT pk_log
    PRIMARY KEY (id)
      USING INDEX TABLESPACE tbs_replication;

ALTER TABLE replication.log
        ADD CONSTRAINT fk_log_queue
    FOREIGN KEY (queue_id)
 REFERENCES replication.queue (id);

ALTER TABLE replication.log
        ADD CONSTRAINT ck_log_origin
      CHECK (origin IN (1, 2, 3));
