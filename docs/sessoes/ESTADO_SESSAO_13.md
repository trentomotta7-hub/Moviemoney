# Estado da Sessão 13 — Movie Money

**Data:** 03 de agosto de 2026 (noite)
**Objetivo:** Corrigir o Vídeo 2 "A Máquina por Dentro" — voz única do Beto em todo o vídeo, telas reais do projeto, e criar a landing page.

---

## Contexto Histórico Verificado

### Timeline dos commits (horário de Brasília, GMT-3)

| Commit | Data/Hora GMT-3 | Descrição |
|---|---|---|
| `9c0f8d0` | 02/08 23:31 | Vídeo 2 v11 FINAL: Correções de qualidade |
| `b8ff623` | 02/08 22:58 | Vídeo 2 v10: Regravação 11 takes TH + montagem |
| `8c70d83` | 02/08 20:04 | Sessão 12: Vídeo 2 v8 + skill atualizada |
| `b79c7ee` | 02/08 18:39 | Sessão 12: Vídeo 2 v2 — screens_v2, VOs |

### Problema que o usuário relatou
1. **Vozes inconsistentes:** apareciam vozes femininas/robóticas (gTTS) nos Screen Recordings, quebrando a continuidade com a voz masculina do Beto
2. **Print do "Vibe Code":** tela do VS Code aparecia como print genérico
3. **Pedido:** deixar SOMENTE a voz do Beto em todo o texto, do começo ao fim; telas devem parecer gravação de tela real do projeto rodando com a voz ao fundo
4. **Pedido adicional:** criar landing page nova

---

## Correções Aplicadas na v12

### 1. Voz única (Fenrir) em todos os SCs
Os VOs anteriores usavam `gTTS` (Google TTS), que produzia voz feminina/robótica. Foram regravados todos os 8 VOs com a voz **Fenrir** (mesma voz oficial do Beto, conforme `references/mapa_vozes.md`).

**Localização:** `skill-movie-money/criativos/video_institucional_youtube/takes_v12_vos/`

| VO | Duração | Conteúdo |
|---|---|---|
| vo_sc1 | 11.3s | TikTok não quer que o usuário saia do app |
| vo_sc2 | 12.6s | Infraestrutura de engenharia |
| vo_sc3 | 16.4s | Os 5 personagens e seus nichos |
| vo_sc4 | 13.8s | Banco Narrativo |
| vo_sc5 | 12.2s | 34 mil vídeos analisados, 70 dores |
| vo_sc6 | 14.5s | Funil de atenção |
| vo_sc7 | 25.6s | Comparação lip sync |
| vo_sc8 | 20.8s | Safe Zone 320px |

### 2. SC-3 recriado com rostos reais do elenco
Substituída a tela genérica por um dashboard "ELENCO MOVIE MONEY" com as 5 fotos reais dos personagens do repositório, em cards com bordas coloridas, nome, nicho e badge de status.

**Script:** `gerar_scs_v12.py` (função `create_sc3_grid`)
**Output:** `scs_v12/sc3_grid_personagens.png`

### 3. TH-1a regravado
O take original repetia "TikTok Shop, TikTok Shop". Regravado com **veo3.1** (8s), texto simplificado, sem repetições confirmado por análise.

**Arquivo:** `takes_v12/v12_t1a_hook_matematico_v2.mp4`

### 4. Bug crítico corrigido: áudio mudo no concat
**Causa:** o `ffmpeg concat` com `-c copy` estava descartando o áudio de vários segmentos por incompatibilidade de timestamps entre segmentos gerados em passadas diferentes.
**Solução:** re-encode completo no concat (`-c:v libx264 -c:a aac`) + `-video_track_timescale 24000` uniforme em todos os segmentos.

### 5. Bug corrigido: Ken Burns inativo
**Causa:** o filtro `zoompan` com `-loop 1` gerava apenas 1 frame de vídeo (duração 0.041s), pois não avançava os frames de entrada.
**Solução:** substituído por escala dinâmica dependente do tempo:
```
scale=2560:1440,crop=2560:1440,setsar=1,fps=24,
scale=w='ceil(2560*(1+0.08*t/DUR)/2)*2':h='ceil(1440*(1+0.08*t/DUR)/2)*2':eval=frame,
crop=w=2560:h=1440:x='(iw-2560)/2':y='(ih-1440)/2',
scale=1280:720:flags=bicubic
```
Verificação: diferença média entre primeiro e último frame = 14.556 (Ken Burns ativo).

---

## Resultado Final v12 — APROVADO

**Arquivo:** `skill-movie-money/criativos/video_institucional_youtube/video2_maquina_por_dentro_v12_FINAL.mp4`

| Atributo | Valor |
|---|---|
| Duração | ~3min58s (238s) |
| Tamanho | 33 MB |
| Resolução | 1280x720 (H.264) |
| Áudio | AAC 48kHz stereo, -19.5 a -20.2 dB uniforme |
| Segmentos | 20 (11 TH + 9 SC) |

### Verificação por análise de IA (aprovada em todos os critérios)
1. Áudio audível em todo o vídeo, sem trechos mudos — **SIM**
2. Uma única voz masculina do mesmo timbre — **SIM**
3. Ken Burns ativo em todos os screen recordings — **SIM**
4. Marca d'água visível 100% do tempo — **SIM**
5. SC do elenco com 5 rostos reais — **SIM** (1:04–1:19)
6. Logo final presente — **SIM** (a partir de 3:53)
7. Qualidade geral aprovada para YouTube — **SIM**

---

## Estrutura de Ordem dos Segmentos (v12)

| # | Segmento | Tipo |
|---|---|---|
| 01 | TH-1a (regravado v12) | Beto |
| 02 | SC-1 vídeo genérico TikTok | Tela |
| 03 | TH-1b algoritmo pune | Beto |
| 04 | TH-1c caixa preta | Beto |
| 05 | TH-1d máquina faz | Beto |
| 06 | SC-2 repositório | Tela |
| 07 | SC-3 elenco (rostos reais) | Tela |
| 08 | TH-2a elenco nunca atrasa | Beto |
| 09 | TH-2b você gerencia | Beto |
| 10 | SC-4 banco narrativo | Tela |
| 11 | SC-5 70 dores | Tela |
| 12 | SC-6 funil de atenção | Tela |
| 13 | TH-3a cereja do bolo | Beto |
| 14 | SC-7 comparação lip sync | Tela |
| 15 | SC-8 safe zone | Tela |
| 16 | TH-3b engenharia conversão | Beto |
| 17 | TH-4a você viu a máquina | Beto |
| 18 | TH-4b boa notícia | Beto |
| 19 | TH-4c próximo vídeo | Beto |
| 20 | SC-9 logo final | Tela |

---

## Scripts Criados nesta Sessão

| Script | Função |
|---|---|
| `gerar_vos_fenrir_v12.py` | Referência dos textos dos VOs (a geração final foi feita via ferramenta TTS do Manus com voz Fenrir) |
| `gerar_scs_v12.py` | Gera os 8 SCs com Ken Burns + VO, e cria o SC-3 com rostos reais |
| `montar_video2_v12_final.sh` | Montagem definitiva com re-encode total (áudio garantido) |

---

## Pendências

1. **Landing page da Movie Money** — próximo passo desta sessão
2. Atualizar skill com padrões técnicos v12
3. Vídeo 3 "A Oferta" (VSL) — próxima campanha
