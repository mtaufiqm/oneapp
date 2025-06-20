alter table kegiatan add column penanggung_jawab text;
alter table kegiatan add foreign key (penanggung_jawab) references user(username) on delete set null on update cascade

create table kegiatan_mode(description text primary key)
alter table kegiatan add column mode text;
alter table kegiatan add foreign key (mode) references kegiatan_mode(description) on delete set null on update cascade

alter table kegiatan_mitra_bridge add column pengawas text;
alter table kegiatan_mitra_bridge add foreign key (pengawas) references user(username) on delete set null on update cascade


insert into kegiatan_mode(description) values ('CAPI');
insert into kegiatan_mode(description) values ('PAPI');
insert into kegiatan_mode(description) values ('CAWI');
insert into kegiatan_mode(description) values ('HYBRID');


ALTER TABLE structure_penilaian_mitra ADD UNIQUE(kuesioner_penilaian_mitra_uuid,mitra_username);

-- set foreign key ON DELETE SET NULL and ON UPDATE CASCADE