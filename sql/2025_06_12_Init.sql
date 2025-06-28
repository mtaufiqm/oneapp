CREATE TABLE "user" (
  "username" text PRIMARY KEY,
  "pwd" text
);

CREATE TABLE "roles" (
  "description" text PRIMARY KEY
);

CREATE TABLE "user_role_bridge" (
  "description" text,
  "username" text,
  PRIMARY KEY ("description", "username")
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
  "status_pegawai" text,
  "phone_number" text
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
  "username" text UNIQUE,
  "email" text,
  "phone_number" text,
  "address_code" text,
  "address_detail" text
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
  "created_by" text,
  "penanggung_jawab" text
);

CREATE TABLE "kegiatan_mitra_bridge" (
  "uuid" text PRIMARY KEY,
  "kegiatan_uuid" text,
  "mitra_id" text,
  "status" text
);

CREATE TABLE "kegiatan_mitra_penugasan" (
  "uuid" text PRIMARY KEY,
  "bridge_uuid" text NOT NULL,
  "code" text NOT NULL,
  "group" text NOT NULL,
  "group_type_id" int NOT NULL,
  "group_desc" text NOT NULL,
  "description" text NOT NULL,
  "unit" text NOT NULL,
  "status" int NOT NULL,
  "started_time" text,
  "ended_time" text,
  "location_latitude" text,
  "location_longitude" text,
  "notes" text,
  "created_at" text,
  "last_updated" text
);

CREATE TABLE "penugasan_status" (
  "id" int PRIMARY KEY,
  "description" text NOT NULL
);

CREATE TABLE "penugasan_group_type" (
  "id" int PRIMARY KEY,
  "description" text NOT NULL
);

CREATE TABLE "penugasan_history" (
  "uuid" text PRIMARY KEY,
  "penugasan_uuid" text NOT NULL,
  "status" int NOT NULL,
  "created_at" text NOT NULL
);

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

CREATE TABLE "daerah_blok_sensus" (
  "id" text PRIMARY KEY,
  "name" text NOT NULL,
  "code" text NOT NULL,
  "type" text NOT NULL,
  "dt4_id" text
);

ALTER TABLE "user_role_bridge" ADD FOREIGN KEY ("description") REFERENCES "roles" ("description");

ALTER TABLE "user_role_bridge" ADD FOREIGN KEY ("username") REFERENCES "user" ("username");

ALTER TABLE "pegawai" ADD FOREIGN KEY ("username") REFERENCES "user" ("username") ON UPDATE CASCADE;

ALTER TABLE "pegawai" ADD FOREIGN KEY ("status_pegawai") REFERENCES "status_pegawai" ("description");

ALTER TABLE "mitra" ADD FOREIGN KEY ("username") REFERENCES "user" ("username") ON UPDATE CASCADE;

ALTER TABLE "kegiatan" ADD FOREIGN KEY ("created_by") REFERENCES "user" ("username");

ALTER TABLE "kegiatan" ADD FOREIGN KEY ("penanggung_jawab") REFERENCES "user" ("username") ON DELETE SET NULL ON UPDATE CASCADE

ALTER TABLE "kegiatan_mitra_bridge" ADD FOREIGN KEY ("kegiatan_uuid") REFERENCES "kegiatan" ("uuid");

ALTER TABLE "kegiatan_mitra_bridge" ADD FOREIGN KEY ("mitra_id") REFERENCES "mitra" ("mitra_id");

ALTER TABLE "kegiatan_mitra_penugasan" ADD FOREIGN KEY ("status") REFERENCES "penugasan_status" ("id");

ALTER TABLE "kegiatan_mitra_penugasan" ADD FOREIGN KEY ("group_type_id") REFERENCES "penugasan_group_type" ("id");

ALTER TABLE "penugasan_history" ADD FOREIGN KEY ("penugasan_uuid") REFERENCES "kegiatan_mitra_penugasan" ("uuid") ON DELETE CASCADE;

ALTER TABLE "penugasan_history" ADD FOREIGN KEY ("status") REFERENCES "penugasan_status" ("id");

ALTER TABLE "kuesioner_penilaian_mitra" ADD FOREIGN KEY ("kegiatan_uuid") REFERENCES "kegiatan" ("uuid") ON UPDATE CASCADE;

ALTER TABLE "structure_penilaian_mitra" ADD FOREIGN KEY ("kuesioner_penilaian_mitra_uuid") REFERENCES "kuesioner_penilaian_mitra" ("uuid") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "structure_penilaian_mitra" ADD FOREIGN KEY ("penilai_username") REFERENCES "pegawai" ("username") ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE "structure_penilaian_mitra" ADD FOREIGN KEY ("mitra_username") REFERENCES "mitra" ("username") ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE "structure_penilaian_mitra" ADD FOREIGN KEY ("survei_uuid") REFERENCES "survei" ("uuid") ON DELETE ;

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

ALTER TABLE "daerah_tingkat_2" ADD FOREIGN KEY ("dt1_id") REFERENCES "daerah_tingkat_1" ("id") ON UPDATE CASCADE;

ALTER TABLE "daerah_tingkat_3" ADD FOREIGN KEY ("dt2_id") REFERENCES "daerah_tingkat_2" ("id") ON UPDATE CASCADE;

ALTER TABLE "daerah_tingkat_4" ADD FOREIGN KEY ("dt3_id") REFERENCES "daerah_tingkat_3" ("id") ON UPDATE CASCADE;

ALTER TABLE "daerah_tingkat_5" ADD FOREIGN KEY ("dt4_id") REFERENCES "daerah_tingkat_4" ("id") ON UPDATE CASCADE;

ALTER TABLE "daerah_blok_sensus" ADD FOREIGN KEY ("dt4_id") REFERENCES "daerah_tingkat_4" ("id") ON UPDATE CASCADE;

ALTER TABLE "transactions_item" ADD UNIQUE("transactions_uuid","products_uuid");

ALTER TABLE "kegiatan_mitra_bridge" ADD UNIQUE("kegiatan_uuid","mitra_id");

ALTER TABLE "structure_penilaian_mitra" ADD UNIQUE("kuesioner_penilaian_mitra_uuid","mitra_username");

ALTER TABLE "answer_assignment" ADD UNIQUE("response_assignment_uuid","questions_item_uuid");