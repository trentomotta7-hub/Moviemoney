# Contexto atual — Movie Money Full-Stack

**Última atualização:** 2026-08-06T01:55:47Z  
**Fase:** implementação e QA concluídos; configuração de e-mail pendente  
**Branch:** `main`

## Visão geral

Esta aplicação substitui a landing estática por uma arquitetura full-stack. A entrega possui treze seções públicas, captura de nome/e-mail/LGPD, countdown individual de 72 horas resistente a recarga, notificação ao proprietário e painel administrativo com CSV.[1]

## Estado técnico

| Área | Estado | Evidência |
|---|---|---|
| Arquitetura | Concluída | `docs/architecture.md` |
| Banco de leads | Concluído e migrado | `drizzle/schema.ts`, `drizzle/0001_acoustic_lorna_dane.sql` |
| Captura e oferta | Concluídas | `server/db.ts`, `server/routers.ts`, `client/src/pages/Offer.tsx` |
| Landing | Concluída | `client/src/pages/Home.tsx` |
| Painel admin | Concluído | `client/src/pages/Admin.tsx`, `server/csv.ts` |
| E-mail | Código pronto; credenciais pendentes | `server/email.ts`, `docs/email-setup.md` |
| Notificação do proprietário | Concluída | `notifyOwner` em `server/routers.ts` |
| Testes e build | Aprovados | 10 testes, TypeScript e build de produção |
| QA visual | Aprovado | `docs/visual-qa-landing.md` |

## Decisões que não devem regredir

O prazo é calculado apenas no servidor e não reinicia quando um e-mail existente é submetido novamente. O consentimento LGPD é obrigatório no contrato Zod. A oferta usa token opaco de 64 caracteres. Procedimentos administrativos usam `adminProcedure`, não proteção apenas visual. A prova social não contém avaliações, depoimentos ou números inventados.

## Como retomar

Leia `ONBOARDING.md`, o checkpoint mais recente e `next-actions.md`. Depois execute `git status`, `pnpm test`, `pnpm check` e `pnpm build`. A primeira pendência operacional é configurar `RESEND_API_KEY` e `EMAIL_FROM`; sem isso, não alterar a regra de fallback `pending`.

## Acessos e limites

O proprietário GitHub autorizado é `trentomotta7-hub`. Assets web permanecem no armazenamento gerenciado por URLs `/manus-storage/...`. Não adicione arquivos pesados ao diretório do projeto e não registre segredos no repositório.

## References

[1]: ../docs/architecture.md "Arquitetura da plataforma"
