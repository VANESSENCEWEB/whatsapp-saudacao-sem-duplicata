
# Saudação sem duplicata no WhatsApp

Como resolvi o problema do chatbot de WhatsApp da Recife Flats Temporada, que mandava a mesma saudação várias vezes quando o hóspede escrevia rápido.

> Em construção: a documentação está sendo publicada aos poucos.





## O problema

Na Recife Flats Temporada, empresa de hospedagem por temporada em Recife, o chatbot de atendimento no WhatsApp (feito com n8n e Chatwoot) mandava uma mensagem de boas-vindas para cada hóspede novo.

Só que hóspede escreve assim:

> Oi
> tudo bem?
> cheguei

Três mensagens em poucos segundos. E o chatbot respondia **três vezes** a mesma saudação.

### Por que acontecia

Cada mensagem que chega dispara uma **execução separada** do fluxo no n8n. As três execuções rodam ao mesmo tempo, e todas perguntam: "já mandei boas-vindas para essa pessoa?". Como nenhuma terminou ainda, as três ouvem "não", e as três respondem.

É como três atendentes ouvindo o mesmo telefone tocar e atendendo juntos, porque nenhum viu o outro levantar.

O nome técnico disso é **condição de corrida** (*race condition*): o resultado depende de quem termina primeiro, e ninguém está coordenando.