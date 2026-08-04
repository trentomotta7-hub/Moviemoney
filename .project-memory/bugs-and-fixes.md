# Movie Money — Bugs e Correções

---

## BUG-001: Áudio mudo no ffmpeg concat

**Status:** ✅ Corrigido (v12)
**Sessão:** 13 — 03/08/2026

**Sintoma:** Após concatenar segmentos com `ffmpeg -c copy`, vários segmentos ficavam sem áudio no vídeo final.

**Causa:** Incompatibilidade de timestamps entre segmentos gerados em passadas diferentes. O `-c copy` não realinhava os timestamps, causando descarte de áudio.

**Correção:** Re-encode completo no concat com `-c:v libx264 -c:a aac -video_track_timescale 24000`. Script: `montar_video2_v12_final.sh`.

---

## BUG-002: Ken Burns inativo (apenas 1 frame)

**Status:** ✅ Corrigido (v12)
**Sessão:** 13 — 03/08/2026

**Sintoma:** Screen Recordings com efeito Ken Burns geravam vídeos de 0.041s (1 frame).

**Causa:** Filtro `zoompan` com `-loop 1` não avançava os frames de entrada.

**Correção:** Substituído por escala dinâmica dependente do tempo com `eval=frame`. Verificação: diferença média entre primeiro e último frame = 14.556 (Ken Burns ativo).

---

## BUG-003: Voz robótica/feminina nos Screen Recordings

**Status:** ✅ Corrigido (v12)
**Sessão:** 13 — 03/08/2026

**Sintoma:** Nos SCs das versões v8-v10, a voz era feminina/robótica, incompatível com o personagem Beto.

**Causa:** VOs gerados com gTTS (Google TTS) em vez da voz oficial Fenrir.

**Correção:** Todos os 8 VOs regravados com voz Fenrir via `generate_speech`. Arquivos em `takes_v12_vos/`.

---

## BUG-004: TH-1a com repetição ("TikTok Shop, TikTok Shop")

**Status:** ✅ Corrigido (v12)
**Sessão:** 13 — 03/08/2026

**Sintoma:** O take TH-1a original repetia a frase "TikTok Shop, TikTok Shop" de forma antinatural.

**Causa:** Prompt de geração de vídeo muito literal.

**Correção:** Regravado com veo3.1 (8s), texto simplificado. Arquivo: `takes_v12/v12_t1a_hook_matematico_v2.mp4`.

---

## BUG-005: Mobile da landing page sem vídeo/imagens

**Status:** ✅ Corrigido (v3.0)
**Sessão:** 15 — 04/08/2026

**Sintoma:** No mobile (iOS/Android), o vídeo hero não aparece e algumas imagens não carregam.

**Causa:** Tag `<video>` sem atributo `playsinline` (obrigatório no iOS para autoplay inline). Falta de `muted` no autoplay. Imagens sem lazy loading adequado.

**Correção:** Adicionado `playsinline muted autoplay loop` no video tag. Poster fallback adicionado. Lazy loading nas imagens. Aspect-ratio responsivo.

---

## BUG-006: Projeto webdev não persiste entre sessões

**Status:** 🟡 Contornado
**Sessão:** 15 — 04/08/2026

**Sintoma:** O projeto webdev da landing page foi criado em sessão anterior e não está disponível no sandbox atual.

**Causa:** O sandbox é reiniciado entre sessões e projetos webdev não são clonados automaticamente.

**Contorno:** Recriar o projeto webdev usando `webdev_init_project` com o mesmo conteúdo.

---

## BUG-007: Vídeo CEO Beto — Inconsistências entre takes

**Status:** 🔴 Aberto — Em correção
**Sessão:** 15 — 04/08/2026

### Problemas identificados pela análise de IA (manus-analyze-video)

#### 7.1 — Inconsistência de cenário entre takes

| Take | Cenário | Diferenças |
|---|---|---|
| Take 1 (Hook) | Estante com livros "LONDON" e "DUBAI", escultura escura, globo terrestre à direita | Cenário A |
| Take 2 (Verdade) | Lâmpada retrô, placa YouTube, quadro "A MAIOR REDE DO MU...", cabeça de leão dourada | Cenário B — diferente do A |
| Take 3 (Solução) | Placas YouTube (Prata e Ouro), quadro com rosto P&B com pincelada vermelha, MacBook visível | Cenário C — diferente do A e B |
| Take 4 (CTA) | Quadro "DISCIPLINA" com guerreiro/monge, poltrona de couro capitonê | Cenário D — diferente de todos |

**Diagnóstico:** Cada take foi gerado com um keyframe diferente, e o modelo de IA criou cenários completamente diferentes para cada um. Isso quebra a continuidade visual do vídeo.

#### 7.2 — Inconsistência de aparência do Beto

| Take | Tatuagem | Relógio | Observação |
|---|---|---|---|
| Take 1 | Braço esquerdo fechado | Prateado | OK |
| Take 2 | Braço esquerdo, tribal/geometric | Dourado | Relógio mudou de cor |
| Take 3 | Braço direito fechado | Dourado | Tatuagem mudou de braço |
| Take 4 | Braço direito, mandala/geometric | Prateado | Tatuagem no braço direito, relógio prateado |

**Diagnóstico:** A tatuagem alterna entre braço esquerdo e direito. O relógio alterna entre prateado e dourado. Isso indica que o modelo não manteve consistência do personagem entre os keyframes.

#### 7.3 — Lip sync imperfeito em todos os takes

Todos os 4 takes apresentam sincronia labial deficiente:
- A boca se move de forma genérica, não acompanhando os fonemas do português
- Movimentos labiais "borrachados" e artificiais
- Região da boca e maxilar parece desconectada do resto do rosto
- Efeito "uncanny valley" (vale da estranheza) evidente

**Causa:** O modelo gemini-omni-flash-preview gera vídeo com áudio, mas o lip sync não é perfeito para português brasileiro. A boca se move de forma aproximada, não exata.

#### 7.4 — Áudio levemente acelerado e artificial

Todos os takes apresentam:
- Fala contínua sem pausas naturais para respiração
- Cadência acelerada e mecânica
- Som de TTS (Text-to-Speech) em vez de fala natural
- Ritmo frenético típico de IA

**Causa:** O modelo gera áudio com velocidade padrão que não simula pausas naturais humanas.

#### 7.5 — Glitch no primeiro frame do Take 4

No frame inicial do take 4, o rosto do Beto tem uma aparência diferente, com um "salto" brusco no segundo seguinte quando o rosto gerado por IA "encaixa" sobre o original.

---

### Plano de Correção

1. **Usar um único keyframe de referência** para todos os takes — garantir mesmo cenário, mesma roupa, mesma tatuagem, mesmo relógio
2. **Gerar todos os takes em uma única sessão** com o mesmo modelo e mesmos parâmetros
3. **Ajustar velocidade do áudio** com ffmpeg (atempo) para simular pausas naturais
4. **Adicionar crossfade** entre takes para suavizar transições
5. **Considerar gerar áudio separado** com voz Fenrir (TTS do Manus) e sobrepor no vídeo, em vez de usar o áudio nativo do modelo de vídeo
