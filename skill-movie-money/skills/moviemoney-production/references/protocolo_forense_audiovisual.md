# Protocolo Forense Audiovisual — Movie Money
## REGRA PERPÉTUA: Obrigatório antes de qualquer entrega de vídeo

> **Esta análise é OBRIGATÓRIA. Nenhum vídeo pode ser entregue ao usuário sem passar por este protocolo completo.**
> Entregar vídeo com lip sync fora, cauda morta ou drift de áudio consome crédito à toa e prejudica a operação.

---

## Por que lip sync falha (causa raiz documentada)

O erro mais comum e mais grave é gerar vídeos com `generate_audio=false` e depois substituir o áudio por TTS externo. O modelo de vídeo gera os movimentos labiais para um áudio interno invisível — quando você troca o áudio, a boca não condiz com nada.

**Regra de ouro para lip sync real:**
- Para takes com rosto falando (Talking Head / GC): SEMPRE usar `generate_audio=true` com o texto exato da fala no prompt.
- O modelo sincroniza a boca com o áudio que ele mesmo gera — esse é o único lip sync real disponível.
- Depois de gerado, extrair o áudio nativo do take com ffmpeg e usar na montagem.
- **NUNCA** gerar take com `generate_audio=false` e depois sobrepor TTS externo em vídeos com rosto falando.

---

## Checklist Forense Obrigatório (executar ANTES de entregar)

### Passo 1 — Metadados e Drift de Stream

```bash
ffprobe -v quiet -print_format json -show_format -show_streams VIDEO.mp4 | python3 -c "
import json, sys
d = json.load(sys.stdin)
streams = {s['codec_type']: s for s in d['streams']}
v_dur = float(streams.get('video', {}).get('duration', 0))
a_dur = float(streams.get('audio', {}).get('duration', 0))
drift = abs(v_dur - a_dur)
print(f'Vídeo: {v_dur:.3f}s | Áudio: {a_dur:.3f}s | Drift: {drift:.3f}s')
print('APROVADO' if drift < 0.1 else f'REPROVADO — drift {drift:.3f}s > 0.1s')
"
```

**Critério:** Drift entre stream de vídeo e áudio deve ser < 0.1s. Acima disso, o áudio vai descolar progressivamente.

---

### Passo 2 — Cauda Morta (Tail Silence)

```bash
ffmpeg -i VIDEO.mp4 -af silencedetect=noise=-35dB:d=0.3 -f null - 2>&1 | grep silence_start | tail -3
```

**Critério:** Se houver `silence_start` nos últimos 0.5s do vídeo, há cauda morta. Cortar com:
```bash
ffmpeg -i VIDEO.mp4 -t TEMPO_CORTE -c copy VIDEO_sem_cauda.mp4
```

---

### Passo 3 — Lip Sync (Análise Visual com IA)

```bash
manus-analyze-video VIDEO.mp4 "Analise o lip sync deste vídeo com máxima precisão técnica. Para cada take com rosto falando: 1) A boca se move em sincronia com o áudio? 2) Os fonemas labiais (p, b, m, f, v) coincidem com o áudio? 3) Há delay perceptível entre o movimento labial e o som? 4) O movimento labial parece genérico (não sincronizado) ou específico (sincronizado)? Dê nota 1-10 para lip sync e indique se está APROVADO (>=7) ou REPROVADO (<7)."
```

**Critério:** Nota >= 7/10. Abaixo disso, o take deve ser regerado com `generate_audio=true`.

---

### Passo 4 — Consistência do Produto

```bash
manus-analyze-video VIDEO.mp4 "O produto mostrado (embalagem, cor, formato, rótulo) é IDÊNTICO em todos os takes do vídeo? Liste qualquer diferença visual entre takes. Responda: APROVADO (produto idêntico) ou REPROVADO (produto mudou)."
```

**Critério:** APROVADO obrigatório. Qualquer mudança de embalagem = strike no TikTok Shop.

---

### Passo 5 — Análise Completa Integrada

Após os passos individuais, rodar a análise completa:

```bash
manus-analyze-video VIDEO.mp4 "Você é um auditor técnico especialista em criativos para TikTok Shop. Faça uma auditoria forense completa avaliando: 1) Lip sync (nota 1-10 — boca sincronizada com áudio?), 2) Consistência do produto entre takes (APROVADO/REPROVADO), 3) Cauda morta no final (silêncio > 0.3s?), 4) Drift audiovisual perceptível, 5) Hook nos primeiros 3s, 6) CTA claro no final, 7) Overlay de preço visível, 8) Formato 9:16. Para cada item: nota + APROVADO ou REPROVADO. Nota geral. Veredito final: APROVADO PARA PUBLICAÇÃO ou REPROVADO (liste o que precisa corrigir)."
```

---

## Tabela de Critérios de Aprovação

| Critério | Mínimo para Aprovação | Ação se Reprovado |
|----------|----------------------|-------------------|
| Lip Sync | >= 7/10 | Regerar takes com `generate_audio=true` e texto exato |
| Drift de stream | < 0.1s | Re-encode com `-video_track_timescale 24000` |
| Cauda morta | < 0.3s de silêncio final | Cortar com ffmpeg `-t` |
| Consistência produto | APROVADO | Regerar take com `references=[produto_frente.png]` |
| Hook (0-3s) | Presente e impactante | Reescrever roteiro |
| CTA final | Presente e claro | Adicionar take de CTA |
| Overlay de preço | Visível nos últimos 5s | Adicionar com drawtext |
| Formato 9:16 | Obrigatório | Re-encode com scale=720:1280 |

---

## Solução Definitiva para Lip Sync Real

Para takes com rosto falando (GC, Talking Head), o único método que garante lip sync é:

```python
# CORRETO — lip sync real
generate_video(
    prompt="[visual] A personagem fala: '[TEXTO EXATO DA FALA]'",
    generate_audio=True,   # ← OBRIGATÓRIO para lip sync
    keyframes={"first": "personagem_keyframe.png"}
)

# Depois: extrair áudio nativo do take
# ffmpeg -i take.mp4 -vn -c:a aac take_audio.aac

# ERRADO — lip sync zero
generate_video(generate_audio=False)  # gera boca para áudio interno invisível
# + sobrepor TTS externo = boca não condiz com nada
```

**Para POV (mãos sem rosto):** `generate_audio=false` é aceitável, pois não há boca para sincronizar. O TTS externo funciona bem.

---

## Limitação Técnica Confirmada

> **`gemini-omni-flash-preview` gera movimentos labiais em inglês, independentemente do idioma do prompt.**
> Testado e confirmado em 05/08/2026. Não há workaround disponível sem serviço externo.

**Solução definitiva para lip sync real em português:**
- Integrar HeyGen, Rask.ai ou D-ID para video translation com lip sync nativo
- Enquanto não integrado: usar formato voice-over (personagem em ação sem falar + áudio TTS sobreposto)

## Registro de Bugs de Lip Sync

| Data | Vídeo | Causa | Correção |
|------|-------|-------|----------|
| 05/08/2026 | sunscreen_stick_marina_GC_v1/v2/v3 | gemini-omni gera lábios em inglês | Usar voice-over ou integrar HeyGen |
| 04/08/2026 | video_beto_ceo_v1 (BUG-007) | Keyframes diferentes por take | Keyframe mestre único + atempo |
