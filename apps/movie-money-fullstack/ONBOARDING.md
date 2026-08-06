# Movie Money Full-Stack — Onboarding

**Última atualização:** 2026-08-06T01:55:47Z  
**Repositório de produto:** [trentomotta7-hub/Moviemoney](https://github.com/trentomotta7-hub/Moviemoney)  
**Projeto web gerenciado:** `movie-money-fullstack`

## Início rápido

1. Leia este arquivo por inteiro.
2. Abra o checkpoint mais recente em `.project-memory/checkpoints/`, ignorando `TEMPLATE.md`.
3. Leia `.project-memory/current-context.md` e `.project-memory/next-actions.md`.
4. Execute `pnpm install`, `pnpm test`, `pnpm check` e `pnpm build` antes de alterar código.
5. Retome a primeira ação incompleta de maior prioridade.

## Visão do produto

Movie Money é uma plataforma de aquisição para lojistas de TikTok Shop e e-commerce. A aplicação entrega uma landing pública dark/glitch, captura leads com consentimento LGPD, persiste uma oferta individual de 72 horas no servidor e fornece um painel administrativo autenticado.[1]

| Camada | Tecnologia | Local principal |
|---|---|---|
| Interface | React 19, Tailwind CSS 4, Wouter | `client/src/` |
| API | Express, tRPC, Zod | `server/` |
| Persistência | MySQL, Drizzle ORM | `drizzle/`, `server/db.ts` |
| Autenticação | Manus OAuth e `role=admin` | `server/_core/` |
| Continuidade | Checkpoints e contexto versionado | `.project-memory/` |

## Rotas entregues

| Rota | Acesso | Objetivo |
|---|---|---|
| `/` | Público | Landing de 13 seções e formulário LGPD |
| `/oferta/:token` | Público com token opaco | Oferta e countdown individual persistido |
| `/admin` | Usuário autenticado com `role=admin` | Leads, métricas e exportação CSV |

## Estado atual

A landing, a captura, a oferta, o countdown, a notificação ao proprietário e o painel administrativo estão implementados e validados em desktop e mobile. TypeScript, os 10 testes Vitest e o build de produção passam. O teste ponta a ponta confirmou o prazo persistente e o reaproveitamento do token sem reiniciar 72 horas.[2]

O único bloqueio externo é o envio real da confirmação por e-mail. O serviço e o template estão prontos, mas dependem de `RESEND_API_KEY` e `EMAIL_FROM`; enquanto ausentes, o cadastro permanece funcional e registra o envio como `pending`. Consulte `docs/email-setup.md`.

## Regras de contribuição

Use branches `feature/*`, `bugfix/*` ou `docs/*` quando trabalhar fora da branch principal. Mensagens de commit seguem Conventional Commits. Todo commit significativo deve incluir ou atualizar um checkpoint; nunca registre segredos, tokens ou dados pessoais reais no Git.

## Handoff

O produto está pronto para revisão do proprietário e publicação pela interface gerenciada. A próxima ação técnica é configurar as duas variáveis de e-mail e repetir um cadastro controlado. Depois, o proprietário pode usar o botão **Publish** e, se desejar, configurar um domínio na área de Settings.

Consulte `.project-memory/CONTINUITY_PROTOCOL.md` para o fluxo operacional completo e `.project-memory/PERMISSIONS.md` para as regras de acesso.

## References

[1]: docs/architecture.md "Arquitetura da plataforma"
[2]: docs/visual-qa-landing.md "Validação visual e funcional"
