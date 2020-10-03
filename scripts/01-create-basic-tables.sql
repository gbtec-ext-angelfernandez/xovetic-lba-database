--
-- PostgreSQL database dump
--
CREATE SCHEMA lba;

CREATE TABLE lba.comment (
    id INTEGER NOT NULL PRIMARY KEY,
    statement TEXT NOT NULL
);

INSERT INTO lba.comment VALUES (1, 'LJ is the best player.');
INSERT INTO lba.comment VALUES (2, 'LBA will be awesome!');