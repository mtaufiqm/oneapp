-- check assignment yang tidak sengaja di selesaikan by certain mitra dan certain kegiatan
select kmp.*  from kegiatan_mitra_penugasan kmp left join kegiatan_mitra_bridge kmb on kmp.bridge_uuid  = kmb."uuid" where kmb.mitra_id = '731722100177' and kmb.kegiatan_uuid = '5eb43a40-40ea-11f0-aab0-e9b3119ef152' and kmp.status = 3

-- check history_assignment with spesific penugasan_uuid
select * from penugasan_history ph where ph.penugasan_uuid = '891711f0-40ee-11f0-aab0-e9b3119ef152' order by created_at ASC;