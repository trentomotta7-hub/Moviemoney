---
name: movie-money
description: "Máquina de produção de criativos de venda (UGC e POV) para TikTok Shop e VSL do projeto Movie Money. Use para: produzir vídeos de venda com personagens UGC e lip sync real, gerar criativos no formato POV, escrever roteiros de venda (Hook→Problema→Causa→Solução→CTA), escalar personagens do elenco oficial (Beto + 5 UGC), gerar vídeos institucionais com o Beto (rosto da marca), usar a identidade visual da Movie Money, ou continuar qualquer trabalho do projeto Movie Money."
---

# Movie Money — Skill de Produção de Criativos

Skill do projeto Movie Money: empresa de criativos de venda para TikTok Shop e plataformas de venda via VSL. Produz vídeos UGC (personagem do elenco falando com lip sync real, venda invisível) e POV (câmera em primeira pessoa mostrando mãos usando o produto), 100% dentro da Manus, sem ferramentas externas. As imagens de produto vêm sempre de site de mineração fornecido pelo lead.

A marca tem um rosto oficial: o **Beto**, avatar de IA do criador (que não aparece pessoalmente). Beto é o porta-voz institucional — apresenta a empresa, grava campanhas e apresenta os personagens ao público. Backup completo do projeto no GitHub: repositório privado `trentomotta7-hub/Moviemoney` (branch master).

## Checkpoint Rápido

Ler `references/checkpoint.md` no início de qualquer sessão do projeto para o estado completo. Resumo:

| Pronto | Pendente (backlog) |
|--------|--------------------|
| Elenco completo: Beto (rosto da marca) + 5 personagens UGC | Primeiro criativo de teste ponta a ponta (CRÍTICO) |
| Imagens-base oficiais (6 retratos) | Vídeo institucional do Beto com lip sync |
| Banco de cenas: 24 imagens 9:16 (4 cenários × 6 personagens) | Templates de post/grid IG/TikTok |
| Vozes oficiais TTS dos 6 personagens (mapa + amostras .wav) | Pipeline/automação completa |
| Identidade visual: logo final, ícone de perfil, capa/banner | Sistema de captação de leads (site/app) |
| Framework mestre de roteiros + 5 roteiros-exemplo | Melhorias do motor de roteiros (banco de vencedores, VSL longa, objeções) |
| Pipeline de produção documentado | |

## Recursos da Skill

| Recurso | Caminho | Quando usar |
|---------|---------|-------------|
| Elenco completo (perfis, tons de voz, hooks, cenas) | `references/elenco.md` | Antes de escalar personagem ou gerar qualquer criativo |
| Checkpoint do projeto | `references/checkpoint.md` | No início de qualquer sessão do projeto |
| Pipeline de produção passo a passo | `references/pipeline_producao.md` | Ao produzir um criativo de venda |
| Framework mestre de roteiros | `references/framework_roteiros.md` | Ao escrever qualquer roteiro de criativo |
| Roteiros-exemplo (5 completos + matriz de variação) | `references/roteiros_exemplo.md` | Como referência de qualidade e estilo |
| Mapa de vozes oficiais (voz TTS + estilo por personagem) | `references/mapa_vozes.md` | Ao gerar qualquer áudio/fala de personagem |
| Imagens-base dos personagens (Beto + 5) | `templates/personagens/{nome}.png` | Como `references` ao gerar imagem/vídeo do personagem |
| Banco de cenas (24 cenários 9:16, incluindo 4 do Beto) | `templates/cenas/{personagem}/{cena}.png` | Como keyframe/referência ao gerar takes de vídeo UGC |
| Amostras de voz oficiais (.wav) | `templates/vozes/{nome}.wav` | Referência de timbre/estilo de cada personagem |
| Kit de identidade visual (logo, ícone, capa) | `templates/identidade_visual/` | Em qualquer material da marca Movie Money |

## Regras Invioláveis

1. Produção 100% interna na Manus. Nunca pedir ao usuário para filmar, fotografar ou enviar material próprio — as imagens do produto vêm do site de mineração.
2. Vídeos sempre verticais 9:16 (TikTok/Reels).
3. Todo criativo segue a estrutura: **Hook fortíssimo nos 4s iniciais → Problema → Causa → Solução → CTA forte**.
4. Personagens falam Português Brasileiro, cada um no tom de voz definido em `references/elenco.md`, usando a voz TTS fixa mapeada em `references/mapa_vozes.md` (Beto=Fenrir, Lucas=Puck, Marina=Aoede, Rafael=Orus, Beatriz=Zephyr, Diego=Leda).
5. Ao gerar qualquer imagem ou vídeo de personagem, SEMPRE usar a imagem-base (`templates/personagens/{nome}.png`) como referência de identidade.
6. Nunca escalar um personagem fora do perfil de nicho dele.
7. Preservar fielmente forma, cor e rótulos do produto minerado em todas as cenas.

## Fluxo de Produção de Criativo

Ao receber um produto, seguir o pipeline completo em `references/pipeline_producao.md`: Análise do produto → Escalação de personagem e cena → Roteiro → Produção dos takes → Montagem com ffmpeg (legendas estilo TikTok) → Controle de qualidade.

Diretrizes-chave da produção de vídeo: takes UGC usam a imagem de cena do personagem como primeiro keyframe, com a fala exata do roteiro no prompt (PT-BR) e exigência de lip sync natural com áudio; takes POV usam as imagens do produto como referência, descrevendo cena em primeira pessoa com mãos manipulando o produto e narração dos benefícios. Gerar takes de 4–10 segundos e concatenar na ordem do roteiro.

## Atualização do Checkpoint

Ao concluir qualquer entrega nova do projeto (criativo de teste, vídeo institucional, templates etc.), atualizar `references/checkpoint.md` movendo o item de "pendente" para "pronto", registrando os caminhos dos novos assets e a data. Se novos assets forem criados (novos personagens, novas cenas, novas vozes), adicioná-los em `templates/` e referenciá-los em `references/elenco.md` ou no checkpoint. Após cada atualização da skill, sincronizar o repositório GitHub `trentomotta7-hub/Moviemoney` (copiar a skill para `skill-movie-money/` no repo, commit e push no branch master).
