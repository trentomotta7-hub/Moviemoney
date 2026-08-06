# Movie Money — Plataforma Full-Stack de Aquisição

Aplicação pública e administrativa da Movie Money para captação de lojistas, entrega de uma oferta individual com prazo persistente e operação dos leads. A versão atual inclui landing dark/glitch de 13 seções, formulário LGPD, countdown de 72 horas calculado no servidor, notificação ao proprietário e dashboard administrativo com CSV.[1] [2]

## Estado da entrega

| Componente | Estado | Observação |
|---|---|---|
| Landing pública | Concluída | Treze seções, assets oficiais e dois criativos reais |
| Captura de leads | Concluída | Nome, e-mail e consentimento LGPD obrigatório |
| Countdown | Concluído | Prazo persistido no servidor e preservado em recadastros |
| Página de oferta | Concluída | Acesso por token opaco e estados ativo, expirado e inválido |
| Notificação ao proprietário | Concluída | Novo lead com identidade e timestamp |
| Painel administrativo | Concluído | Autorização por `role=admin`, métricas, busca e CSV |
| Confirmação por e-mail | Código concluído; configuração externa pendente | Requer `RESEND_API_KEY` e `EMAIL_FROM` |

## Rotas

| Rota | Acesso | Finalidade |
|---|---|---|
| `/` | Público | Landing e formulário de captura |
| `/oferta/:token` | Público com token | Oferta individual e countdown |
| `/admin` | Sessão autenticada com `role=admin` | Operação dos leads e exportação CSV |

## Stack e estrutura

O frontend usa React 19, Tailwind CSS 4 e Wouter. O backend usa Express, tRPC e Zod. A persistência usa MySQL com Drizzle ORM, e a autenticação administrativa usa o OAuth e as funções do template gerenciado.[1]

| Caminho | Responsabilidade |
|---|---|
| `client/src/pages/Home.tsx` | Landing e formulário LGPD |
| `client/src/pages/Offer.tsx` | Oferta individual e countdown |
| `client/src/pages/Admin.tsx` | Dashboard administrativo |
| `server/routers.ts` | Contratos públicos e administrativos |
| `server/db.ts` | Persistência de usuários e leads |
| `server/email.ts` | Confirmação por e-mail e fallback seguro |
| `drizzle/schema.ts` | Modelo de dados |
| `shared/lead.ts` | Regras puras de token e prazo |
| `.project-memory/` | Continuidade, contexto e checkpoints |

## Desenvolvimento

```bash
pnpm install
pnpm dev
```

Antes de qualquer entrega, execute:

```bash
pnpm test
pnpm check
pnpm build
```

A suíte atual possui 10 testes cobrindo autorização administrativa, CSV seguro, e-mail, logout, token e prazo de 72 horas. O teste ponta a ponta também confirmou que um recadastro preserva o timestamp original de expiração.[2]

## Banco de dados

O schema está em `drizzle/schema.ts`. Alterações devem seguir o fluxo schema-first: gerar a migração com Drizzle, revisar o SQL e aplicá-lo pelo mecanismo gerenciado. A migração da tabela `leads` já foi aplicada ao banco do projeto.[1]

## Confirmação por e-mail

Sem credenciais, a captura continua funcional e o lead recebe `emailStatus = pending`; nenhum segredo é incluído no repositório. Para ativar o envio real, siga [`docs/email-setup.md`](docs/email-setup.md).

## Continuidade

Toda retomada começa por [`ONBOARDING.md`](ONBOARDING.md), seguida do checkpoint mais recente em `.project-memory/checkpoints/` e de `.project-memory/next-actions.md`. O hook versionado em `.githooks/pre-commit` cria um registro de continuidade para commits significativos.[3]

## References

[1]: docs/architecture.md "Arquitetura da plataforma Movie Money"
[2]: docs/visual-qa-landing.md "Registro de QA visual e funcional"
[3]: .project-memory/CONTINUITY_PROTOCOL.md "Protocolo de continuidade"
