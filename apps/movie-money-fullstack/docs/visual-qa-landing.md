# QA visual — landing Movie Money

**Data:** 2026-08-06  
**Rotas:** `/`  
**Viewports:** 1440 × 900 e 390 × 844

A landing renderiza as treze seções na ordem planejada, sem overflow horizontal aparente. A composição desktop mantém o hero assimétrico, alterna blocos editoriais e módulos técnicos, e preserva contraste suficiente entre texto, fundo e CTAs. Os seis retratos e os dois vídeos reais carregam corretamente.

| Critério | Desktop | Mobile | Decisão |
|---|---|---|---|
| Hierarquia | Headline e porta-voz dominam o hero | Headline quebra sem recorte | Aprovado |
| Navegação | Links e CTA visíveis | Links secundários ocultos; CTA permanece | Aprovado |
| Treze seções | Ordem completa e ritmo consistente | Empilhamento correto | Aprovado |
| Elenco | Grade única com seis personagens | Grade de duas colunas | Aprovado |
| Masters em vídeo | Dois cards lado a lado | Cards empilhados | Aprovado |
| Formulário | Contraste e foco claros | Campos ocupam largura total | Aprovado |
| Overflow | Não observado | Não observado | Aprovado |

O sistema visual foi mantido deliberadamente restrito: cyan funciona como sinal de sistema e ação; magenta aparece em tensão, bordas e marcadores. Para evitar uma sequência de pôsteres idênticos, a página alterna headlines grandes com terminal, cards de formato, pipeline horizontal, mídia, prova operacional, FAQ e formulário.

A validação funcional do formulário e da página de oferta permanece pendente para a fase de testes ponta a ponta.

## Validação final integrada

Após mover o formulário para a seção 11, a landing continuou renderizando exatamente 13 blocos e a seção 13 passou a funcionar como CTA final distinto. O painel `/admin` foi validado em sessão autenticada com função administrativa: sidebar, métricas, busca, estado vazio e botão de exportação aparecem corretamente, sem exposição pública dos procedimentos. A rota `/oferta/invalido` mostra um estado de erro explícito e uma saída para a landing, eliminando a tela em branco.

O teste ponta a ponta da API criou um lead técnico temporário, retornou token hexadecimal de 64 caracteres, manteve o prazo original em um segundo cadastro do mesmo e-mail e confirmou `created: false` com delta de expiração igual a zero. O registro técnico foi removido ao final do teste.

Em 390 × 844, a landing preserva a ordem dos 13 blocos, apresenta o formulário antes do CTA final e não mostra overflow horizontal. O painel administrativo muda para navegação compacta no topo, empilha as quatro métricas, mantém o CSV acessível e usa cards para os leads em vez da tabela desktop.

A página de oferta ativa também foi validada com token real temporário: nome do lead, mensagem de persistência, contador com dias/horas/minutos/segundos e os dois cards de próximos passos renderizaram corretamente. O lead técnico usado nessa captura foi excluído imediatamente após a verificação.

A evidência complementar validou a oferta ativa em 390 × 844 e o painel `/admin` em sessão autenticada com função administrativa, tanto em desktop quanto em mobile, exibindo um lead técnico, métricas ativas, status LGPD, prazo restante, estado do e-mail e ação de exportação CSV. O registro técnico foi excluído após as capturas.

A identidade exibida no rodapé da sidebar durante as capturas foi confrontada com a tabela `users`; a consulta retornou a mesma identidade com `role = admin`. Os avisos `Missing session cookie` próximos no log pertencem às chamadas `curl` públicas usadas para criar os leads temporários, não às sessões do navegador que renderizaram o dashboard.
