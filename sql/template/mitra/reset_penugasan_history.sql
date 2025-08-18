-- run this first to ensure you not misstyping
select count(*) from penugasan_history ps where ps.penugasan_uuid in  (select kmp.uuid as uuid from kegiatan_mitra_penugasan kmp left join kegiatan_mitra_bridge kmb on kmp.bridge_uuid  = kmb."uuid" where kmb.kegiatan_uuid = '5eb43a40-40ea-11f0-aab0-e9b3119ef152')



--this will delete all penugasan history from spesific kegiatan_uuid
-- BECAREFULLY because this can be delete all penugasan_history of that kegiatan

delete from penugasan_history ps where ps.penugasan_uuid in  (select kmp.uuid as uuid from kegiatan_mitra_penugasan kmp left join kegiatan_mitra_bridge kmb on kmp.bridge_uuid  = kmb."uuid" where kmb.kegiatan_uuid = '5eb43a40-40ea-11f0-aab0-e9b3119ef152')



--==============================================================================================================================


-- run this first to ensure you not misstyping
select count(*) from kegiatan_mitra_penugasan kmp where kmp.uuid in (select kmp.uuid from kegiatan_mitra_penugasan kmp left join kegiatan_mitra_bridge kmb on kmp.bridge_uuid  = kmb."uuid" where kmb.kegiatan_uuid = '5eb43a40-40ea-11f0-aab0-e9b3119ef152') and kmp.status != 0


--this will update all penugasan spesific kegiatan_uuid that have started (status != 0) to status = 0
-- BECAREFULLY because this will update all penugasan that have started of that kegiatan

update kegiatan_mitra_penugasan kmp set status = 0, notes = '' where kmp.uuid in (select kmp.uuid from kegiatan_mitra_penugasan kmp left join kegiatan_mitra_bridge kmb on kmp.bridge_uuid  = kmb."uuid" where kmb.kegiatan_uuid = '5eb43a40-40ea-11f0-aab0-e9b3119ef152') and kmp.status != 0