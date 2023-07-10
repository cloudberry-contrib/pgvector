SET enable_seqscan = off;

CREATE TABLE t (val vector(3));
INSERT INTO t (val) VALUES ('[0,0,0]'), ('[1,2,3]'), ('[1,1,1]'), (NULL);
-- start_ignore
CREATE INDEX ON t USING ivfflat (val vector_l2_ops) WITH (lists = 1);
-- end_ignore

INSERT INTO t (val) VALUES ('[1,2,4]');

SELECT * FROM t ORDER BY val <-> '[3,3,3]';
-- this sql will convert to ‘order by ctid’ clause, but the result is not stable on MPP architecture.
-- SELECT * FROM t ORDER BY val <-> (SELECT NULL::vector);
SELECT * FROM t ORDER BY val;
SELECT COUNT(*) FROM t;

-- start_ignore
TRUNCATE t;
-- end_ignore
SELECT * FROM t ORDER BY val <-> '[3,3,3]';

DROP TABLE t;
