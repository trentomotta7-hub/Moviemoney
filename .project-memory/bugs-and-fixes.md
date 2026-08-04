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

**Status:** 🔴 Aberto
**Sessão:** 14-15 — 04/08/2026

**Sintoma:** No mobile (iOS/Android), o vídeo hero não aparece e algumas imagens não carregam.

**Causa provável:** Tag `<video>` sem atributo `playsinline` (obrigatório no iOS para autoplay inline). Possível falta de `muted` no autoplay. Imagens podem ter problema de CORS ou lazy loading.

**Correção planejada:** Adicionar `playsinline muted autoplay loop` no video tag. Adicionar fallback de imagem poster para mobile. Testar em Chrome DevTools mobile viewport.

---

## BUG-006: Projeto webdev não persiste entre sessões

**Status:** 🟡 Contornado
**Sessão:** 15 — 04/08/2026

**Sintoma:** O projeto webdev da landing page foi criado em sessão anterior e não está disponível no sandbox atual.

**Causa:** O sandbox é reiniciado entre sessões e projetos webdev não são clonados automaticamente.

**Contorno:** Recriar o projeto webdev usando `webdev_init_project` com o mesmo conteúdo, ou acessar via ID do projeto existente se disponível.
