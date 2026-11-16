-- CRN PERFORMANCE: alta inicial del propietario (ejecutar una sola vez tras 003)
-- Proyecto: geamekbwpocjbopfpowy
-- Usuario autorizado: 138a03be-1775-4d7f-b645-b7c481b61219
-- Ejecutar SOLO en SQL Editor del proyecto propio, nunca en el navegador público.
-- No crea usuarios ni contraseñas: exige que el usuario exista en auth.users.
do $$
declare
 owner_uid uuid := '138a03be-1775-4d7f-b645-b7c481b61219';
 new_workshop_id uuid;
begin
 if not exists (select 1 from auth.users where id=owner_uid) then
  raise exception 'No existe el usuario indicado en Authentication > Users';
 end if;
 if exists (select 1 from public.staff where user_id=owner_uid) then
  raise notice 'El usuario ya está asociado a un taller; no se crea otro';
  return;
 end if;
 insert into public.workshops(name) values ('CRN PERFORMANCE') returning id into new_workshop_id;
 insert into public.staff(user_id,workshop_id,role) values (owner_uid,new_workshop_id,'owner');
 raise notice 'CRN PERFORMANCE vinculado al usuario. ID del taller: %',new_workshop_id;
end $$;
-- Verificación (el SQL Editor es administrativo):
select w.name, w.id as workshop_id, s.user_id, s.role
from public.staff s join public.workshops w on w.id=s.workshop_id
where s.user_id='138a03be-1775-4d7f-b645-b7c481b61219';
