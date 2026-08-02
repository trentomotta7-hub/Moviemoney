# Padrões de Produção Movie Money — Referência Técnica

## 1. Especificações de Exportação

| Parâmetro | Valor |
|-----------|-------|
| Resolução base | 1280×720 (HD) |
| Upscale final | 2560×1440 (2K) — opcional |
| FPS | 24 |
| Codec vídeo | H.264 High Profile, CRF 18 |
| Codec áudio | AAC, 192kbps, 48kHz Stereo |
| Loudnorm | -16 LUFS, TP -1.5, LRA 11 |
| Container | MP4 (yuv420p) |

---

## 2. O Equilíbrio 50/50 (Regra de Ouro)

O vídeo deve alternar constantemente entre o porta-voz e a prova real na tela.

- **Talking Head (TH):** Hooks, viradas de assunto, CTAs e conclusões lógicas.
- **Screen Recording (SC):** Demonstração de código, terminal, dashboards, produto em uso.
- **Ritmo:** Nunca exceder 7 segundos na mesma imagem sem corte ou movimento.

---

## 3. Transições e Dinamismo

### Crossfade entre Takes TH
```bash
ffmpeg -y \
  -i take_a.mp4 -i take_b.mp4 \
  -filter_complex "[0][1]xfade=transition=fade:duration=0.3:offset=OFFSET[v];[0:a][1:a]acrossfade=d=0.3[a]" \
  -map "[v]" -map "[a]" \
  -c:v libx264 -preset medium -crf 18 -pix_fmt yuv420p \
  -c:a aac -b:a 192k output.mp4
```

### Ken Burns nos SCs (zoom 1.0 → 1.08)
```bash
-vf "scale=4000:-1,zoompan=z='min(zoom+0.0005,1.08)':d=125:x='iw/2-(iw/zoom/2)':y='ih/2-(ih/zoom/2)':s=1280x720"
```

---

## 4. Safe Zone e Legendas

- **Estilo:** Amarelo (#FFD700) e Branco, estilo Karaokê (highlight por palavra)
- **Posicionamento:** Exatamente **320px** da borda inferior
- **Motivo:** Evitar obstrução pelo carrinho laranja do TikTok Shop

---

## 5. Áudio — Regras Críticas

### ✅ CORRETO — Áudio de SC com voz real do personagem
```python
# 1. Gerar take de vídeo do personagem falando o texto do VO (com lip sync)
# 2. Extrair o áudio desse take
ffmpeg -y -i vo_take.mp4 -vn -ar 48000 -ac 2 -acodec pcm_s16le vo_audio.wav
# 3. Aplicar o áudio extraído sobre o SC animado
ffmpeg -y -i sc_anim.mp4 -i vo_audio.wav \
  -c:v copy -c:a aac -b:a 192k \
  -map 0:v -map 1:a -t DURATION sc_com_vo.mp4
```

### ❌ ERRADO — Nunca usar TTS robótico (gTTS, pyttsx3, etc.)
O uso de TTS genérico causa:
- Voz robótica incoerente com o personagem
- Troca de voz entre segmentos (bug crítico)
- Experiência de usuário degradada

### Normalização de Volume (Loudnorm)
```bash
-af "loudnorm=I=-16:TP=-1.5:LRA=11"
```
Aplicar em TODOS os segmentos antes da concatenação final.

---

## 6. Pipeline de Montagem (Ordem Obrigatória)

```
1. Gerar takes TH com fala exata (lip sync) → takes_v{n}/
2. Gerar takes VO do personagem para cada SC → takes_v{n}_vo/
3. Gerar SCs animados (terminal, código, produto) → screens_v{n}_anim/
4. Normalizar todos os takes (1280x720, loudnorm -16 LUFS)
5. Combinar SC animado + áudio do take VO correspondente
6. Concatenar na ordem EXATA do roteiro
7. Aplicar marca d'água
8. Rodar manus-analyze-video para verificação pré-entrega
9. Corrigir bugs encontrados antes de entregar
```

---

## 7. Verificação Pré-Entrega (Checklist)

Antes de entregar qualquer vídeo, verificar:

- [ ] Zero voz robótica em qualquer segmento
- [ ] Voz contínua durante os SCs (não silêncio)
- [ ] Lip sync correto nos takes TH
- [ ] Telas com movimento (não prints estáticos)
- [ ] Volume consistente em todos os segmentos (-16 LUFS)
- [ ] Logo final com SFX (não silêncio absoluto)
- [ ] Produto nos SCs idêntico ao produto minerado
- [ ] Duração total dentro do esperado para o formato

---

## 8. Upscale Final para 2K (Opcional)

```bash
ffmpeg -y -i video_1280x720.mp4 \
  -vf "scale=2560:1440:flags=lanczos" \
  -c:v libx264 -preset slow -crf 16 -pix_fmt yuv420p \
  -c:a copy \
  video_2560x1440.mp4
```
