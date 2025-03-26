drop table answer_response_assignment;
drop table general_questions;
drop table response_assignment;
drop table structure_kuesioner_mitra;
drop table kuesioner_mitra;
drop table kegiatan;
drop table mitra;

CREATE TABLE "mitra" (
  "mitra_id" text PRIMARY KEY,
  "fullname" text,
  "nickname" text,
  "date_of_birth" text,
  "city_of_birth" text,
  "username" text UNIQUE
);

CREATE TABLE "kegiatan" (
  "uuid" text PRIMARY KEY,
  "name" text,
  "description" text,
  "start" text,
  "end" text,
  "monitoring_link" text,
  "organic_involved" boolean,
  "organic_number" integer,
  "mitra_involved" boolean,
  "mitra_number" integer,
  "created_by" text
);

CREATE TABLE "kuesioner_penilaian_mitra" (
  "uuid" text PRIMARY KEY,
  "kegiatan_uuid" text UNIQUE NOT NULL,
  "title" text NOT NULL,
  "description" text NOT NULL
);

CREATE TABLE "survei_type" (
  "description" text PRIMARY KEY
);

CREATE TABLE "structure_penilaian_mitra" (
  "uuid" text PRIMARY KEY,
  "kuesioner_penilaian_mitra_uuid" text,
  "penilai_username" text,
  "mitra_username" text,
  "survei_type" text
);

CREATE TABLE "survei" (
  "uuid" text PRIMARY KEY,
  "survei_type" text UNIQUE,
  "description" text
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
  "structure_uuid" text,
  "created_at" text,
  "updated_at" text,
  "is_completed" bool,
  "survei_type" text,
  "notes" text
);

CREATE TABLE "answer_assignment" (
  "uuid" text PRIMARY KEY,
  "response_assignment_uuid" text,
  "questions_item_uuid" text,
  "questions_option_uuid" text
);

ALTER TABLE "mitra" ADD FOREIGN KEY ("username") REFERENCES "user" ("username");

ALTER TABLE "kegiatan" ADD FOREIGN KEY ("created_by") REFERENCES "user" ("username");

ALTER TABLE "user_role_bridge" ADD FOREIGN KEY ("description") REFERENCES "roles" ("description");

ALTER TABLE "user_role_bridge" ADD FOREIGN KEY ("username") REFERENCES "user" ("username");

ALTER TABLE "kuesioner_penilaian_mitra" ADD FOREIGN KEY ("kegiatan_uuid") REFERENCES "kegiatan" ("uuid");

ALTER TABLE "structure_penilaian_mitra" ADD FOREIGN KEY ("kuesioner_penilaian_mitra_uuid") REFERENCES "kuesioner_penilaian_mitra" ("uuid");

ALTER TABLE "structure_penilaian_mitra" ADD FOREIGN KEY ("penilai_username") REFERENCES "pegawai" ("username");

ALTER TABLE "structure_penilaian_mitra" ADD FOREIGN KEY ("mitra_username") REFERENCES "mitra" ("username");

ALTER TABLE "structure_penilaian_mitra" ADD FOREIGN KEY ("survei_type") REFERENCES "survei_type" ("description");

ALTER TABLE "survei" ADD FOREIGN KEY ("survei_type") REFERENCES "survei_type" ("description");

ALTER TABLE "questions_bloc" ADD FOREIGN KEY ("survei_uuid") REFERENCES "survei" ("uuid");

ALTER TABLE "questions_group" ADD FOREIGN KEY ("questions_bloc_uuid") REFERENCES "questions_bloc" ("uuid");

ALTER TABLE "questions_item" ADD FOREIGN KEY ("questions_group_uuid") REFERENCES "questions_group" ("uuid");

ALTER TABLE "questions_option" ADD FOREIGN KEY ("questions_item_uuid") REFERENCES "questions_item" ("uuid");

ALTER TABLE "response_assignment" ADD FOREIGN KEY ("structure_uuid") REFERENCES "structure_penilaian_mitra" ("uuid");

ALTER TABLE "response_assignment" ADD FOREIGN KEY ("survei_type") REFERENCES "survei_type" ("description");

ALTER TABLE "answer_assignment" ADD FOREIGN KEY ("response_assignment_uuid") REFERENCES "response_assignment" ("uuid");

ALTER TABLE "answer_assignment" ADD FOREIGN KEY ("questions_item_uuid") REFERENCES "questions_item" ("uuid");

ALTER TABLE "answer_assignment" ADD FOREIGN KEY ("questions_option_uuid") REFERENCES "questions_option" ("uuid");
