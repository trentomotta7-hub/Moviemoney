# Checkpoint — Landing e operação full-stack concluídas

**Data:** 2026-08-06T01:55:47Z  
**Status:** Concluído com configuração externa de e-mail pendente

## O que foi entregue

A plataforma Movie Money foi implementada em React, tRPC e MySQL. A landing pública possui 13 seções dark/glitch e assets oficiais. O formulário exige consentimento LGPD, cria ou reutiliza o lead, persiste a expiração de 72 horas no servidor e retorna um token individual. A oferta resiste a recargas e trata links inválidos ou expirados.

O painel `/admin` usa autorização server-side por `role=admin`, apresenta métricas, busca, status LGPD, prazo restante, estado de e-mail e exportação CSV protegida. O backend também notifica o proprietário a cada novo cadastro.

## Assets produzidos ou modificados

| Asset | Arquivo | Estado |
|---|---|---|
| Landing | `client/src/pages/Home.tsx` | Concluído |
| Oferta | `client/src/pages/Offer.tsx` | Concluído |
| Painel | `client/src/pages/Admin.tsx` | Concluído |
| API | `server/routers.ts` | Concluído |
| Persistência | `server/db.ts`, `drizzle/schema.ts` | Concluído e migrado |
| E-mail | `server/email.ts` | Código concluído; credenciais pendentes |
| CSV | `server/csv.ts` | Concluído |
| Regras compartilhadas | `shared/lead.ts` | Concluído |
| Testes | `server/*.test.ts`, `shared/lead.test.ts` | 10 aprovados |
| QA | `docs/visual-qa-landing.md` | Desktop, mobile e ponta a ponta aprovados |

## Verificações

| Verificação | Resultado |
|---|---|
| `pnpm test` | 5 arquivos e 10 testes aprovados |
| `pnpm check` | Sem erros TypeScript |
| `pnpm build` | Build de produção concluído |
| Recadastro | Mesmo token e delta de expiração igual a zero |
| Oferta ativa | Validada em desktop e mobile |
| Admin autenticado | Validado em desktop e mobile com lead temporário |
| Higiene de dados | Todos os leads de QA removidos após as capturas |

## Decisões-chave

O countdown continua sendo uma regra de servidor. E-mails repetidos não reiniciam o prazo. A camada pública nunca expõe o e-mail do lead na consulta da oferta. A exportação CSV neutraliza fórmulas de planilha. O envio de e-mail falha de forma segura e não impede a captura.

## Limitação conhecida

O e-mail real não é enviado até o proprietário configurar `RESEND_API_KEY` e `EMAIL_FROM`. Enquanto isso, o painel registra `PENDING`; captura, oferta, countdown e notificação ao proprietário permanecem operacionais. O build também informa um aviso não bloqueante de chunk principal acima de 500 kB, que pode ser otimizado futuramente com divisão de código.

## Próximas ações

- [ ] Configurar as credenciais de e-mail conforme `docs/email-setup.md`.
- [ ] Executar um cadastro controlado e confirmar o status `SENT`.
- [ ] Revisar e publicar pela interface gerenciada quando aprovado.
