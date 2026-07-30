# Checkpoint do Projeto Movie Money

**Última atualização:** 30 de julho de 2026

## Visão do Projeto

Movie Money é uma empresa/máquina de produção de criativos de venda para TikTok Shop e plataformas de venda via VSL. O fluxo de negócio: leads trazem um produto (com imagens vindas de site de mineração, contratado externamente) e a máquina monta automaticamente um vídeo de venda em um de dois formatos, tudo produzido dentro da Manus, sem ferramentas de terceiros.

Os dois formatos de criativo são: **POV** (câmera na altura dos olhos/ombro mostrando as mãos usando o produto enquanto narra os benefícios) e **UGC** (um dos 5 personagens do elenco falando sobre a experiência de uso, em tom de relato/venda invisível, com lip sync real).

Estrutura narrativa obrigatória de todo criativo: **Hook fortíssimo nos 4 segundos iniciais** (parar a rolagem) → **Problema** → **Causa** → **Solução** (apresentação do produto) → **CTA forte** no final. Os takes são divididos entre essas seções.

A empresa terá identidade visual própria no Instagram e no TikTok (em andamento — conceito escolhido: glitch estilo TikTok, fundo preto, cores ciano/magenta, monograma "MM"; 3 variações de logo geradas aguardando escolha do usuário em `identidade_visual/`).

A marca tem um **rosto oficial: o Beto** — avatar de IA do criador (que não quer aparecer pessoalmente). O Beto é o porta-voz institucional: apresenta a empresa, grava os vídeos de campanha/marketing e apresentará os 5 personagens ao público. Perfil completo em `references/elenco.md` (seção 0).

## Estado Atual — O Que Já Foi Feito

| Entrega | Status | Localização |
|---------|--------|-------------|
| Definição dos 5 personagens (nome, personalidade, tom de voz, nichos, hook-assinatura) | Concluído | `references/elenco.md` |
| Imagens-base oficiais dos 5 personagens (selfie UGC realista, 3:4) | Concluído | `templates/personagens/` |
| Banco de cenas: 4 cenários por personagem, 20 imagens 9:16 | Concluído | `templates/cenas/{lucas,marina,rafael,beatriz,diego}/` |
| Framework mestre de roteiros (estruturas, hooks, CTAs, transições, fórmulas, regras) | Concluído | `references/framework_roteiros.md` |
| Roteiros-exemplo completos (5 roteiros: 1 por personagem/formato/nicho + matriz de variação) | Concluído | `references/roteiros_exemplo.md` |
| Beto — rosto oficial da marca: perfil completo + imagem-base + frames de referência dos vídeos reais | Concluído | `references/elenco.md` (seção 0), `templates/personagens/beto.png`, `beto_ref1.jpg`, `beto_ref2.jpg` |
| Logo — 3 variações geradas a partir da referência do usuário (V1 glitch refinado, V2 play+money, V3 neon premium) | Aguardando escolha | projeto local `identidade_visual/` |

O elenco: Lucas Ferreira (27, tech/gadgets), Marina Costa (24, beleza/skincare), Rafael Santos (32, fitness/premium), Beatriz Oliveira (29, produtividade/casa), Diego Almeida (22, virais/unboxing). Detalhes completos em `references/elenco.md`.

## Próximos Passos Planejados (Backlog)

1. **Identidade visual da Movie Money:** usuário escolher variação do logo → expandir para kit completo (foto de perfil, capa, templates de post/grid, manual de marca com paleta oficial: preto + branco + ciano #25F4EE + magenta #FE2C55).
2. **Primeiro criativo de teste (prova da máquina):** rodar o pipeline completo de ponta a ponta com um produto real minerado.
3. **Pipeline/automação:** estrutura que recebe produto (link/imagens da mineração) e produz o vídeo final automaticamente.
4. **Sistema de captação de leads:** site/app da Movie Money.

## Decisões Já Tomadas (Não Rediscutir)

- Produção 100% dentro da Manus; única exceção é a mineração de produtos (site contratado).
- As imagens do produto vêm sempre do site de mineração — nunca pedir ao usuário para filmar ou fotografar nada.
- Vídeos com lip sync real gerados internamente (imagem do personagem + roteiro/áudio → vídeo).
- Formato vertical 9:16 para os vídeos (Reels/TikTok).
- Trabalhar em Português Brasileiro; personagens falam PT-BR.
