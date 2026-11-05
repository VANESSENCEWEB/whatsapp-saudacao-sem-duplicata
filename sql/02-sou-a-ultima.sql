-- =============================================
-- 02-sou-a-ultima.sql
-- Roda DEPOIS da espera de 30 segundos.
-- Pergunta: "a minha mensagem é a mais recente desta conversa?"
-- Parâmetros (enviados pelo n8n):
--   $1 = conversation_id (a conversa)
--   $2 = id da mensagem desta execução
-- =============================================

with marcadas as (
  -- Tenta marcar como "respondidas" as mensagens pendentes da conversa...
  update public.message_buffer b
     set processed = true
   where b.conversation_id = $1
     and b.processed = false
     -- ...MAS só se NÃO existir mensagem mais nova que a minha.
     -- Se existir, eu não sou a última: nada é marcado.
     and not exists (
       select 1
         from public.message_buffer n
        where n.conversation_id = $1
          and n.id > $2
     )
  returning b.id, b.content
)
-- Resultado: quantas mensagens EU marquei e o texto delas juntas.
--   total = 0 -> não sou a última, fico quieta
--   total > 0 -> sou a última, respondo uma vez só
select count(*)::int as total,
       coalesce(string_agg(content, ' | ' order by id), '') as mensagens
  from marcadas;

-- Por que isso é seguro?
-- O UPDATE é um comando único (atômico). Mesmo que várias execuções
-- perguntem no mesmo instante, o banco garante que só uma consegue
-- marcar as mensagens. As outras recebem total = 0.