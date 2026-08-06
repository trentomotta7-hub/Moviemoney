# Checkpoint — Base full-stack e protocolo de continuidade

**Data:** 2026-08-06T01:35:11Z  
**Status:** Em progresso

## O que foi feito

A base full-stack foi inicializada com React, tRPC, MySQL e autenticação. O modelo `leads` e sua migração foram criados e aplicados. O backend já captura ou reaproveita leads sem reiniciar a oferta, calcula 72 horas no servidor, expõe consulta por token, prepara o e-mail de confirmação e notifica o proprietário em cadastros novos.

O protocolo de continuidade foi inicializado e seus documentos foram preenchidos com o estado real, as permissões autorizadas, as decisões de segurança e a sequência de retomada.

## Assets produzidos ou modificados

| Asset | Arquivo | Estado |
|---|---|---|
| Arquitetura | `docs/architecture.md` | Concluído |
| Schema e migração | `drizzle/schema.ts`, `drizzle/0001_acoustic_lorna_dane.sql` | Aplicado |
| Persistência e API pública | `server/db.ts`, `server/routers.ts` | Implementado |
| E-mail | `server/email.ts`, `server/email.test.ts` | Implementado com fallback pendente |
| Memória operacional | `.project-memory/` e `ONBOARDING.md` | Inicializada e preenchida |

## Decisões-chave

| Decisão | Justificativa |
|---|---|
| Prazo armazenado em milissegundos UTC | Evita depender do fuso ou relógio do cliente |
| Reenvio do mesmo e-mail não reinicia prazo | Preserva urgência individual e resistência a recarga |
| Prova social somente com evidência real | Evita conteúdo enganoso e depoimentos fabricados |
| E-mail sem credencial fica `pending` | Mantém captura funcional sem simular uma entrega inexistente |
| Assets pesados ficam no storage gerenciado | Evita falhas de deploy e mantém o projeto leve |

## Problemas conhecidos

O envio real de confirmação está bloqueado até a configuração de `RESEND_API_KEY` e `EMAIL_FROM`. A landing, a página de oferta e o painel administrativo ainda não foram finalizados, portanto este checkpoint não representa uma versão pronta para publicação.

## Próximas ações

- [ ] Implementar a landing de 13 seções e o formulário.
- [ ] Implementar a página individual de oferta.
- [ ] Implementar painel admin e CSV.
- [ ] Validar testes, build e layouts responsivos.
