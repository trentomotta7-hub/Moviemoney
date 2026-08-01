---
name: movie-money
description: "Máquina de produção de criativos de venda (UGC e POV) para TikTok Shop e VSL do projeto Movie Money. Use para: produzir vídeos de venda com personagens UGC e lip sync real, gerar criativos no formato POV, escrever roteiros de venda (Hook→Problema→Causa→Solução→CTA), escalar personagens do elenco oficial (Beto + 5 UGC), gerar vídeos institucionais com o Beto (rosto da marca), usar a identidade visual da Movie Money, ou continuar qualquer trabalho do projeto Movie Money."
---

# Movie Money — Skill de Produção de Criativos

Skill do projeto Movie Money: empresa de criativos de venda para TikTok Shop e plataformas de venda via VSL. Produz vídeos UGC (personagem do elenco falando com lip sync real, venda invisível) e POV (câmera em primeira pessoa mostrando mãos usando o produto), 100% dentro da Manus, sem ferramentas externas. As imagens de produto vêm sempre de site de mineração fornecido pelo lead.

A marca tem um rosto oficial: o **Beto**, avatar de IA do criador (que não aparece pessoalmente). Beto é o porta-voz institucional — apresenta a empresa, grava campanhas e apresenta os personagens ao público. Backup completo do projeto no GitHub: repositório privado `trentomotta7-hub/Moviemoney` (branch master).

## Checkpoint Rápido

Ler `references/checkpoint.md` no início de qualquer sessão do projeto para o estado completo. Resumo atualizado (sessão 5 — jul/2026):

| Pronto | Pendente (backlog) |
|--------|--------------------|
| Elenco completo: Beto (rosto da marca) + 5 personagens UGC | **Vídeo YouTube 1 completo (Montagem final)** |
| Banco de cenas: 25 imagens 9:16 + Keyframe Beto 16:9 | Vídeos YouTube 2 e 3 (Produção) |
| Vozes oficiais TTS dos 6 personagens | Automação de Marca D'água no Pipeline |
| Identidade visual: logo final, ícone, marca d'água transparente | Sistema de captação de leads (site/app) |
| **Skill de Auditoria Forense Integrada** (TikTok Shop) | Melhorias do motor de roteiros (VSL longa) |
| **Criativo 01 v8c** (Legendas Safe Zone, Lip Sync Real) | |
| **Roteiros YouTube (Série de 3 vídeos)** | |

## Recursos da Skill

| Recurso | Caminho | Quando usar |
|---------|---------|-------------|
| **Skill de Auditoria Forense** | `skills/tiktokshop-creative-audit/SKILL.md` | **OBRIGATÓRIO** para auditar e corrigir criativos TikTok Shop |
| Elenco completo | `references/elenco.md` | Antes de escalar personagem ou gerar qualquer criativo |
| Checkpoint do projeto | `references/checkpoint.md` | No início de qualquer sessão do projeto |
| Pipeline de produção | `references/pipeline_producao.md` | Ao produzir um criativo de venda |
| Estratégia YouTube | `criativos/video_institucional_youtube/estrategia_canal_v1.md` | Ao planejar conteúdo para o canal da marca |
| Banco Narrativo | `references/banco_narrativo.md` | **OBRIGATÓRIO** antes de escrever qualquer roteiro |
| Identidade Visual | `templates/identidade_visual/` | Em qualquer material da marca Movie Money |

## Regras Invioláveis

1. **Produção 100% interna na Manus.** Nunca pedir ao usuário para enviar material próprio.
2. **Formato:** TikTok/Reels = 9:16 (Vertical). YouTube = 16:9 (Horizontal).
3. **Lip Sync Real:** O prompt de geração **DEVE** conter a fala exata do roteiro entre aspas para garantir sincronia labial absoluta.
4. **Safe Zone (TikTok Shop):** Legendas `.ass` devem ter `MarginV: 320` para não ficarem atrás do carrinho laranja.
5. **Loop Perfeito:** Remover qualquer silêncio (cauda morta) no final do vídeo para forçar o loop imediato no TikTok.
6. **Keyframes:** Sempre usar a cena correspondente (`templates/cenas/`) como primeiro keyframe, nunca o retrato 3:4.
7. **Dinâmica YouTube:** Intercalar Talking Head (Beto) com Screen Recordings (bastidores reais) e B-Rolls de criativos prontos.
8. **Marca D'água:** Usar `logo_transparente.png` discretamente em todos os vídeos institucionais.

## Fluxo de Auditoria e Correção

Sempre que analisar um vídeo pronto, use a skill `tiktokshop-creative-audit`. O processo envolve:
1. Diagnóstico visual via IA (`manus-analyze-video`).
2. Verificação de Drift e Cauda Morta via `ffprobe`/`ffmpeg`.
3. Ajuste de legendas para Safe Zone.
4. Refação de takes com lip sync falho usando o padrão de "fala exata no prompt".

## Atualização do Checkpoint

Ao concluir qualquer entrega, atualizar `references/checkpoint.md`. Sincronizar o repositório GitHub `trentomotta7-hub/Moviemoney` após cada mudança significativa (commit e push no master).
