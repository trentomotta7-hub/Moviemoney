# Relatório de Auditoria Completa — Sessão 20
**Data:** 2026-08-07  
**Objetivo:** Emitir veredito definitivo (APPROVED ou REJECTED) para todos os masters do projeto Movie Money, sem deixar nenhum arquivo em estado indefinido.

---

## Resumo executivo

Nenhum master do projeto passou nos dois gates obrigatórios (técnico + perceptual). Todos os arquivos de vídeo auditados recebem veredito **REJECTED**. Os motivos variam entre falhas técnicas mensuráveis (sample rate incorreto, loudness baixo, drift de áudio, freeze) e falhas perceptuais críticas (lip sync insuficiente, produto inconsistente, narração truncada, realismo abaixo do padrão).

---

## Tabela de vereditos

| # | Master | Formato | Gate técnico | Gate perceptual | **Veredito final** |
|---|---|---|---|---|---|
| 1 | GC Sunscreen Stick v5 | Short 9:16 | TECHNICALLY_REJECTED | REJECTED | **REJECTED** |
| 2 | POV Sunscreen Stick v1 (video_normalizado) | Short 9:16 | TECHNICALLY_REJECTED | REJECTED | **REJECTED** |
| 3 | Vídeo 1 institucional (video1_quebra_mitos_FINAL) | YouTube 16:9 | TECHNICALLY_REJECTED | REJECTED | **REJECTED** |
| 4 | Vídeo 1 institucional (video1_quebra_mitos_MONTADO) | YouTube 16:9 | TECHNICALLY_REJECTED | — (idêntico ao FINAL) | **REJECTED** |
| 5 | Vídeo 2 institucional (video2_sem_marca) | YouTube 16:9 | TECHNICALLY_REJECTED | REJECTED | **REJECTED** |
| 6 | Criativo 01 Bodysplash v8 | Short 9:16 | TECHNICALLY_REJECTED | — | **REJECTED** |
| 7 | Criativo 01 Bodysplash v8b | Short 9:16 | TECHNICALLY_REJECTED | — | **REJECTED** |
| 8 | Criativo 01 Bodysplash v8c | Short 9:16 | TECHNICALLY_REJECTED | REJECTED | **REJECTED** |
| 9 | Beto institucional final | YouTube 16:9 | TECHNICALLY_REJECTED | — | **REJECTED** |
| 10 | Beto institucional v3 | YouTube 16:9 | TECHNICALLY_REJECTED | — | **REJECTED** |
| 11 | Beto institucional v4 | YouTube 16:9 | TECHNICALLY_REJECTED | REJECTED | **REJECTED** |

> **GC v6:** O arquivo `.mp4` do GC v6 não existe no repositório — apenas scripts, transcrições e o relatório da sessão 19. O veredito da sessão 19 (REJECTED) permanece válido. Não há master para reauditar.

---

## Detalhamento por master

### 1. GC Sunscreen Stick v5
**Arquivo:** `skill-movie-money/criativos/sunscreen_stick_spf/GC/montagem/sunscreen_stick_marina_GC_v5_FINAL.mp4`  
**SHA-256:** `150f812c6f30ace416713bc342cd9c1e75137f4d12018d3e6031b64357d65b29`  
**Duração:** 33,1 s

| Gate técnico | Status | Falhas |
|---|---|---|
| sample_rate | FAIL | 96000 Hz (exigido 48000 Hz) |
| drift_duracao | FAIL | 0,066 s (limite 0,050 s) |
| Demais critérios | PASS | — |

| Gate perceptual | Status | Evidência |
|---|---|---|
| Lip sync | FAIL | Fonemas /p/ /b/ /m/ /f/ /v/ não articulados; atraso perceptível |
| Realismo humano | FAIL | Pele plastificada, microexpressões ausentes, olhar vítreo |
| Mãos | FAIL | Dedos rígidos, interação irreal com produto |
| Produto | FAIL | Rótulo com warping; protetor "antigo" sem rótulo |
| Narração | PASS | Texto completo, CTA presente |
| Claims | FAIL | "Não estraga maquiagem", "dura 2 meses", "esgotou 2 vezes" sem evidência visual |

**Veredito: REJECTED**

---

### 2. POV Sunscreen Stick v1 (video_normalizado)
**Arquivo:** `skill-movie-money/criativos/sunscreen_stick_spf/POV/montagem/video_normalizado.mp4`  
**SHA-256:** `4d3d30c8b5789285dfb8fd8457838d44b5197057a32d54100a3da283bbeb8d6f`  
**Duração:** 29,0 s

| Gate técnico | Status | Falhas |
|---|---|---|
| sample_rate | FAIL | 96000 Hz (exigido 48000 Hz) |
| Demais critérios | PASS | — |

| Gate perceptual | Status | Evidência |
|---|---|---|
| Produto | FAIL | Produto muda de ISNTREE para bastão genérico; rótulo com erro de ortografia ("Transparere Formule") |
| Mãos | FAIL | Dedos com proporções anormais, polegar distorcido |
| Física | FAIL | Creme como textura estática colada, sem interação física |
| Texto visual | FAIL | Overlays em inglês ("Reapplying liquid sunscreen at noon?") |
| Narração | FAIL | Áudio cortado em "Meninas..."; CTA ausente |
| Continuidade | FAIL | Produto diferente entre takes; quebra do formato POV (rosto aparece) |

**Veredito: REJECTED**

---

### 3. Vídeo 1 institucional — video1_quebra_mitos_FINAL
**Arquivo:** `skill-movie-money/criativos/video_institucional_youtube/video1_quebra_mitos_FINAL.mp4`  
**SHA-256:** `66dd968179c1e9b162728f6df9575ab09eefb8b0efdca49fd1f75d49c57174ad`  
**Duração:** 87,5 s

| Gate técnico | Status | Falhas |
|---|---|---|
| drift_duracao | FAIL | 7,453 s (limite 0,050 s) |
| cauda_silenciosa | FAIL | 7,453 s (limite 0,200 s) |
| loudness_integrado | FAIL | -19,0 LUFS (exigido -16,0 ± 1,0) |
| true_peak | FAIL | -0,9 dBTP (limite ≤ -1,0) |
| freeze_nao_intencional | FAIL | 12,533 s (limite 0,500 s) |

| Gate perceptual | Status | Evidência |
|---|---|---|
| Lip sync | PASS | Nota 7/10 — aceitável para avatar IA |
| Realismo humano | FAIL | Pele plastificada, microexpressões ausentes |
| Mãos | FAIL | Gestos robóticos e repetitivos |
| Narração | PASS | Texto completo, CTA presente |
| Continuidade | FAIL | Freeze de ~20 s após 1:00; cauda muda até o fim |
| Qualidade técnica | FAIL | Ausência total de áudio no terço final |

**Veredito: REJECTED**

---

### 4. Vídeo 2 institucional — video2_sem_marca
**Arquivo:** `skill-movie-money/criativos/video_institucional_youtube/temp_v2_montagem/video2_sem_marca.mp4`  
**SHA-256:** `67d6cd7b981ea823a175f059918fab8c1c13757e9edbce991fe7b396be0f35f1`  
**Duração:** 241,8 s (4 min 1 s)

| Gate técnico | Status | Falhas |
|---|---|---|
| drift_duracao | FAIL | 9,680 s |
| cauda_silenciosa | FAIL | 14,725 s |
| loudness_integrado | FAIL | -18,5 LUFS |
| true_peak | FAIL | -0,8 dBTP |
| freeze_nao_intencional | FAIL | 19,417 s |
| black_frame | FAIL | 0,500 s |

| Gate perceptual | Status | Evidência |
|---|---|---|
| Lip sync | PASS | Aceitável para avatar IA |
| Realismo | PASS | Qualidade técnica alta |
| Narração | PASS | Roteiro completo e forte; CTA presente |
| Continuidade | FAIL | Repetição de fala em 0:07; glitch de áudio em 1:30; freeze e cauda longa no final |
| Qualidade técnica | PASS | Iluminação, foco e áudio de boa qualidade |

**Veredito: REJECTED**

---

### 5. Criativo 01 Bodysplash v8c (master mais recente)
**Arquivo:** `skill-movie-money/criativos/criativo_01_bodysplash/criativo01_v8c_FINAL.mp4`  
**SHA-256:** `7084dd0da6ce3f025effeb3434d9a8f0e0aa471c65c494d9fad2f20758a9aed6`  
**Duração:** 30,4 s

| Gate técnico | Status | Falhas |
|---|---|---|
| cauda_silenciosa | FAIL | 0,627 s (limite 0,200 s) |
| loudness_integrado | FAIL | -20,3 LUFS (exigido -16,0 ± 1,0) |

| Gate perceptual | Status | Evidência |
|---|---|---|
| Lip sync | FAIL | Nota 3/10; fonemas bilabiais e labiodentais não articulados |
| Realismo | FAIL | Uncanny valley; pele excessivamente lisa |
| Mãos | FAIL | Rigidez, dedos alongados |
| Produto | FAIL | **Frasco sem rótulo** — embalagem genérica, impossível identificar o produto |
| Narração | FAIL | Texto completo mas prosódia robótica (TTS evidente) |
| Claims | FAIL | "Terceiro frasco" sem evidência visual; frascos vazios ausentes |

**Veredito: REJECTED**

---

### 6. Beto institucional v4 (template mais recente)
**Arquivo:** `skill-movie-money/templates/videos/beto_institucional_v4.mp4`  
**SHA-256:** `2bfb903417421024481d2e9b033fcc8b0f4447c5000e1c0cc7fc09bac820b493`  
**Duração:** 26,5 s

| Gate técnico | Status | Falhas |
|---|---|---|
| resolucao | FAIL | 1080x1920 — aspect ratio 9:16, não 16:9 |
| aspect_ratio | FAIL | 0,5625 (exigido 16:9) |
| cauda_silenciosa | FAIL | 0,394 s |
| loudness_integrado | FAIL | -20,1 LUFS |

| Gate perceptual | Status | Evidência |
|---|---|---|
| Lip sync | FAIL | Nota 2/10 — movimentos de boca não correspondem ao áudio em português |
| Realismo | FAIL | Uncanny valley evidente |
| Mãos | FAIL | Gestos genéricos e repetitivos; anomalias anatômicas |
| Narração | PASS | Roteiro persuasivo, CTA presente |
| Continuidade | FAIL | Corte abrupto sem tela de encerramento, logo ou fade-out |

**Veredito: REJECTED**

---

## Padrão de falhas recorrentes

| Falha | Ocorrências | Impacto |
|---|---|---|
| Sample rate incorreto (96 kHz ou 44,1 kHz) | GC v5, POV v1, Bodysplash v8/v8b | Gate técnico |
| Loudness abaixo de -17 LUFS | Bodysplash v8/v8b/v8c, Beto v3/v4/final, Vídeo 2 | Gate técnico |
| Drift / cauda de silêncio excessiva | Vídeo 1, Vídeo 2, Beto v3/v4/final | Gate técnico |
| Freeze não intencional | Vídeo 1, Vídeo 2 | Gate técnico |
| Lip sync insuficiente (< 9/10) | GC v5, Bodysplash v8c, Beto v4 | Gate perceptual |
| Produto inconsistente / sem rótulo | POV v1, Bodysplash v8c | Gate perceptual |
| Narração truncada / CTA ausente | POV v1 | Gate perceptual |
| Aspect ratio errado para o perfil | Beto v3/v4 (9:16 auditado como YouTube) | Gate técnico |

---

## Próximos passos obrigatórios

Para cada master, o caminho de correção é distinto:

**GC Sunscreen Stick:** Regerar takes com `generate_audio=True`, normalizar áudio para 48 kHz e -16 LUFS, aprovar cada take individualmente para lip sync ≥ 9/10 antes da montagem.

**POV Sunscreen Stick:** Definir produto âncora único, regerar todos os takes com o mesmo produto, garantir rótulo em português, narração completa e CTA integral.

**Vídeo 1 institucional:** Cortar a cauda de 7,45 s, eliminar o freeze de 12,5 s, normalizar loudness para -16 LUFS e true peak ≤ -1,0 dBTP, refazer encerramento.

**Vídeo 2 institucional:** Cortar repetição em 0:07, corrigir glitch em 1:30, eliminar freeze e cauda longa, normalizar loudness e true peak.

**Criativo 01 Bodysplash:** Definir produto âncora com rótulo visível, regerar takes com lip sync e produto corretos, normalizar áudio.

**Beto institucional:** Regerar em 16:9 (não 9:16), normalizar loudness, adicionar tela de encerramento, melhorar lip sync.

---

## Regra perpétua (reafirmada)

Nenhum arquivo pode ser promovido para `APPROVED` nem receber os nomes `FINAL`, `PERFEITO` ou `PRONTO` sem:
1. Gate técnico retornando `TECHNICALLY_APPROVED`
2. Certificado perceptual retornando `APPROVED` (sem média compensatória)
3. SHA-256 vinculado ao mesmo arquivo auditado
4. Manifesto de entrega preenchido
