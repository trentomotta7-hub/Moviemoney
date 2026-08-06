# Movie Money — Contexto Atual do Projeto

> **LEIA ESTE ARQUIVO PRIMEIRO ao iniciar qualquer nova sessão.**

## Identificação

| Campo | Valor |
|---|---|
| **Projeto** | Movie Money — Criativos que Vendem no TikTok Shop |
| **Repositório** | `trentomotta7-hub/Moviemoney` |
| **Branch ativa** | `master` |
| **Última sessão** | Sessão 17 — 06/08/2026 |
| **Aplicação full-stack** | `apps/movie-money-fullstack/` |
| **Checkpoint web gerenciado** | `4132e698` |

## Estado consolidado

| Entrega | Estado | Evidência |
|---|---|---|
| Vídeo 1 — Quebrando Mitos | Concluído | `skill-movie-money/criativos/video_institucional_youtube/` |
| Vídeo 2 — A Máquina por Dentro | Concluído | `skill-movie-money/criativos/video_institucional_youtube/` |
| POV Sunscreen Stick v2 | Master reconstruído | `skill-movie-money/criativos/sunscreen_stick_spf/POV/montagem/` |
| Matriz POV A/B | Pipeline e matriz 5 × 4 preparados; vídeos ainda não gerados | `skill-movie-money/criativos/sunscreen_stick_spf/POV/matriz_ab/` |
| GC Sunscreen Stick v6 | Master com áudio nativo e QA técnico concluído | `skill-movie-money/criativos/sunscreen_stick_spf/GC/montagem_v6/` |
| Vídeo 3 — A Oferta | Roteiro expandido e áudio-base de aproximadamente 5 minutos; abaixo do alvo de 8–12 minutos | `skill-movie-money/criativos/video_institucional_youtube/VSL_Beto/` |
| Landing full-stack | Concluída e validada em desktop/mobile | `apps/movie-money-fullstack/client/src/pages/Home.tsx` |
| Backend de leads | Concluído e migrado para MySQL | `apps/movie-money-fullstack/server/`, `drizzle/` |
| Countdown de 72 horas | Concluído, persistente e resistente a recadastro | `apps/movie-money-fullstack/shared/lead.ts` |
| Painel administrativo | Concluído, protegido por `role=admin`, com CSV | `apps/movie-money-fullstack/client/src/pages/Admin.tsx` |
| E-mail de confirmação | Código pronto; envio real bloqueado por credenciais externas | `apps/movie-money-fullstack/docs/email-setup.md` |

## Verificações da aplicação

A aplicação full-stack passou em 10 testes Vitest, checagem TypeScript, build de produção, teste ponta a ponta de cadastro/recadastro e QA visual das rotas `/`, `/oferta/:token` e `/admin`. O checkpoint gerenciado entregável é `manus-webdev://4132e698`.

## Decisões que não devem regredir

O prazo da oferta é calculado no servidor e não reinicia para um e-mail já cadastrado. O consentimento LGPD é obrigatório. Tokens de oferta são opacos e não expõem o e-mail do lead. Rotas administrativas usam autorização server-side. A prova social da landing não contém avaliações, depoimentos ou números inventados. Assets web permanecem no armazenamento gerenciado, não no bundle local.

## Como retomar

Leia o checkpoint mais recente em `.project-memory/checkpoints/` e `.project-memory/next-actions.md`. Para a aplicação, entre em `apps/movie-money-fullstack/` e execute `pnpm install`, `pnpm test`, `pnpm check` e `pnpm build`. Para audiovisual, siga a skill em `skill-movie-money/skills/moviemoney-production/` e preserve o protocolo forense.

## Bloqueios externos

O envio real de confirmação depende de `RESEND_API_KEY` e `EMAIL_FROM`. Sem essas variáveis, o lead é salvo normalmente e o painel registra o e-mail como `PENDING`. A publicação da aplicação deve ser feita pelo proprietário no botão **Publish** da interface gerenciada.
