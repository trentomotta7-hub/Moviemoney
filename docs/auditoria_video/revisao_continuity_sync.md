# Revisão da skill Continuity Sync

O pacote recebido possui estrutura válida (`SKILL.md` e `scripts/sync.py`) e passou na validação formal. Entretanto, a versão original não foi executada diretamente porque combinava `shell=True`, `git add .`, commit e push automáticos. Esse comportamento poderia incluir arquivos não relacionados, masters pesados, artefatos temporários ou segredos presentes no checkout.

Foi instalada uma versão revisada em `/home/ubuntu/skills/continuity-sync/` com as seguintes salvaguardas:

| Salvaguarda | Comportamento |
|---|---|
| Prévia padrão | Nenhum arquivo é escrito, commitado ou enviado sem flags explícitas |
| Staging restrito | Somente `CONTEXT.md`, `CHANGELOG.md` e caminhos fornecidos em `--include` |
| Bloqueio de segredos | Impede `.env`, chaves, certificados e nomes comuns de credenciais |
| Limite de tamanho | Reprova arquivos incluídos acima do limite configurado |
| Subprocessos seguros | Executa comandos com argumentos separados e `shell=False` |
| Ações separadas | `--write`, `--commit` e `--push` precisam ser solicitados em sequência |
| Verificação de remoto | Push falha explicitamente se `origin` não estiver configurado |

A versão revisada passou em compilação Python, validação estrutural e teste de prévia no repositório Movie Money. O teste confirmou que nenhum arquivo foi escrito, nenhum commit foi criado e nenhum push foi executado.
