CREATE TABLE "user" (
  "username" text PRIMARY KEY,
  "pwd" text
);

CREATE TABLE "pegawai" (
  "uuid" text PRIMARY KEY,
  "fullname" text,
  "fullname_with_title" text,
  "nickname" text,
  "date_of_birth" text,
  "city_of_birth" text,
  "nip" text,
  "old_nip" text,
  "age" integer,
  "username" text UNIQUE,
  "status_pegawai" text
);

CREATE TABLE "status_pegawai" (
  "description" text PRIMARY KEY
);

CREATE TABLE "mitra" (
  "mitra_id" text PRIMARY KEY,
  "fullname" text,
  "nickname" text,
  "date_of_birth" text,
  "city_of_birth" text,
  "email" text,
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

CREATE TABLE "roles" (
  "description" text PRIMARY KEY
);

CREATE TABLE "user_role_bridge" (
  "description" text,
  "username" text,
  PRIMARY KEY ("description", "username")
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
  "survei_type" text
);

CREATE TABLE "answer_assignment" (
  "uuid" text PRIMARY KEY,
  "response_assignment_uuid" text,
  "questions_item_uuid" text,
  "questions_option_uuid" text
);

CREATE TABLE "products" (
  "uuid" text PRIMARY KEY,
  "name" text,
  "image_link" text,
  "unit" text,
  "stock_quantity" integer,
  "created_at" text,
  "created_by" text
);

CREATE TABLE "categories" (
  "uuid" text PRIMARY KEY,
  "name" text
);

CREATE TABLE "categories_products" (
  "product_uuid" text,
  "categories_uuid" text
);

CREATE TABLE "stock_transactions" (
  "uuid" text PRIMARY KEY,
  "product_uuid" text,
  "quantity" integer,
  "status" text,
  "created_at" text,
  "last_updated" text,
  "created_by" text
);

CREATE TABLE "files" (
  "uuid" text PRIMARY KEY,
  "name" text,
  "extension" text,
  "location" text,
  "created_at" text,
  "created_by" text
);

CREATE TABLE "documentation" (
  "uuid" text PRIMARY KEY,
  "name" text,
  "details" text,
  "documentation_time" text,
  "files_uuid" text,
  "created_at" text,
  "created_by" text,
  "updated_at" text
);

CREATE TABLE "innovation" (
  "uuid" text PRIMARY KEY,
  "name" text NOT NULL,
  "alias" text NOT NULL,
  "description" text NOT NULL,
  "files_uuid" text NOT NULL,
  "innovation_link" text NOT NULL,
  "is_locked" boolean NOT NULL,
  "pwd" text,
  "created_at" text NOT NULL,
  "created_by" text NOT NULL,
  "last_updated" text NOT NULL
);

CREATE TABLE "ftp_server" (
  "username" text PRIMARY KEY,
  "password" text NOT NULL
);

CREATE TABLE "transactions" (
  "uuid" text PRIMARY KEY,
  "status" text NOT NULL,
  "created_at" text NOT NULL,
  "created_by" text NOT NULL,
  "last_updated" text NOT NULL
);

CREATE TABLE "transactions_item" (
  "uuid" text PRIMARY KEY,
  "transactions_uuid" text NOT NULL,
  "products_uuid" text NOT NULL,
  "quantity" int NOT NULL
);

CREATE TABLE "daerah_tingkat_1" (
  "id" text PRIMARY KEY,
  "name" text NOT NULL,
  "code" text NOT NULL,
  "type" text NOT NULL
);

CREATE TABLE "daerah_tingkat_2" (
  "id" text PRIMARY KEY,
  "name" text NOT NULL,
  "code" text NOT NULL,
  "type" text NOT NULL,
  "dt1_id" text
);

CREATE TABLE "daerah_tingkat_3" (
  "id" text PRIMARY KEY,
  "name" text NOT NULL,
  "code" text NOT NULL,
  "type" text NOT NULL,
  "dt2_id" text
);

CREATE TABLE "daerah_tingkat_4" (
  "id" text PRIMARY KEY,
  "name" text NOT NULL,
  "code" text NOT NULL,
  "type" text NOT NULL,
  "dt3_id" text
);

CREATE TABLE "daerah_tingkat_5" (
  "id" text PRIMARY KEY,
  "name" text NOT NULL,
  "code" text NOT NULL,
  "type" text NOT NULL,
  "dt4_id" text
);

CREATE UNIQUE INDEX ON "transactions_item" ("transactions_uuid", "products_uuid");

ALTER TABLE "pegawai" ADD FOREIGN KEY ("username") REFERENCES "user" ("username");

ALTER TABLE "pegawai" ADD FOREIGN KEY ("status_pegawai") REFERENCES "status_pegawai" ("description");

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

ALTER TABLE "products" ADD FOREIGN KEY ("created_by") REFERENCES "user" ("username");

ALTER TABLE "categories_products" ADD FOREIGN KEY ("product_uuid") REFERENCES "products" ("uuid");

ALTER TABLE "categories_products" ADD FOREIGN KEY ("categories_uuid") REFERENCES "categories" ("uuid");

ALTER TABLE "stock_transactions" ADD FOREIGN KEY ("created_by") REFERENCES "user" ("username");

ALTER TABLE "stock_transactions" ADD FOREIGN KEY ("product_uuid") REFERENCES "products" ("uuid");

ALTER TABLE "files" ADD FOREIGN KEY ("created_by") REFERENCES "user" ("username");

ALTER TABLE "documentation" ADD FOREIGN KEY ("created_by") REFERENCES "user" ("username");

ALTER TABLE "documentation" ADD FOREIGN KEY ("files_uuid") REFERENCES "files" ("uuid");

ALTER TABLE "innovation" ADD FOREIGN KEY ("created_by") REFERENCES "user" ("username");

ALTER TABLE "innovation" ADD FOREIGN KEY ("files_uuid") REFERENCES "files" ("uuid");

ALTER TABLE "transactions" ADD FOREIGN KEY ("created_by") REFERENCES "user" ("username");

ALTER TABLE "transactions_item" ADD FOREIGN KEY ("transactions_uuid") REFERENCES "transactions" ("uuid");

ALTER TABLE "transactions_item" ADD FOREIGN KEY ("products_uuid") REFERENCES "products" ("uuid");

ALTER TABLE "ftp_server" ADD FOREIGN KEY ("username") REFERENCES "ftp_server" ("password");

ALTER TABLE "daerah_tingkat_2" ADD FOREIGN KEY ("dt1_id") REFERENCES "daerah_tingkat_1" ("id");

ALTER TABLE "daerah_tingkat_3" ADD FOREIGN KEY ("dt2_id") REFERENCES "daerah_tingkat_2" ("id");

ALTER TABLE "daerah_tingkat_4" ADD FOREIGN KEY ("dt3_id") REFERENCES "daerah_tingkat_3" ("id");

ALTER TABLE "daerah_tingkat_5" ADD FOREIGN KEY ("dt4_id") REFERENCES "daerah_tingkat_4" ("id");
