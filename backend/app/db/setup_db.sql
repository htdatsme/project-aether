-- Enable the vector extension
create extension if not exists vector;

-- Create the scent_profiles table (The Vault)
create table if not exists scent_profiles (
  id uuid primary key default gen_random_uuid(),
  brand text not null,
  name text not null,
  description text not null,
  embedding vector(768) -- Matches Vertex AI text-embedding-004 dimensions
);

-- Create the truth_labels table (The Moat)
create table if not exists truth_labels (
  id uuid primary key default gen_random_uuid(),
  user_vibe vector(768),
  revealed_scent_id uuid references scent_profiles(id),
  timestamp timestamptz default now()
);
