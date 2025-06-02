drop table answer_assignment;
drop table response_assignment;
drop table questions_option;
drop table questions_item;
drop table questions_group;
drop table questions_bloc;
drop table survei;
drop table structure_penilaian_mitra;
drop table survei_type;
drop table kuesioner_penilaian_mitra;

CREATE TABLE "kuesioner_penilaian_mitra" (
  "uuid" text PRIMARY KEY,
  "kegiatan_uuid" text UNIQUE NOT NULL,
  "title" text NOT NULL,
  "description" text NOT NULL,
  "start_date" text,
  "end_date" text
);

CREATE TABLE "survei_type" (
  "description" text PRIMARY KEY
);

CREATE TABLE "structure_penilaian_mitra" (
  "uuid" text PRIMARY KEY,
  "kuesioner_penilaian_mitra_uuid" text,
  "penilai_username" text,
  "mitra_username" text,
  "survei_uuid" text
);

CREATE TABLE "survei" (
  "uuid" text PRIMARY KEY,
  "survei_type" text UNIQUE,
  "description" text,
  "version" integer
);

CREATE TABLE "questions_bloc" (
  "uuid" text PRIMARY KEY,
  "title" text,
  "description" text,
  "order" integer,
  "survei_uuid" text,
  "tag" text
);

CREATE TABLE "questions_group" (
  "uuid" text PRIMARY KEY,
  "title" text,
  "description" text,
  "order" integer,
  "questions_bloc_uuid" text,
  "tag" text
);

CREATE TABLE "questions_item" (
  "uuid" text PRIMARY KEY,
  "title" text,
  "description" text,
  "validation" text,
  "order" integer,
  "questions_group_uuid" text,
  "tag" text
);

CREATE TABLE "questions_option" (
  "uuid" text PRIMARY KEY,
  "title" text,
  "description" text,
  "order" integer,
  "value" integer,
  "tag" text,
  "questions_item_uuid" text
);

CREATE TABLE "response_assignment" (
  "uuid" text PRIMARY KEY,
  "structure_uuid" text UNIQUE,
  "created_at" text,
  "updated_at" text,
  "is_completed" bool,
  "survei_uuid" text,
  "notes" text
);

CREATE TABLE "answer_assignment" (
  "uuid" text PRIMARY KEY,
  "response_assignment_uuid" text,
  "questions_item_uuid" text,
  "questions_option_uuid" text
);

ALTER TABLE "kuesioner_penilaian_mitra" ADD FOREIGN KEY ("kegiatan_uuid") REFERENCES "kegiatan" ("uuid") ON UPDATE CASCADE;

ALTER TABLE "structure_penilaian_mitra" ADD FOREIGN KEY ("kuesioner_penilaian_mitra_uuid") REFERENCES "kuesioner_penilaian_mitra" ("uuid") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "structure_penilaian_mitra" ADD FOREIGN KEY ("penilai_username") REFERENCES "pegawai" ("username");

ALTER TABLE "structure_penilaian_mitra" ADD FOREIGN KEY ("mitra_username") REFERENCES "mitra" ("username");

ALTER TABLE "structure_penilaian_mitra" ADD FOREIGN KEY ("survei_uuid") REFERENCES "survei" ("uuid");

ALTER TABLE "survei" ADD FOREIGN KEY ("survei_type") REFERENCES "survei_type" ("description");

ALTER TABLE "questions_bloc" ADD FOREIGN KEY ("survei_uuid") REFERENCES "survei" ("uuid") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "questions_group" ADD FOREIGN KEY ("questions_bloc_uuid") REFERENCES "questions_bloc" ("uuid") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "questions_item" ADD FOREIGN KEY ("questions_group_uuid") REFERENCES "questions_group" ("uuid") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "questions_option" ADD FOREIGN KEY ("questions_item_uuid") REFERENCES "questions_item" ("uuid") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "response_assignment" ADD FOREIGN KEY ("structure_uuid") REFERENCES "structure_penilaian_mitra" ("uuid") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "response_assignment" ADD FOREIGN KEY ("survei_uuid") REFERENCES "survei" ("uuid");

ALTER TABLE "answer_assignment" ADD FOREIGN KEY ("response_assignment_uuid") REFERENCES "response_assignment" ("uuid") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "answer_assignment" ADD FOREIGN KEY ("questions_item_uuid") REFERENCES "questions_item" ("uuid");

ALTER TABLE "answer_assignment" ADD FOREIGN KEY ("questions_option_uuid") REFERENCES "questions_option" ("uuid");