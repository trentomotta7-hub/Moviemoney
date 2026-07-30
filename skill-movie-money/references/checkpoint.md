# Checkpoint do Projeto Movie Money

**Última atualização:** 30 de julho de 2026 — Sessão 5

## Visão do Projeto

Movie Money é uma empresa/máquina de produção de criativos de venda para TikTok Shop e plataformas de venda via VSL. O fluxo de negócio: leads trazem um produto (com imagens vindas de site de mineração, contratado externamente) e a máquina monta automaticamente um vídeo de venda em um de dois formatos, tudo produzido dentro da Manus, sem ferramentas de terceiros.

Os dois formatos de criativo são: **POV** (câmera na altura dos olhos/ombro mostrando as mãos usando o produto enquanto narra os benefícios) e **UGC** (um dos 5 personagens do elenco falando sobre a experiência de uso, em tom de relato/venda invisível, com lip sync real).

Estrutura narrativa obrigatória de todo criativo: **Hook fortíssimo nos 4 segundos iniciais** (parar a rolagem) → **Problema** → **Causa** → **Solução** (apresentação do produto) → **CTA forte** no final. Os takes são divididos entre essas seções.

Identidade visual definida: glitch estilo TikTok, fundo preto, cores ciano #25F4EE / magenta #FE2C55, monograma "MM" com botão play entre as letras, tagline "Criativos que vendem no TikTok Shop". Kit em `templates/identidade_visual/` (logo_final.png, perfil_icone.png redondo, capa_banner.png 16:9).

A marca tem um **rosto oficial: o Beto** — avatar de IA do criador (que não quer aparecer pessoalmente). O Beto é o porta-voz institucional: apresenta a empresa, grava os vídeos de campanha/marketing e apresentará os 5 personagens ao público. Perfil completo em `references/elenco.md` (seção 0).

## Estado Atual — O Que Já Foi Feito

| Entrega | Status | Localização |
|---------|--------|-------------|
| Definição dos 5 personagens (nome, personalidade, tom de voz, nichos, hook-assinatura) | ✅ Concluído | `references/elenco.md` |
| Imagens-base oficiais dos 5 personagens (selfie UGC realista, 3:4) | ✅ Concluído | `templates/personagens/` |
| Banco de cenas: 4 cenários por personagem, 20 imagens 9:16 | ✅ Concluído | `templates/cenas/{lucas,marina,rafael,beatriz,diego}/` |
| Framework mestre de roteiros (estruturas, hooks, CTAs, transições, fórmulas, regras) | ✅ Concluído | `references/framework_roteiros.md` |
| Roteiros-exemplo completos (5 roteiros: 1 por personagem/formato/nicho + matriz de variação) | ✅ Concluído | `references/roteiros_exemplo.md` |
| Beto — rosto oficial da marca: perfil completo + imagem-base + frames de referência | ✅ Concluído | `references/elenco.md` (seção 0), `templates/personagens/beto.png`, `beto_ref1.jpg`, `beto_ref2.jpg` |
| Kit de identidade visual: logo final, ícone de perfil (avatar redondo), capa/banner 16:9 | ✅ Concluído | `templates/identidade_visual/` |
| Vozes oficiais dos 6 personagens (Beto + 5 UGC): mapa de vozes TTS + amostras .wav | ✅ Concluído | `references/mapa_vozes.md`, `templates/vozes/` |
| Banco de cenas do Beto: 5 cenários (estúdio oficial, escritório agência, carro premium, rooftop urbano, **escritório moderno**) | ✅ Concluído | `templates/cenas/beto/` |
| Guia mestre de produção POV: pesquisa, tipos de take, regras de câmera/som, pipeline, checklist de qualidade | ✅ Concluído | `references/guia_pov.md` |
| **Banco de Inteligência Narrativa** — 4 nichos (Beleza, Moda, Casa, Eletrônicos), 30+ dores reais, 5 ângulos narrativos universais, frases gatilho PT-BR, 18 combinações prontas, motor anti-repetição | ✅ Concluído | `references/banco_narrativo.md` |
| **Pesquisa de Mercado TikTok Shop Brasil** — dados de GMV, produtos mais vendidos, nichos em alta, insights estratégicos (jul/2026) | ✅ Concluído | `references/pesquisa_tiktok_brasil.md` |
| **Voz do Beto v2/v3 — estilo baseado na voz real do criador** (jul/2026): prompt reescrito com ritmo, ironia, autenticidade, CTA como afirmação, abertura calorosa | ✅ Concluído | `templates/vozes/beto_v2.wav`, `templates/vozes/beto_v3.wav`, `references/mapa_vozes.md` (seção Notas de Estilo) |
| **Vídeo institucional do Beto v2** — 27s, 4 takes, cenário escritório moderno, proporções corretas, legendas karaokê (palavras ficando amarelas progressivamente, canto inferior) | ✅ Concluído | `templates/videos/beto_institucional_v2.mp4` |
| **Vídeo institucional do Beto v4** — 1080×1920, sem pausa inicial, karaokê palavra a palavra com timestamps proporcionais | ✅ Concluído | `templates/videos/beto_institucional_v4.mp4` |
| **25 cenas padronizadas em 1440×2560** — todas as pastas renomeadas para nome completo, pastas antigas removidas, estrutura limpa | ✅ Concluído | `templates/cenas/{beto,marina_costa,lucas_ferreira,beatriz_oliveira,rafael_santos,diego_almeida}/` |
| **Logo dark** para uso em vídeos e fundos escuros | ✅ Concluído | `templates/identidade_visual/logo_dark.png` |
| **Banco narrativo expandido** — 9 nichos, 71 dores reais, 43 combinações prontas (+Fitness, Perfumaria, Tecnologia, Pets, Infantil) | ✅ Concluído | `references/banco_narrativo.md` |
| **Análise forense completa** — 17 achados diagnosticados e 8 críticos/altos corrigidos | ✅ Concluído | `references/relatorio_forense.md` |
| **Criativo 01 — Bodysplash Feminino v4** — takes regenerados com novos prompts, áudio TTS único sincronizado, karaokê \kf palavra a palavra, 36s, 1080p | ✅ Concluído | `criativos/criativo_01_bodysplash/criativo01_v4_final.mp4` |

O elenco: Lucas Ferreira (27, tech/gadgets), Marina Costa (24, beleza/skincare), Rafael Santos (32, fitness/premium), Beatriz Oliveira (29, produtividade/casa), Diego Almeida (22, virais/unboxing). Detalhes completos em `references/elenco.md`.

## Padrão Técnico de Produção (Atualizado Sessão 4)

- **Resolução de vídeo:** 1080×1920 (1080p, 9:16) — upscale automático via `scripts/montar_video.sh`
- **Resolução de cenas:** 1440×2560 (9:16) — padrão único para todos os personagens
- **Keyframe de vídeo:** sempre usar cena 9:16 — NUNCA retrato 3:4
- **Voz oficial do Beto:** `templates/vozes/beto_oficial.wav` (baseada na voz real do criador)
- **Nomenclatura de pastas de cenas:** sempre nome completo (`marina_costa/`, `lucas_ferreira/`, etc.)
- **Scripts de produção:** `scripts/montar_video.sh` (montagem + upscale), `scripts/transcrever_palavras.py` (timestamps), `scripts/gerar_karaoke_preciso.py` (ASS karaokê)

## Padrão de Legendas Karaokê (Definido na Sessão 2)

Legendas estilo karaokê para todos os vídeos do projeto a partir de agora:

- **Formato:** ASS (Advanced SubStation Alpha) com tag `\k` para karaokê progressivo
- **Estilo:** fonte Arial Bold tamanho 22, branca com contorno preto, fundo semi-transparente
- **Posição:** canto inferior da tela, alinhamento centralizado, margem vertical 80px
- **Efeito:** palavras ficam **amarelas** (`SecondaryColour: &H0000FFFF`) conforme são faladas
- **Chunks:** até 5 palavras por linha, duração proporcional ao tempo de fala de cada segmento
- **Geração:** transcrever o vídeo com `manus-speech-to-text`, usar os timestamps dos segmentos para calcular `\k` por palavra, renderizar com `ffmpeg -vf "ass=arquivo.ass"`

## Notas de Estilo do Beto — Voz (Definido na Sessão 2)

Baseado na análise de dois áudios reais do criador da marca (jul/2026):

| Elemento | Como aplicar |
|----------|-------------|
| Abertura | Sempre "Mano" ou "Oi" — nunca direto no argumento |
| Ritmo | Médio-rápido com `[short pause]` antes de viradas e antes do CTA |
| Ironia | Observações afiadas sobre gurus/concorrência para construir credibilidade |
| Frases | Curtas e cortadas — máximo ~12 palavras por frase |
| CTA | Afirmação, não pergunta — tom de convite, não de súplica |
| Taglines | "Dê brilho no seu caminho", "Sempre um passo à frente da concorrência" |

## Próximos Passos Planejados (Backlog)

1. **Primeiro criativo de teste (prova da máquina):** rodar o pipeline completo de ponta a ponta com um produto real minerado — **PRÓXIMO PASSO CRÍTICO**. Usar o banco narrativo para escolher dor + ângulo + personagem antes de escrever o roteiro.
2. **Templates de post/grid** para Instagram e TikTok usando a identidade visual.
3. **Pipeline/automação:** estrutura que recebe produto (link/imagens da mineração) e produz o vídeo final automaticamente.
4. **Sistema de captação de leads:** site/app da Movie Money.
5. **Melhorias do motor de roteiros:** banco de roteiros vencedores, roteiros para VSL longa, biblioteca de respostas a objeções.

## Decisões Já Tomadas (Não Rediscutir)

- Produção 100% dentro da Manus; única exceção é a mineração de produtos (site contratado).
- As imagens do produto vêm sempre do site de mineração — nunca pedir ao usuário para filmar ou fotografar nada.
- Vídeos com lip sync real gerados internamente (imagem do personagem + roteiro/áudio → vídeo).
- Formato vertical 9:16 para os vídeos (Reels/TikTok).
- Trabalhar em Português Brasileiro; personagens falam PT-BR.
- Voz do Beto: Fenrir, com prompt de estilo baseado na voz real do criador (ver Notas de Estilo acima e `references/mapa_vozes.md`).
- Cenário preferencial do Beto para vídeos institucionais: escritório moderno (`templates/cenas/beto/escritorio_moderno.png`), não estúdio cinematográfico.
- Legendas de todos os vídeos: karaokê progressivo ASS (palavras amarelas), não SRT estático.
