-- =============================================
-- 01-tabela.sql
-- Cria a "sala de espera" das mensagens
-- antes do chatbot responder.
-- =============================================

create table if not exists public.message_buffer (
  id              bigserial primary key,               -- número único e crescente: quem chegou depois tem id maior
  conversation_id bigint not null,                     -- de qual conversa é a mensagem
  content         text,                                -- o texto que o hóspede mandou
  created_at      timestamptz not null default now(),  -- quando chegou
  processed       boolean not null default false       -- já foi respondida? começa como "não"
);

-- Índice: deixa rápida a busca "mensagens desta conversa, em ordem"
create index if not exists message_buffer_conv_idx
  on public.message_buffer (conversation_id, id);

-- Segurança: liga o RLS (Row Level Security).
-- Sem nenhuma política criada, ninguém consegue ler ou escrever
-- usando a chave pública do Supabase. Só o servidor (n8n) acessa.
alter table public.message_buffer enable row level security;