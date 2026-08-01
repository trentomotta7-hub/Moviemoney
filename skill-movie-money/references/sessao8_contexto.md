# Contexto da Sessão 8 — Movie Money
**Data:** 01/08/2026

## O que foi feito

### Objetivo
Corrigir os 5 takes com áudio em inglês do vídeo v4c e gerar o vídeo v5 final pronto para o YouTube.

### Execução

**1. Diagnóstico e mapeamento (Sessão 7 → Sessão 8)**
- Lido o `sessao7_diagnostico_forense.md` com todos os problemas mapeados
- Identificados os 5 takes contaminados com inglês e os trechos corretos dos áudios Fenrir v2

**2. Extração dos trechos de áudio em português**
- `audio_t_s1d.wav` → `audio_s1_hook_v2.wav` de 28s-36s: *"O algoritmo do TikTok não tá nem aí pros seus seguidores. Ele liga pra uma única coisa: retenção visual."*
- `audio_t_s3c.wav` → `audio_s3_maquina_v2.wav` de 18s-28s: *"A gente não inventa roteiro da nossa cabeça, a gente puxa da nossa base validada. Setenta dores mapeadas."*
- `audio_t_s2c.wav` → `audio_s3_maquina_v2.wav` de 25s-31s: *"Seleciona o nicho, seleciona a personagem e aí a mágica acontece."*
- `audio_t_s4b.wav` → `audio_s4_resultado_v2.wav` de 19s-29s: *"A gente entrega a munição, você só aperta o gatilho."*
- `audio_t_s5b.wav` → `audio_s5_cta_v2.wav` de 24s-27.6s: *"Vem ver como os profissionais jogam. Bora vender?"*

**3. Substituição de áudio nos 5 takes**
- Mantido o vídeo original (lip sync visual do Beto)
- Substituído apenas o stream de áudio pelo Fenrir v2 em português
- Arquivos gerados em `takes_v5/t_s*_pt.mp4`

**4. Logo animada de abertura**
- Gerada com ffmpeg: zoom out suave (1.5→0.2) + fade out para preto
- Duração: 5s, resolução 2560×1440
- Arquivo: `takes_v5/logo_intro.mp4`

**5. Montagem v5**
- 25 segmentos na ordem correta (sem repetições)
- Todos normalizados para 1280×720, 48kHz stereo, 30fps
- SCs com Ken Burns (zoom 1.0→1.08)
- Upscale final 2K (2560×1440) com marca d'água

### Resultado Final

| Parâmetro | Valor |
|-----------|-------|
| Arquivo | `video1_quebra_mitos_v5_FINAL.mp4` |
| Duração | 3min 50s (230.8s) |
| Resolução | 2560×1440 (2K) |
| Tamanho | 120MB |
| Inglês detectado | **0 ocorrências** |
| Logo animada | ✅ Abertura de 5s |
| Takes corrigidos | ✅ 5/5 |

### Arquivos gerados nesta sessão
- `takes_v5/audio_t_s1d.wav` — trecho PT para t_s1d
- `takes_v5/audio_t_s2c.wav` — trecho PT para t_s2c
- `takes_v5/audio_t_s3c.wav` — trecho PT para t_s3c
- `takes_v5/audio_t_s4b.wav` — trecho PT para t_s4b
- `takes_v5/audio_t_s5b.wav` — trecho PT para t_s5b
- `takes_v5/t_s1d_retencao_pt.mp4` — take corrigido
- `takes_v5/t_s2c_bracos_cruzados_pt.mp4` — take corrigido
- `takes_v5/t_s3c_aponta_tela_pt.mp4` — take corrigido
- `takes_v5/t_s4b_sorriso_canto_pt.mp4` — take corrigido
- `takes_v5/t_s5b_aponta_camera_pt.mp4` — take corrigido
- `takes_v5/logo_intro.mp4` — logo animada de abertura
- `scripts/montar_video1_v5.sh` — script de montagem v5
- `video1_quebra_mitos_v5_FINAL.mp4` — **VÍDEO FINAL** (no .gitignore)

---

## Backlog para Sessão 9

### Pendências do Vídeo 1
1. **Crossfade visual entre takes de TH** — ainda há jump cuts visíveis entre os takes. O `xfade` do ffmpeg exige re-encoding de todos os takes em filter_complex, o que é computacionalmente intenso. Pode ser feito na Sessão 9 se o usuário priorizar.
2. **Repetições de conteúdo** — algumas frases ainda aparecem 2x (ex: "A gente entrega a munição" aparece em TH e no VO do SC7). Pode ser eliminado substituindo o VO do SC7 por um trecho diferente.

### Próximas Produções
1. **Vídeo 2 — "A Máquina por Dentro":** roteiro já escrito em `video2_maquina_por_dentro_roteiro_v1.md`
2. **Vídeo 3 — VSL Puro:** roteiro disponível
3. **Legendas karaokê:** implementar `word_timestamps=True` para karaokê por palavra
