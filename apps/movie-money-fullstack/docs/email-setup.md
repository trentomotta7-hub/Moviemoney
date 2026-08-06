# Ativação do e-mail de confirmação

O fluxo de confirmação já está implementado em `server/email.ts`. Enquanto o provedor não estiver configurado, a captura do lead, o countdown, a oferta e a notificação ao proprietário continuam funcionando; o status do e-mail permanece `pending` e aparece dessa forma no painel administrativo.[1]

## Variáveis necessárias

| Variável | Finalidade | Exemplo de formato |
|---|---|---|
| `RESEND_API_KEY` | Autorizar o envio pela conta do provedor | `re_...` |
| `EMAIL_FROM` | Definir o remetente verificado | `Movie Money <contato@seudominio.com>` |

Esses valores devem ser cadastrados na área de **Secrets** do projeto gerenciado. Eles não devem ser gravados em `.env`, arquivos Markdown, código-fonte, commits ou mensagens públicas.

## Procedimento recomendado

1. Crie ou acesse uma conta no provedor de e-mail escolhido.
2. Verifique um domínio ou endereço de remetente.
3. Gere uma chave de API com permissão de envio.
4. Cadastre a chave como `RESEND_API_KEY` e o remetente como `EMAIL_FROM` na área de Secrets.
5. Reinicie o serviço e execute um cadastro controlado com um endereço autorizado.
6. Confirme no painel que o status mudou de `PENDING` para `SENT`.

## Comportamentos de segurança

| Situação | Resultado |
|---|---|
| Credenciais ausentes | Lead salvo; e-mail `pending` |
| Provedor retorna erro | Lead salvo; e-mail `failed` |
| Provedor aceita o envio | Lead salvo; e-mail `sent` e timestamp persistido |

O template do e-mail contém o nome do lead, o link individual da oferta e um resumo do escopo contratado. O conteúdo é sanitizado antes de ser inserido no HTML, e a cobertura automatizada verifica o fallback sem credenciais.[1] [2]

## References

[1]: ../server/email.ts "Implementação do serviço de e-mail"
[2]: ../server/email.test.ts "Testes do e-mail de confirmação"
