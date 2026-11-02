create table if not exists public.tasks (
 id uuid primary key default gen_random_uuid(),
 user_id uuid not null references auth.users(id) on delete cascade,
 title text not null,
 description text not null default '',
 due_date date,
 priority text not null default 'medium' check(priority in ('low','medium','high')),
 status text not null default 'pending' check(status in ('pending','inprogress','completed')),
 created_at timestamptz not null default now(),
 updated_at timestamptz not null default now()
);
create index if not exists tasks_user_id_idx on public.tasks(user_id);
alter table public.tasks enable row level security;
drop policy if exists "Users can view their own tasks" on public.tasks;
create policy "Users can view their own tasks" on public.tasks for select to authenticated using ((select auth.uid())=user_id);
drop policy if exists "Users can insert their own tasks" on public.tasks;
create policy "Users can insert their own tasks" on public.tasks for insert to authenticated with check ((select auth.uid())=user_id);
drop policy if exists "Users can update their own tasks" on public.tasks;
create policy "Users can update their own tasks" on public.tasks for update to authenticated using ((select auth.uid())=user_id) with check ((select auth.uid())=user_id);
drop policy if exists "Users can delete their own tasks" on public.tasks;
create policy "Users can delete their own tasks" on public.tasks for delete to authenticated using ((select auth.uid())=user_id);
grant select,insert,update,delete on public.tasks to authenticated;