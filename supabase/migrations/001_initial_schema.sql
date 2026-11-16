-- CRN PERFORMANCE / schema inicial de producción
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
 published_to_customer boolean not null default false,
 created_at timestamptz not null default now()
);
create table public.portal_tokens (
 id uuid primary key default gen_random_uuid(),
 workshop_id uuid not null references public.workshops(id),
 repair_id uuid not null references public.repair_orders(id),
 token_hash text not null unique,
 expires_at timestamptz not null,
 revoked_at timestamptz
);
-- Bloqueo predeterminado: RLS y políticas para cada tabla con datos del taller.
alter table public.workshops enable row level security;
alter table public.staff enable row level security;
create policy "staff can read own membership" on public.staff for select to authenticated using(user_id=(select auth.uid()));
create policy "staff can read own workshop" on public.workshops for select to authenticated using(public.has_workshop_access(id));
do $$
declare t text;
begin
 foreach t in array array['customers','vehicles','repair_orders','repair_events','quotes','quote_lines','invoice_drafts','appointments','media','portal_tokens']
 loop
  execute format('alter table public.%I enable row level security',t);
  execute format('create policy "staff read" on public.%I for select to authenticated using (public.has_workshop_access(workshop_id))',t);
  execute format('create policy "staff insert" on public.%I for insert to authenticated with check (public.has_workshop_access(workshop_id))',t);
  execute format('create policy "staff update" on public.%I for update to authenticated using (public.has_workshop_access(workshop_id)) with check (public.has_workshop_access(workshop_id))',t);
  execute format('create policy "staff delete" on public.%I for delete to authenticated using (public.has_workshop_access(workshop_id))',t);
 end loop;
end $$;
-- IMPORTANTE: endurecer referencias cruzadas entre workshop_id y claves foráneas
-- antes de insertar datos reales. Sin políticas públicas para portal_tokens.
-- El portal del cliente requiere una API de servidor que valide tokens por hash,
-- nunca acceso directo del navegador a esta tabla.
-- No se incluyen tablas de facturas emitidas: numeración fiscal requiere diseño
-- transaccional, controles de inmutabilidad y revisión normativa.
