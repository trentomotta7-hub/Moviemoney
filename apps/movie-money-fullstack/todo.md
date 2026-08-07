# Project TODO

- [x] Definir arquitetura full-stack, rotas públicas, rota administrativa e modelo de dados.
- [x] Criar tabela `leads` com nome, e-mail único, consentimento LGPD, timestamps, expiração da oferta, token de acesso e status do e-mail.
- [x] Gerar e aplicar migração MySQL via Drizzle ORM.
- [x] Implementar helper de banco para criar/atualizar lead sem reiniciar prazo existente, consultar oferta por token e listar leads.
- [x] Implementar procedimento público de captura de lead com validação Zod e consentimento LGPD obrigatório.
- [x] Calcular e persistir `offerExpiresAt` no servidor como cadastro + 72 horas.
- [x] Implementar consulta pública segura do countdown por token de acesso.
- [ ] Enviar e-mail de confirmação ao lead após cadastro, com link da oferta e resumo da contratação.
- [x] Notificar o proprietário a cada novo lead com nome, e-mail e timestamp.
- [x] Construir landing pública dark/glitch com exatamente 13 seções documentadas.
- [x] Implementar hero, proposta de valor, problema, mecanismo, elenco, processo, demonstração, diferenciais, prova social sem depoimentos inventados, oferta, FAQ, captura e CTA final.
- [x] Implementar formulário com nome, e-mail, checkbox LGPD obrigatório e estados de carregamento/sucesso/erro.
- [x] Implementar página de oferta com countdown individual resistente a recarga e calculado contra timestamp do servidor.
- [x] Proteger procedimentos administrativos com autenticação e `role=admin`.
- [x] Construir painel administrativo com listagem de leads, busca, métricas e status do countdown.
- [x] Implementar exportação CSV dos leads em procedimento administrativo protegido.
- [x] Cobrir backend e regras do countdown com testes Vitest.
- [x] Validar TypeScript, testes e build de produção.
- [x] Validar landing, oferta e painel em desktop e mobile por capturas visuais.
- [x] Atualizar documentação do projeto e registrar limitações operacionais da automação de e-mail.
- [ ] Configurar `RESEND_API_KEY` e `EMAIL_FROM` quando houver uma conta/remetente de e-mail disponível.
- [x] Salvar checkpoint final e entregar a versão da aplicação.
- [x] Inicializar a estrutura `.project-memory` e os templates do protocolo de continuidade.
- [x] Criar e preencher `ONBOARDING.md` como ponto único de retomada do projeto.
- [x] Documentar contexto atual, próximas ações e permissões de colaboração.
- [x] Criar um checkpoint timestampado que registre o estado atual da implementação full-stack.
- [x] Validar formalmente todos os arquivos obrigatórios do protocolo de continuidade.
- [x] Instalar a automação local de checkpoint por commit sem sobrescrever hooks existentes.
- [x] Separar explicitamente a captura da seção 11 e o CTA final da seção 13, mantendo exatamente 13 seções.
- [x] Tratar tokens de oferta inválidos com estado visível, sem tela em branco.
- [x] Capturar a oferta ativa em viewport mobile com token real temporário.
- [x] Capturar o painel autenticado com `role=admin` e um lead técnico visível em desktop e mobile.
- [x] Verificar no banco que a identidade exibida nas capturas do painel possui `role=admin`.
- [x] Registrar que os logs públicos sem cookie vieram dos testes `curl`, enquanto o navegador exibiu o dashboard autenticado completo.


## Melhorias visuais — site tecnológico e imersivo

- [x] Gerar imagens de fundo tecnológicas (cyberpunk/dark glitch) para parallax
- [x] Implementar efeito de parallax nas seções principais
- [x] Aumentar o tamanho da logo no header
- [x] Adicionar imagens de fundo com overlay nas seções
- [x] Melhorar transições e animações entre seções
- [x] Deixar o visual mais tecnológico e sofisticado

## Refinamento visual — orgânico e dinâmico

- [x] Trocar tipografia para fontes arredondadas (Outfit + Inter)
- [x] Arredondar bordas de todos os elementos (cards, botões, inputs, terminal)
- [x] Implementar parallax real e visível (movimento amplo ao rolar)
- [x] Suavizar transições e animações (curvas orgânicas)
- [x] Visual mais natural e menos rígido/quadrado

## Correções urgentes — feedback do usuário

- [x] Aumentar logo do header significativamente (h-12 → h-20, header h-18 → h-28)
- [x] Refazer headline: "Vídeos que vendem enquanto você dorme" + descrição focada em geração de vídeos sem precisar de tempo/equipe
- [x] Garantir parallax visível: speed 0.4→0.8, inset -15%→-25%, scale 1.1→1.15, overlay mais transparente

## Segunda rodada de correções — site mais convincente e parallax visível

- [x] Reescrever copy do hero e seções para ser mais convincente e impactante
- [x] Implementar parallax com movimento claramente visível ao rolar (background se move)
- [x] Adicionar elementos dinâmicos: gradientes animados, orbs flutuantes, transições
- [x] Tornar o site mais impactante e convincente no geral
