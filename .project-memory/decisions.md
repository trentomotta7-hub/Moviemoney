# Movie Money — Decisões Técnicas

> Registro permanente de decisões importantes tomadas ao longo do projeto.

---

## Voz do Beto: Fenrir (não Kore, não gTTS)

**Data:** Sessão 13 — 03/08/2026

**Decisão:** A voz oficial do Beto é **Fenrir** (voz Gemini TTS). Todas as gerações de áudio para o Beto devem usar exclusivamente esta voz.

**Motivo:** Nas versões v8-v10 do Vídeo 2, os Screen Recordings usavam gTTS (Google TTS), que produzia voz feminina/robótica incompatível com o personagem. Isso gerava inconsistência grave de experiência. A v12 corrigiu todos os SCs para Fenrir.

**Regra:** Nunca usar gTTS, pyttsx3 ou qualquer TTS genérico. Sempre usar a ferramenta `generate_speech` do Manus com `voice_name: "Fenrir"`.

---

## Resolução padrão: 1280×720 (não 1920×1080)

**Data:** Sessão 11 — 01/08/2026

**Decisão:** Todos os vídeos são produzidos em 1280×720 (HD 720p), não em Full HD.

**Motivo:** O TikTok Shop comprime vídeos de qualquer forma. 720p garante arquivos menores, uploads mais rápidos e processamento mais ágil no Manus. Upscale para 2K é opcional para YouTube.

---

## Concatenação com re-encode completo (não `-c copy`)

**Data:** Sessão 13 — 03/08/2026

**Decisão:** O `ffmpeg concat` deve sempre usar re-encode completo (`-c:v libx264 -c:a aac`), nunca `-c copy`.

**Motivo:** O `-c copy` descartava o áudio de vários segmentos por incompatibilidade de timestamps entre segmentos gerados em passadas diferentes. O re-encode garante áudio contínuo em 100% dos casos.

**Parâmetro adicional:** `-video_track_timescale 24000` deve ser aplicado uniformemente em todos os segmentos antes da concatenação.

---

## Ken Burns: escala dinâmica (não zoompan com -loop 1)

**Data:** Sessão 13 — 03/08/2026

**Decisão:** O efeito Ken Burns nos Screen Recordings usa escala dinâmica dependente do tempo, não o filtro `zoompan` com `-loop 1`.

**Motivo:** O `zoompan` com `-loop 1` gerava apenas 1 frame de vídeo (duração 0.041s) porque não avançava os frames de entrada.

**Solução aprovada:**
```
scale=2560:1440,crop=2560:1440,setsar=1,fps=24,
scale=w='ceil(2560*(1+0.08*t/DUR)/2)*2':h='ceil(1440*(1+0.08*t/DUR)/2)*2':eval=frame,
crop=w=2560:h=1440:x='(iw-2560)/2':y='(ih-1440)/2',
scale=1280:720:flags=bicubic
```

---

## Landing page: Dark Digital Glitch (não tema claro)

**Data:** Sessão 14 — 04/08/2026

**Decisão:** A identidade visual da landing page é **Dark Digital Glitch** com as cores preto (#0A0A0A), cyan (#00E5FF) e magenta (#FF1744).

**Motivo:** O público-alvo da Movie Money (empreendedores digitais, afiliados TikTok Shop) responde melhor a estéticas tecnológicas e premium. O tema escuro com neon transmite autoridade e modernidade.

---

## Dois criativos por produto: GC + POV obrigatório

**Data:** Sessão 12 — 02/08/2026

**Decisão:** Todo produto minerado deve ter exatamente dois criativos: um GC (Generated Content / review) e um POV (Point of View / câmera subjetiva).

**Motivo:** O teste A/B automático do TikTok Shop favorece lotes com múltiplas variações. GC e POV atingem diferentes estágios do funil (topo vs. fundo), maximizando cobertura.

---

## Produto nos vídeos: idêntico ao produto minerado (Anti-Strike)

**Data:** Sessão 12 — 02/08/2026

**Decisão:** A embalagem, cor, formato e design do produto nos criativos devem ser pixel-perfect iguais ao produto listado na loja.

**Motivo:** Divergência entre produto anunciado e produto entregue gera strike de anúncio falso no TikTok Shop e pode resultar em suspensão da conta.
