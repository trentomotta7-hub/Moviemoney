# Plano de Produção — POV Sunscreen Stick SPF 50+

**Data de início:** 05/08/2026  
**Persona:** Marina Costa (A Amiga Sincera)  
**Duração alvo:** 28-32 segundos  
**Formato:** 9:16 (1080x1920) — TikTok nativo  
**Voz:** Marina Costa (Fenrir TTS feminino)  

---

## Fase 1: Geração de Assets (Áudio + Vídeos POV)

### 1.1 — Gerar áudio da voz Marina (5 takes)

**Hook (original):**
> "Gente, eu passava protetor solar UMA vez de manhã e achava que tava protegida o dia inteiro..."

**Corpo (narração central):**
> "Aí eu vi que minha pele tava manchando mesmo usando protetor. E reaplicar no meio do dia? Com maquiagem? Com as mãos sujas? Impossível. O problema é que protetor líquido não foi feito pra reaplicar. Suja a mão, estraga a make, e a gente simplesmente... não reaplica. E aí o sol ganha. Aí eu descobri esse bastão. Olha: abre, passa direto no rosto, fecha e guarda. 15 segundos. Sem sujar a mão, sem estragar maquiagem, SPF 50 de verdade. Eu reaplico no carro, no trabalho, em qualquer lugar."

**CTA (original):**
> "Meninas, esse aqui tá menos de 35 reais e dura uns 2 meses. Toca no carrinho laranja antes que esgote — já acabou 2 vezes esse mês."

**Arquivo esperado:** `POV/audio/marina_voz_completa.mp3`

### 1.2 — Gerar takes POV (mãos + produto)

**Beat 1 — Hook (0-3s):** POV mãos tirando bastão de bolsa, luz natural carro  
**Beat 2 — Problema (3-9s):** POV celular com selfie manchada, mãos com protetor líquido  
**Beat 3 — Causa (9-14s):** POV tubo genérico, gesto de "não", relógio 12h  
**Beat 4 — Solução (14-26s):** POV mãos aplicando bastão no rosto, mão limpa, guardando  
**Beat 5 — CTA (26-30s):** POV produto em destaque, mão apontando para carrinho  

**Arquivos esperados:**
- `POV/takes/beat1_hook.mp4` (3s)
- `POV/takes/beat2_problema.mp4` (6s)
- `POV/takes/beat3_causa.mp4` (5s)
- `POV/takes/beat4_solucao.mp4` (12s)
- `POV/takes/beat5_cta.mp4` (4s)

---

## Fase 2: Montagem com FFmpeg

### 2.1 — Concatenar beats
```bash
ffmpeg -f concat -safe 0 -i concat_list.txt -c:v libx264 -c:a aac \
  -pix_fmt yuv420p -video_track_timescale 24000 \
  POV/montagem/video_sem_marca.mp4
```

### 2.2 — Normalizar áudio
```bash
ffmpeg -i POV/montagem/video_sem_marca.mp4 \
  -af loudnorm=I=-16:TP=-1.5:LRA=11 \
  POV/montagem/video_normalizado.mp4
```

### 2.3 — Adicionar marca d'água
```bash
ffmpeg -i POV/montagem/video_normalizado.mp4 \
  -vf "drawtext=text='MOVIE MONEY':x=1050:y=1850:fontsize=24:fontcolor=white:alpha=0.7" \
  POV/montagem/sunscreen_stick_spf_pov_v1_FINAL.mp4
```

---

## Fase 3: QA e Validação

- [ ] Rodar `manus-analyze-video` no vídeo final
- [ ] Verificar safe zone 320px (legendas visíveis)
- [ ] Verificar lip sync (se houver rosto)
- [ ] Verificar duração (28-32s)
- [ ] Verificar resolução (1080x1920)
- [ ] Verificar áudio normalizado (-16 LUFS)
- [ ] Verificar marca d'água visível

---

## Fase 4: Commit e Push

```bash
git add skill-movie-money/criativos/sunscreen_stick_spf/
git commit -m "feat(sunscreen-stick): POV v1 — Marina Costa, 30s, QA aprovado"
git push origin master
```

---

## Checklist de Execução

- [ ] Áudio Marina gerado (5 variações)
- [ ] Takes POV gerados (5 beats)
- [ ] Vídeo concatenado
- [ ] Áudio normalizado
- [ ] Marca d'água aplicada
- [ ] QA executado
- [ ] Commit realizado
- [ ] Push concluído

---

## Próximas Ações (Após conclusão)

1. Gerar variações de hook (5 variações) + CTA (4 variações) = 20 vídeos
2. Publicar no TikTok Shop
3. Monitorar performance (CTR, conversão, watch time)
4. Produzir Vídeo 3 "A Oferta" (VSL)
5. Integrar backend de leads na landing page
