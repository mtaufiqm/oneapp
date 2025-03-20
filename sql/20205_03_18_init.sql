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
  "mitraId" text PRIMARY KEY,
  "fullname" text,
  "nickname" text,
  "date_of_birth" date,
  "city_of_birth" text,
  "username" text UNIQUE
);

CREATE TABLE "kegiatan" (
  "id" text PRIMARY KEY,
  "name" text,
  "description" text,
  "start" date,
  "last" date,
  "monitoring_link" text,
  "organic_involved" boolean,
  "organic_number" integer,
  "mitra_involved" boolean,
  "mitra_number" integer,
  "createdby" text
);

CREATE TABLE "roles" (
  "description" text PRIMARY KEY
);

CREATE TABLE "user_role_bridge" (
  "description" text,
  "username" text,
  PRIMARY KEY ("description", "username")
);

CREATE TABLE "kuesioner_mitra" (
  "id" serial PRIMARY KEY,
  "uuid" text UNIQUE,
  "kegiatan_id" text UNIQUE,
  "title" text,
  "description" text
);

CREATE TABLE "structure_kuesioner_mitra" (
  "id" serial PRIMARY KEY,
  "uuid" text UNIQUE,
  "kuesioner_mitra" integer,
  "penilai_username" text,
  "mitra_username" text,
  "mitra_role" text,
  "versi_kuesioner" integer
);

CREATE TABLE "general_questions" (
  "id" serial PRIMARY KEY,
  "uuid" text UNIQUE,
  "version" integer,
  "group" integer,
  "group_desc" text,
  "order_in_group" integer,
  "question" text,
  "description" text,
  "type" text
);

CREATE TABLE "response_assignment" (
  "id" serial PRIMARY KEY,
  "uuid" text UNIQUE,
  "structure_uuid" text,
  "type_kuesioner" text,
  "status" bool
);

CREATE TABLE "answer_response_assignment" (
  "id" serial PRIMARY KEY,
  "uuid" text UNIQUE,
  "value" text,
  "question_id" integer,
  "response_id" integer
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

ALTER TABLE "pegawai" ADD FOREIGN KEY ("username") REFERENCES "user" ("username");

ALTER TABLE "pegawai" ADD FOREIGN KEY ("status_pegawai") REFERENCES "status_pegawai" ("description");

ALTER TABLE "mitra" ADD FOREIGN KEY ("username") REFERENCES "user" ("username");

ALTER TABLE "kegiatan" ADD FOREIGN KEY ("createdby") REFERENCES "user" ("username");

ALTER TABLE "user_role_bridge" ADD FOREIGN KEY ("description") REFERENCES "roles" ("description");

ALTER TABLE "user_role_bridge" ADD FOREIGN KEY ("username") REFERENCES "user" ("username");

ALTER TABLE "kuesioner_mitra" ADD FOREIGN KEY ("kegiatan_id") REFERENCES "kegiatan" ("id");

ALTER TABLE "structure_kuesioner_mitra" ADD FOREIGN KEY ("penilai_username") REFERENCES "user" ("username");

ALTER TABLE "structure_kuesioner_mitra" ADD FOREIGN KEY ("mitra_username") REFERENCES "user" ("username");

ALTER TABLE "structure_kuesioner_mitra" ADD FOREIGN KEY ("kuesioner_mitra") REFERENCES "kuesioner_mitra" ("id");

ALTER TABLE "response_assignment" ADD FOREIGN KEY ("structure_uuid") REFERENCES "structure_kuesioner_mitra" ("uuid");

ALTER TABLE "answer_response_assignment" ADD FOREIGN KEY ("question_id") REFERENCES "general_questions" ("id");

ALTER TABLE "answer_response_assignment" ADD FOREIGN KEY ("response_id") REFERENCES "response_assignment" ("id");

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

ALTER TABLE "transactions_item" ADD UNIQUE ("transactions_uuid","products_uuid");

