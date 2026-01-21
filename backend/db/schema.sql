-- Enable the pgvector extension to work with embedding vectors
create extension if not exists vector;

-- Table A: scent_profiles (The Inventory)
create table if not exists scent_profiles (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  brand text not null,
  description text,
  embedding vector(768),
  metadata jsonb default '{}'::jsonb,
  created_at timestamptz default now()
);

-- Table B: vibe_logs (The R&D Asset)
create table if not exists vibe_logs (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users not null,
  input_prompt text,
  output_scent_ids uuid[] default '{}',
  timestamp timestamptz default now()
);

-- Security (RLS)
alter table scent_profiles enable row level security;
alter table vibe_logs enable row level security;

-- Policy: Public Read access to scent_profiles
create policy "Allow public read access"
  on scent_profiles for select
  using ( true );

-- Policy: Authenticated Users can INSERT into vibe_logs
create policy "Allow authenticated insert"
  on vibe_logs for insert
  to authenticated
  with check ( true );

-- Optional: Policy for users to read their own logs (if needed later)
-- create policy "Users can see their own logs"
--   on vibe_logs for select
--   to authenticated
--   using ( auth.uid() = user_id );
