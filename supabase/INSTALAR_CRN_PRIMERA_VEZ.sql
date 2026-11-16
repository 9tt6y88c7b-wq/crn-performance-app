-- CRN PERFORMANCE: INSTALACION INICIAL EN PROYECTO NUEVO Y VACIO
-- Ejecutar UNA SOLA VEZ desde Supabase SQL Editor.
-- No contiene credenciales. Sin portal de clientes.

BEGIN;
-- CRN PERFORMANCE — ESQUEMA INICIAL LIMPIO (NO EJECUTADO)
-- Copiar al SQL Editor de un proyecto nuevo y vacío. Revisar antes de ejecutar.
-- Sin portal de clientes. RLS para usuario autenticado del taller.
-- Ejecutar exclusivamente en un proyecto privado Supabase, nunca en GitHub Pages.
create extension if not exists pgcrypto;
create table public.workshops (
 id uuid primary key default gen_random_uuid(),
 name text not null,
 created_at timestamptz not null default now()
);
create table public.staff (
 user_id uuid not null references auth.users(id) on delete cascade,
 workshop_id uuid not null references public.workshops(id) on delete cascade,
 role text not null default 'owner' check(role in ('owner','employee')),
 primary key(user_id,workshop_id)
);
create or replace function public.has_workshop_access(w uuid)
returns boolean language sql stable security definer set search_path = '' as $$
 select exists(select 1 from public.staff s where s.workshop_id=w and s.user_id=(select auth.uid()))
$$;
revoke all on function public.has_workshop_access(uuid) from public;
grant execute on function public.has_workshop_access(uuid) to authenticated;
create table public.customers (
 id uuid primary key default gen_random_uuid(),
 workshop_id uuid not null references public.workshops(id),
 name text not null,
 phone text,
 email text,
 tax_id text,
 address text,
 created_at timestamptz not null default now()
);
create table public.vehicles (
 id uuid primary key default gen_random_uuid(),
 workshop_id uuid not null references public.workshops(id),
 customer_id uuid not null references public.customers(id),
 plate text not null,
 model text not null,
 vin text,
 created_at timestamptz not null default now(),
 unique(workshop_id,plate)
);
create table public.repair_orders (
 id uuid primary key default gen_random_uuid(),
 workshop_id uuid not null references public.workshops(id),
 vehicle_id uuid not null references public.vehicles(id),
 description text not null,
 status text not null default 'Recepción',
 estimated_delivery date,
 created_at timestamptz not null default now()
);
create table public.repair_events (
 id uuid primary key default gen_random_uuid(),
 workshop_id uuid not null references public.workshops(id),
 repair_id uuid not null references public.repair_orders(id) on delete cascade,
 actor_id uuid references auth.users(id),
 event_type text not null,
 note text,
 created_at timestamptz not null default now()
);
create table public.quotes (
 id uuid primary key default gen_random_uuid(),
 workshop_id uuid not null references public.workshops(id),
 repair_id uuid not null references public.repair_orders(id),
 revision integer not null default 1,
 status text not null default 'borrador',
 created_at timestamptz not null default now()
);
create table public.quote_lines (
 id uuid primary key default gen_random_uuid(),
 workshop_id uuid not null references public.workshops(id),
 quote_id uuid not null references public.quotes(id) on delete cascade,
 category text not null check(category in ('Repuestos','Chapa','Pintura')),
 description text not null,
 quantity numeric(12,2) not null check(quantity>0),
 unit_price numeric(12,2) not null check(unit_price>=0),
 vat_rate numeric(5,2) not null default 21
);
create table public.invoice_drafts (
 id uuid primary key default gen_random_uuid(),
 workshop_id uuid not null references public.workshops(id),
 customer_id uuid references public.customers(id),
 source_quote_id uuid references public.quotes(id),
 draft_payload jsonb not null default '{}'::jsonb,
 created_at timestamptz not null default now()
);
create table public.appointments (
 id uuid primary key default gen_random_uuid(),
 workshop_id uuid not null references public.workshops(id),
 customer_id uuid references public.customers(id),
 date date not null,
 time time not null,
 reason text not null,
 done boolean not null default false
);
create table public.media (
 id uuid primary key default gen_random_uuid(),
 workshop_id uuid not null references public.workshops(id),
 repair_id uuid not null references public.repair_orders(id),
 storage_path text not null,
 stage text not null check(stage in ('antes','durante','despues')),
 shared_via_whatsapp_at timestamptz,
 created_at timestamptz not null default now()
);
-- No se crea portal de clientes.
-- Bloqueo predeterminado: RLS y políticas para cada tabla con datos del taller.
alter table public.workshops enable row level security;
alter table public.staff enable row level security;
create policy "staff can read own membership" on public.staff for select to authenticated using(user_id=(select auth.uid()));
create policy "staff can read own workshop" on public.workshops for select to authenticated using(public.has_workshop_access(id));
do $$
declare t text;
begin
 foreach t in array array['customers','vehicles','repair_orders','repair_events','quotes','quote_lines','invoice_drafts','appointments','media']
 loop
  execute format('alter table public.%I enable row level security',t);
  execute format('create policy "staff read" on public.%I for select to authenticated using (public.has_workshop_access(workshop_id))',t);
  execute format('create policy "staff insert" on public.%I for insert to authenticated with check (public.has_workshop_access(workshop_id))',t);
  execute format('create policy "staff update" on public.%I for update to authenticated using (public.has_workshop_access(workshop_id)) with check (public.has_workshop_access(workshop_id))',t);
  execute format('create policy "staff delete" on public.%I for delete to authenticated using (public.has_workshop_access(workshop_id))',t);
 end loop;
end $$;
-- Integridad por taller: impedir que una referencia apunte a datos de otro taller.
alter table public.customers add constraint customers_workshop_id_id_uq unique(workshop_id,id);
alter table public.vehicles add constraint vehicles_workshop_id_id_uq unique(workshop_id,id);
alter table public.repair_orders add constraint repair_orders_workshop_id_id_uq unique(workshop_id,id);
alter table public.quotes add constraint quotes_workshop_id_id_uq unique(workshop_id,id);
alter table public.vehicles add constraint vehicles_customer_same_workshop
 foreign key(workshop_id,customer_id) references public.customers(workshop_id,id);
alter table public.repair_orders add constraint repairs_vehicle_same_workshop
 foreign key(workshop_id,vehicle_id) references public.vehicles(workshop_id,id);
alter table public.repair_events add constraint events_repair_same_workshop
 foreign key(workshop_id,repair_id) references public.repair_orders(workshop_id,id);
alter table public.quotes add constraint quotes_repair_same_workshop
 foreign key(workshop_id,repair_id) references public.repair_orders(workshop_id,id);
alter table public.quote_lines add constraint quote_lines_same_workshop
 foreign key(workshop_id,quote_id) references public.quotes(workshop_id,id);
alter table public.invoice_drafts add constraint invoice_customer_same_workshop
 foreign key(workshop_id,customer_id) references public.customers(workshop_id,id);
alter table public.invoice_drafts add constraint invoice_quote_same_workshop
 foreign key(workshop_id,source_quote_id) references public.quotes(workshop_id,id);
alter table public.appointments add constraint appointment_customer_same_workshop
 foreign key(workshop_id,customer_id) references public.customers(workshop_id,id);
alter table public.media add constraint media_repair_same_workshop
 foreign key(workshop_id,repair_id) references public.repair_orders(workshop_id,id);
-- No existe portal ni tokens de acceso para clientes.

-- Almacenamiento privado de fotografías. No se permite acceso anónimo.
insert into storage.buckets (id,name,public,file_size_limit,allowed_mime_types)
values ('repair-photos','repair-photos',false,6291456,array['image/jpeg','image/png','image/webp'])
on conflict (id) do nothing;
create policy "workshop photo select" on storage.objects for select to authenticated
using (bucket_id='repair-photos' and exists (
 select 1 from public.staff s where s.user_id=(select auth.uid())
 and name like s.workshop_id::text || '/%'
));
create policy "workshop photo insert" on storage.objects for insert to authenticated
with check (bucket_id='repair-photos' and exists (
 select 1 from public.staff s where s.user_id=(select auth.uid())
 and name like s.workshop_id::text || '/%'
));
create policy "workshop photo delete" on storage.objects for delete to authenticated
using (bucket_id='repair-photos' and exists (
 select 1 from public.staff s where s.user_id=(select auth.uid())
 and name like s.workshop_id::text || '/%'
));
-- Para asociar al propietario, ejecutar DESPUÉS el script de alta de taller
-- con su UUID auth.users, mediante el editor administrativo, nunca desde el navegador público.

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

COMMIT;
