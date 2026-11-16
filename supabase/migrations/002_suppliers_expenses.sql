-- CRN PERFORMANCE — migration draft 002 (NOT DEPLOYED)
-- Requires reviewed 001_initial_schema.sql and a private Supabase project.
-- Expense tracking scoped to workshop; not a substitute for accounting.
create table if not exists public.suppliers (
 id uuid primary key default gen_random_uuid(),
 workshop_id uuid not null references public.workshops(id),
 name text not null,
 tax_id text,
 email text,
 phone text,
 created_at timestamptz not null default now(),
 unique(workshop_id,id)
);
create table if not exists public.expenses (
 id uuid primary key default gen_random_uuid(),
 workshop_id uuid not null references public.workshops(id),
 supplier_id uuid,
 repair_id uuid,
 expense_date date not null,
 category text not null,
 description text not null,
 amount_net numeric(12,2) not null check(amount_net>=0),
 vat_rate numeric(5,2) not null default 21 check(vat_rate in (0,4,10,21)),
 created_at timestamptz not null default now(),
 foreign key(workshop_id,supplier_id) references public.suppliers(workshop_id,id),
 foreign key(workshop_id,repair_id) references public.repair_orders(workshop_id,id)
);
create index if not exists expenses_workshop_date_idx on public.expenses(workshop_id,expense_date desc);
alter table public.suppliers enable row level security;
alter table public.expenses enable row level security;
create policy "supplier staff select" on public.suppliers for select to authenticated using(public.has_workshop_access(workshop_id));
create policy "supplier staff insert" on public.suppliers for insert to authenticated with check(public.has_workshop_access(workshop_id));
create policy "supplier staff update" on public.suppliers for update to authenticated using(public.has_workshop_access(workshop_id)) with check(public.has_workshop_access(workshop_id));
create policy "supplier staff delete" on public.suppliers for delete to authenticated using(public.has_workshop_access(workshop_id));
create policy "expense staff select" on public.expenses for select to authenticated using(public.has_workshop_access(workshop_id));
create policy "expense staff insert" on public.expenses for insert to authenticated with check(public.has_workshop_access(workshop_id));
create policy "expense staff update" on public.expenses for update to authenticated using(public.has_workshop_access(workshop_id)) with check(public.has_workshop_access(workshop_id));
create policy "expense staff delete" on public.expenses for delete to authenticated using(public.has_workshop_access(workshop_id));
-- Before production: security audit, role separation, and integration tests.
