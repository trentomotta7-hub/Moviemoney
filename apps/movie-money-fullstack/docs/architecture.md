# Arquitetura — Movie Money Full-Stack

## Visão geral

A aplicação utiliza **React 19 + Tailwind CSS 4** no cliente, **Express + tRPC** no servidor e **MySQL com Drizzle ORM** para persistência. A landing e a página de oferta são públicas; o painel administrativo usa a autenticação Manus OAuth já fornecida pelo template e exige `role = admin` em toda operação sensível.

| Camada | Responsabilidade | Tecnologia |
|---|---|---|
| Cliente público | Landing, formulário e countdown da oferta | React, Wouter, tRPC, Tailwind |
| Cliente administrativo | Listagem, busca, métricas e exportação | React, DashboardLayout, tRPC |
| API | Validação, regras de negócio e autorização | Express, tRPC, Zod |
| Persistência | Leads, consentimento e prazo individual | MySQL, Drizzle ORM |
| Automação | Confirmação ao lead e alerta operacional | Resend REST e `notifyOwner` |

## Rotas de interface

| Rota | Acesso | Finalidade |
|---|---|---|
| `/` | Público | Landing dark/glitch de 13 seções e captura de lead |
| `/oferta/:token` | Público com token opaco | Oferta individual e countdown persistido no servidor |
| `/admin` | Autenticado, somente `admin` | Painel de leads, métricas, status e exportação CSV |

## Contratos tRPC

| Procedimento | Acesso | Regra principal |
|---|---|---|
| `leads.capture` | Público | Exige nome, e-mail válido e consentimento LGPD; cria prazo de 72 h no servidor |
| `leads.offer` | Público | Resolve token opaco e retorna somente dados necessários à oferta |
| `admin.leads` | Admin | Lista leads, timestamps e status calculado da oferta |
| `admin.exportCsv` | Admin | Gera CSV em memória para download autenticado |

## Modelo de dados inicial

| Campo | Tipo lógico | Regra |
|---|---|---|
| `id` | inteiro | Chave primária autoincremental |
| `name` | texto curto | Obrigatório, normalizado no servidor |
| `email` | e-mail | Obrigatório e único em formato normalizado |
| `lgpdConsent` | booleano | Deve ser verdadeiro para persistência |
| `lgpdConsentedAt` | timestamp UTC | Registrado no servidor |
| `accessToken` | token opaco | Único, usado na URL pública da oferta |
| `offerExpiresAt` | timestamp UTC | Definido como criação + 72 horas; não é recalculado em recargas |
| `emailStatus` | enum | `pending`, `sent` ou `failed` |
| `emailSentAt` | timestamp UTC opcional | Preenchido após confirmação do provedor |
| `createdAt` / `updatedAt` | timestamp UTC | Auditoria do registro |

## Regras de negócio

O servidor é a única autoridade sobre o prazo. Em um cadastro novo, `offerExpiresAt` é calculado a partir do relógio do servidor. Se o mesmo e-mail for submetido novamente, os dados podem ser atualizados, mas o prazo original não é reiniciado. A interface calcula a exibição regressiva comparando `offerExpiresAt` com `serverNow`, ambos retornados pela API.

O consentimento LGPD é obrigatório e recebe timestamp próprio. O painel nunca fica disponível apenas por ocultação de interface: todos os procedimentos administrativos verificam sessão e `role = admin` no servidor. A exportação CSV é gerada somente após essa mesma verificação.

O envio ao lead é feito pelo servidor após a persistência. Falhas do provedor não desfazem o cadastro; elas são registradas em `emailStatus`. A notificação ao proprietário é disparada para cada lead recém-criado e inclui somente nome, e-mail e timestamp.
