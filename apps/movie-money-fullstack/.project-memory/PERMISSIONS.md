# Permissões do projeto

**Última atualização:** 2026-08-06T01:35:11Z

## Matriz de acesso

| Papel | Identidade | Permissões documentadas |
|---|---|---|
| Proprietário GitHub | `trentomotta7-hub` | Administração do repositório, merge, colaboradores e configurações |
| Proprietária do projeto web | Giovanna | Aprovação funcional, publicação e gestão de configurações no ambiente Manus |
| Agente de desenvolvimento autorizado | Manus, dentro desta tarefa | Ler, editar, testar, versionar e documentar o projeto conforme o pedido atual |
| Colaborador futuro | Somente por convite do proprietário | Branch própria e pull request, sem acesso automático a segredos |
| Público | Conforme visibilidade configurada pelo proprietário | Nenhuma permissão adicional é presumida |

## Regras de colaboração

Alterações significativas usam Conventional Commits e atualizam um checkpoint. Branches seguem `feature/`, `bugfix/`, `docs/` ou `chore/`. Mudanças em schema exigem migração revisada antes da aplicação. Rotas administrativas exigem autorização no servidor. Segredos devem ser configurados pelo mecanismo de ambiente do projeto e nunca incluídos em commits.

## Aprovações sensíveis

Publicação, pagamentos, alteração de domínio, inclusão ou remoção de colaboradores e operações destrutivas no banco dependem de ação ou confirmação explícita da proprietária. O agente pode preparar código e checkpoints, mas não deve publicar a aplicação diretamente.

## Processo para novos colaboradores

O proprietário adiciona o usuário no GitHub, define o nível mínimo necessário e registra a alteração neste arquivo. O colaborador deve ler `ONBOARDING.md`, o checkpoint mais recente e `CONTINUITY_PROTOCOL.md` antes do primeiro commit.
