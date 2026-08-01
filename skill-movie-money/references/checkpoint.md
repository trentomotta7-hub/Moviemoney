# Checkpoint do Projeto Movie Money

**Última atualização:** 01 de agosto de 2026 — Sessão 7 (Montagem v4c — Lip Sync Nativo + Ken Burns + Áudio Normalizado)

## Visão do Projeto
Movie Money é uma máquina de produção de criativos de venda (UGC e POV) para TikTok Shop e VSL. O foco é retenção visual e conversão através de roteiros validados e lip sync real.

## Estado Atual — O Que Já Foi Feito

| Entrega | Status | Localização |
|---------|--------|-------------|
| **Vídeo YouTube 1 (Quebra-Mitos) v3** | ✅ Montado | `criativos/video_institucional_youtube/` |
| **Vídeo YouTube 1 (Quebra-Mitos) v4** | ✅ Montado | `criativos/video_institucional_youtube/video1_quebra_mitos_v4_FINAL.mp4` |
| **Vídeo YouTube 1 (Quebra-Mitos) v4c** | ✅ **FINAL APROVADO** | `criativos/video_institucional_youtube/video1_quebra_mitos_v4c_FINAL.mp4` |
| **Takes de Talking Head (Beto)** | ✅ 17 takes únicos | `criativos/video_institucional_youtube/takes/` |
| **Narração Beto (Fenrir) v1** | ✅ Gerados | `criativos/video_institucional_youtube/takes/audio_s*.wav` |
| **Narração Beto (Fenrir) v2** | ✅ Gerados | `criativos/video_institucional_youtube/takes/audio_s*_v2.wav` |
| **Voice Overs Screen Recordings v1** | ✅ Gerados | `criativos/video_institucional_youtube/takes/vo_sc*.wav` |
| **Voice Overs Screen Recordings v2** | ✅ Gerados | `criativos/video_institucional_youtube/takes/vo_sc*_v2.wav` |
| **Screen Recordings/B-Roll** | ✅ 7 assets | `criativos/video_institucional_youtube/takes/sc*.png` |
| **Roteiro Vídeo 2 (Máquina)** | ✅ Escrito | `criativos/video_institucional_youtube/video2_maquina_por_dentro_roteiro_v1.md` |
| **Skill de Auditoria Forense** | ✅ Atualizada | `skills/tiktokshop-creative-audit/SKILL.md` |
| **Script de Montagem v3** | ✅ Finalizado | `scripts/montar_video1_v3.sh` |
| **Script de Montagem v4** | ✅ Finalizado | `scripts/montar_video1_v4.sh` |
| **Script de Montagem v4c** | ✅ **FINAL** | `scripts/montar_video1_v4c.sh` |

## Padrão Técnico das Sessões 6 e 7
- **Zero Loop:** Cada take de Talking Head é único (mínimo 10s).
- **Lip Sync Real:** Uso da fala exata no prompt para sincronia labial.
- **Resolução:** 2K (2560x1440) para YouTube.
- **Identidade:** Marca d'água injetada via script de montagem.
- **Áudios v2:** Voz Fenrir mais assertiva e rítmica (usados na v4).
- **Ken Burns:** Efeito de zoom dinâmico (1.0→1.08) nos Screen Recordings (implementado na v4).

## Vídeo 1 v4c — Especificações Técnicas (VERSÃO FINAL)

| Parâmetro | Valor |
|-----------|-------|
| Arquivo | `video1_quebra_mitos_v4c_FINAL.mp4` |
| Duração | **3 min 57s (237.5s)** |
| Resolução | 2560×1440 (YouTube 2K) |
| FPS | 24 |
| Codec vídeo | H.264 CRF 18 |
| Codec áudio | AAC 48kHz stereo 192kbps |
| Tamanho | 163 MB |
| Marca d'água | ✅ Injetada (canto inferior direito) |
| Takes TH | 17 únicos, lip sync nativo |
| Áudios TH | Lip sync embutido (nativo do modelo) |
| SCs | Ken Burns (zoom 1.0→1.08) + VO v2 |

## Estrutura do Vídeo v4

| Segmento | Tipo | Duração | Áudio |
|----------|------|---------|-------|
| Bloco S1 Hook | TH (4 takes) | 36.6s | audio_s1_hook_v2.wav |
| SC1 YouTube Gurus | SC + Ken Burns | 12.0s | vo_sc1_v2.wav |
| Bloco S2 Dor | TH (3 takes) | 25.0s | audio_s2_dor_v2.wav |
| SC2 Pasta Vídeos | SC + Ken Burns | 14.5s | vo_sc2_v2.wav |
| Bloco S3 Máquina | TH (4 takes) | 31.1s | audio_s3_maquina_v2.wav |
| SC3 WhatsApp Cliente | SC + Ken Burns | 14.2s | vo_sc3_v2.wav |
| SC4 Repositório Terminal | SC + Ken Burns | 13.8s | vo_sc4_v2.wav |
| SC5 ffmpeg Gerando | SC + Ken Burns | 5.0s | silencioso |
| Bloco S4 Resultado | TH (3 takes) | 29.8s | audio_s4_resultado_v2.wav |
| SC7 WhatsApp Resposta | SC + Ken Burns | 4.2s | vo_sc7_v2.wav |
| Bloco S5 CTA | TH (3 takes) | 27.9s | audio_s5_cta_v2.wav |
| SC8 Logo Final | SC + Ken Burns | 4.0s | silencioso |

## Próximos Passos (Backlog para Sessão 8)

1. **Produção Vídeo 2:** Iniciar takes da "Máquina por Dentro" (roteiro já escrito em `video2_maquina_por_dentro_roteiro_v1.md`).
2. **Produção Vídeo 3:** Finalizar VSL Puro (roteiro em `roteiro_v1.md`).
3. **Legendas karaokê:** Implementar transcrição com `word_timestamps=True` para karaokê profissional por palavra no vídeo final.
4. **Regerar takes v5 (opcional):** Se necessário, regerar com prompts ainda mais específicos de fala exata para eliminar a "leve suavidade artificial" do lip sync.

## Notas de Contexto
- O vídeo final v4 (159MB) excede o limite do GitHub e está no `.gitignore`. Deve ser baixado manualmente ou armazenado em LFS.
- A voz oficial do Beto é a **Fenrir** (pt-BR), com tom enérgico e assertivo.
- O keyframe de referência do Beto está em: `criativos/video_institucional_youtube/beto_keyframe_16x9.jpg`

## Sessão 7 (01/08/2026) — Montagem v4c: Arquitetura Correta

- **Diagnóstico:** Sessão anterior (perdida) estava gerando o script de montagem v4 com áudios v2 e Ken Burns.
- **Reconstrução:** Análise forense completa do repositório para identificar exatamente o ponto de parada.
- **Bug identificado (v3/v4):** Os takes de TH têm áudio de lip sync embutido (nativo do modelo). As versões v3 e v4 tentavam substituir esse áudio por áudios externos, causando conflito de duração (400s de silêncio).
- **Solução v4c:** Takes de TH usam áudio nativo (lip sync real). SCs recebem Ken Burns + VO v2. Todos os segmentos normalizados para 48kHz stereo antes da concatenação.
- **Resultado:** Vídeo limpo de 3min57s, sem silêncio espúrio, 2560×1440, 163MB.
- **Script v4c:** Criado `montar_video1_v4c.sh` — versão definitiva.
- **GitHub:** Sincronização de script v4c e checkpoint atualizado.

## Sessão 6 (01/08/2026) — Expansão YouTube e Rigor Técnico
- **Vídeo 1 YouTube:** Montagem completa em 2K com 17 takes únicos de 10s (sem loop).
- **Narração:** Regeneração de todos os áudios (Beto/Fenrir) com tom mais assertivo e rítmico.
- **Lip Sync:** Implementação do padrão de "fala exata no prompt" para garantir sincronia labial.
- **GitHub:** Sincronização de todos os novos assets, áudios e roteiros refinados.
- **Zoom Dinâmico:** Planejamento do efeito Ken Burns para a v4 da montagem.
