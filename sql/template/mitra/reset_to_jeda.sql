select * from penugasan_history ph where ph.penugasan_uuid = 'de4b2320-7341-11f0-8972-2f5cba8c25b0' order by ph.created_at desc


update penugasan_history set status = '2' where uuid in (select ph."uuid"  from penugasan_history ph where ph.penugasan_uuid = 'de4b2320-7341-11f0-8972-2f5cba8c25b0' order by ph.created_at desc limit 1) 