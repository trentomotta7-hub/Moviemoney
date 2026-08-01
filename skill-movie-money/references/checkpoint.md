# Checkpoint do Projeto Movie Money

**Última atualização:** 31 de julho de 2026 — Sessão 5

## Visão do Projeto

Movie Money é uma empresa/máquina de produção de criativos de venda para TikTok Shop e plataformas de venda via VSL. O fluxo de negócio: leads trazem um produto (com imagens vindas de site de mineração, contratado externamente) e a máquina monta automaticamente um vídeo de venda em um de dois formatos, tudo produzido dentro da Manus, sem ferramentas de terceiros.

Os dois formatos de criativo são: **POV** (câmera na altura dos olhos/ombro mostrando as mãos usando o produto enquanto narra os benefícios) e **UGC** (um dos 5 personagens do elenco falando sobre a experiência de uso, em tom de relato/venda invisível, com lip sync real).

Estrutura narrativa obrigatória de todo criativo: **Hook fortíssimo nos 4 segundos iniciais** (parar a rolagem) → **Problema** → **Causa** → **Solução** (apresentação do produto) → **CTA forte** no final. Os takes são divididos entre essas seções.

Identidade visual definida: glitch estilo TikTok, fundo preto, cores ciano #25F4EE / magenta #FE2C55, monograma "MM" com botão play entre as letras, tagline "Criativos que vendem no TikTok Shop". Kit em `templates/identidade_visual/` (logo_final.png, perfil_icone.png redondo, capa_banner.png 16:9).

A marca tem um **rosto oficial: o Beto** — avatar de IA do criador (que não quer aparecer pessoalmente). O Beto é o porta-voz institucional: apresenta a empresa, grava os vídeos de campanha/marketing e apresentará os 5 personagens do elenco ao público. Backup completo do projeto no GitHub: repositório privado `trentomotta7-hub/Moviemoney` (branch master).

## Estado Atual — O Que Já Foi Feito

| Entrega | Status | Localização |
|---------|--------|-------------|
| Definição dos 5 personagens UGC | ✅ Concluído | `references/elenco.md` |
| Imagens-base oficiais (retratos 3:4) | ✅ Concluído | `templates/personagens/` |
| Banco de cenas (25 imagens 9:16) | ✅ Concluído | `templates/cenas/` |
| Framework mestre de roteiros | ✅ Concluído | `references/framework_roteiros.md` |
| Roteiros-exemplo completos | ✅ Concluído | `references/roteiros_exemplo.md` |
| Beto — rosto oficial da marca | ✅ Concluído | `references/elenco.md` |
| Kit de identidade visual completo | ✅ Concluído | `templates/identidade_visual/` |
| Vozes oficiais dos 6 personagens | ✅ Concluído | `references/mapa_vozes.md` |
| **Banco de Inteligência Narrativa** (71 dores) | ✅ Concluído | `references/banco_narrativo.md` |
| **Skill de Auditoria Forense Integrada** | ✅ Concluído | `skills/tiktokshop-creative-audit/SKILL.md` |
| **Criativo 01 v8c FINAL** (Safe Zone + Lip Sync) | ✅ Concluído | `criativos/criativo_01_bodysplash/` |
| **Estratégia YouTube (Série de 3 vídeos)** | ✅ Concluído | `criativos/video_institucional_youtube/` |
| **Roteiros YouTube 1 (Dinamico) e 3 (VSL)** | ✅ Concluído | `criativos/video_institucional_youtube/` |
| **Takes YouTube 1 (t1-t5)** | ✅ Concluído | `criativos/video_institucional_youtube/takes/` |

## Padrão Técnico de Produção (Atualizado Sessão 5)

- **Resolução Vertical:** 1080×1920 (TikTok/Reels).
- **Resolução Horizontal:** 2560x1440 (YouTube 2K).
- **Lip Sync Real:** SEMPRE incluir a fala exata no prompt entre aspas.
- **Safe Zone:** MarginV: 320px no ASS para TikTok Shop.
- **Marca D'água:** `logo_transparente.png` em vídeos institucionais.
- **Dinâmica:** Alternar Talking Head com Screen Recordings e B-Rolls.

## Próximos Passos Planejados (Backlog)

1. **Montagem final do Vídeo YouTube 1:** Combinar takes do Beto com gravações de tela.
2. **Automação da Marca D'água:** Script para injetar logo automaticamente.
3. **Produção YouTube 2 e 3:** Seguir o funil estratégico.
4. **Sistema de captação de leads:** Site/app da Movie Money.

## Sessão 5 (31/07/2026) — Auditoria, YouTube e Consolidação
- **Criativo 01 v8c FINAL:** Remontagem completa com lip sync real no take 1 (fala exata no prompt), take 4 (CTA completo do roteiro), legendas elevadas para Safe Zone (320px) e cauda morta removida.
- **Skill TikTok Shop Audit:** Criada a skill `tiktokshop-creative-audit` que documenta o processo forense de análise e correção de criativos.
- **Estratégia YouTube:** Criada série de 3 vídeos (Quebra-Mitos, Máquina por Dentro, VSL) com estrutura de funil de vendas perpétuo.
- **Roteiros YouTube:** Finalizados os roteiros do Vídeo 1 (O Quebra-Mitos) em versão dinâmica e o Vídeo 3 (VSL).
- **Produção YouTube:** Gerado keyframe 16:9 do Beto e os 5 takes de talking head para o Vídeo 1 com lip sync real.
- **Repositório:** Sincronização completa de todos os assets, roteiros e inteligência gerada.
