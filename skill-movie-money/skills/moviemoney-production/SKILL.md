---
name: moviemoney-production
description: "Produção de vídeos institucionais e criativos de alta conversão para a marca Movie Money. Use para: criar vídeos do YouTube com o personagem Beto, aplicar o Modo 50/50, configurar lip sync perfeito, transições crossfade e legendas na Safe Zone de 320px. Inclui regras de mineração de produto, consistência de imagem, obrigatoriedade de dois criativos por produto (GC + POV) e protocolo forense audiovisual obrigatório antes de qualquer entrega."
---

# Movie Money Video Production

Esta skill automatiza o rigor técnico e o estilo visual dos vídeos da Movie Money, garantindo consistência entre o porta-voz (Beto) e as demonstrações técnicas.

---

## 🚨 REGRA PERPÉTUA — AUDITORIA FORENSE ANTES DE QUALQUER ENTREGA

> **ORDEM PERMANENTE: Nenhum vídeo pode ser entregue ao usuário sem passar pelo protocolo forense completo.**
> Entregar vídeo com lip sync fora, cauda morta ou produto inconsistente desperdiça crédito e prejudica a operação.

**Antes de entregar qualquer vídeo, execute obrigatoriamente:**
1. `ffprobe` — verificar drift entre stream de vídeo e áudio (deve ser < 0.1s)
2. `silencedetect` — verificar cauda morta no final (silêncio > 0.3s = reprovar)
3. `manus-analyze-video` com prompt de auditoria forense de lip sync (nota >= 7/10)
4. `manus-analyze-video` com prompt de consistência de produto (APROVADO obrigatório)

O protocolo completo com comandos exatos está em: `references/protocolo_forense_audiovisual.md`

### Causa raiz do lip sync fora (BUG documentado e limitação técnica)

**Limitação permanente do `gemini-omni-flash-preview`:** O modelo gera movimentos labiais em inglês, independentemente do idioma do prompt. Não há como obter lip sync nativo em português com este modelo. Isso foi testado e confirmado em 05/08/2026.

**Estratégias válidas por formato:**

| Formato | Estratégia | Lip Sync |
|---------|-----------|----------|
| **POV** (mãos, sem rosto) | `generate_audio=False` + TTS externo | N/A — sem boca |
| **GC** (rosto visível) | Takes com personagem em movimento natural (sem falar) + narração em voice-over | Não há boca falando = sem problema |
| **GC com lip sync real** | Integração com HeyGen / Rask.ai / D-ID (serviço externo) | Real |

**Regra de ouro para GC sem serviço externo:**
- Gerar takes com a personagem em ação (demonstrando produto, gesticulando, reagindo) — SEM falar diretamente
- Adicionar narração em voice-over (TTS Sulafat/Aoede) sobre as imagens
- Resultado: vídeo coerente, sem lip sync falso, visualmente profissional
- Isso é amplamente usado em UGC profissional e não prejudica a conversão

---

## ⚠️ REGRAS CRÍTICAS DE PRODUTO E QUALIDADE — LEIA ANTES DE PRODUZIR

### Regra 1 — Consistência de Imagem do Produto (A Regra de Ouro Anti-Strike)

> **O produto que aparece nos vídeos DEVE SER IDÊNTICO ao produto minerado em TODOS OS TAKES.**

Esta é a regra perpétua mais importante da Movie Money. Se o produto mudar de cor, formato, tampa ou rótulo entre os takes, o vídeo será REPROVADO no QA.

**O que isso significa na prática:**
- A embalagem, cor, formato e design do produto no criativo devem ser **pixel-perfect** iguais ao produto listado na loja.
- **Nunca** usar imagens genéricas ou similares. Se o produto é um "Sunscreen Stick branco com base azul", ele NÃO PODE aparecer como um "tubo branco" ou "bastão todo azul" em takes subsequentes.
- Para geração com IA (`generate_video` ou `generate_image`), você **DEVE** passar a imagem oficial do produto no parâmetro `references` ou `keyframes` em **CADA CHAMADA** de geração onde o produto apareça.
- Motivo: divergência visual gera **strike de anúncio falso** no TikTok Shop, banimento da conta e reprovação imediata no QA.

**Fluxo obrigatório:**
1. Minerar o produto → salvar a foto oficial frontal como `produto_frente.png`
2. Gerar keyframes para cada take passando `produto_frente.png` como referência
3. Gerar vídeos passando os keyframes consistentes
4. QA obrigatório: "O produto é exatamente o mesmo do início ao fim?"

---

### Regra 2 — Dois Criativos por Produto (GC + POV)

> **Todo produto minerado deve ter, no mínimo, DOIS criativos: um GC (Generated Content) e um POV (Point of View).**

| Formato | Descrição | Quando usar |
|---------|-----------|-------------|
| **GC** (Generated Content) | Personagem UGC fala sobre o produto, demonstra, recomenda. Câmera estática ou leve movimento. Tom: depoimento/review. | Topo de funil — apresentação do produto |
| **POV** (Point of View) | Câmera na perspectiva do usuário. O espectador "vê" o produto sendo usado como se fosse ele mesmo. Tom: imersivo, experiencial. | Meio/fundo de funil — conversão |

**Regras de execução:**
- Os dois criativos devem usar o **mesmo produto** (imagem idêntica — ver Regra 1)
- Podem usar **personas diferentes** (ex: GC com Marina, POV com Lucas)
- Devem usar **dores diferentes** do Banco Narrativo para o mesmo produto
- Devem ser publicados **no mesmo lote** de anúncios para teste A/B automático
- Nomenclatura obrigatória: `{produto}_{persona}_{tipo}_v{n}.mp4`
  - Exemplo: `bodysplash_marina_GC_v1.mp4` e `bodysplash_lucas_POV_v1.mp4`

---

## Fluxo de Trabalho Principal

### Fase 0 — Mineração de Produto (pré-produção)
1. Minerar produto no TikTok Shop / AliExpress
2. Salvar imagens oficiais em `criativos/{produto}/imagens_produto/`
3. Definir as 2 dores do Banco Narrativo que serão usadas (uma para GC, uma para POV)
4. Definir as 2 personas (uma para GC, uma para POV)
5. Criar pasta `criativos/{produto}/` com subpastas `GC/` e `POV/`

### Fase 1 — Plano de Takes
- Dividir o roteiro em blocos de Talking Head (TH) e Screen Recording (SC) na proporção 50/50
- Para GC: 4 takes TH + 2 SCs de produto
- Para POV: 3 takes POV (câmera subjetiva) + 1 SC de produto

### Fase 2 — Geração de Assets
- **TH/POV:** Usar keyframe do personagem como referência. Incluir a fala exata no prompt para lip sync.
- **SC:** Usar imagens oficiais do produto minerado (Regra 1). Nunca usar imagens genéricas.
- **VO:** Gerar take de Beto/persona falando o texto do VO com lip sync real. O áudio do VO é extraído e aplicado sobre o SC.

### Fase 3 — Pipeline de Edição e Montagem (Padrão Ouro)

Siga EXATAMENTE este pipeline bash para garantir qualidade profissional:

1. **Normalização de Takes (Vídeo):**
   - Resolução: 720x1280 (9:16)
   - FPS: 30fps
   - Codec: H.264 (`-c:v libx264 -preset fast -crf 23`)
   - Prevenir problemas de concat: remover áudio original (`-an`) e forçar aspect ratio.

2. **Concatenação:**
   - Usar `concat_list.txt` e `ffmpeg -f concat`.
   - Obrigatório: `-video_track_timescale 24000` para evitar dessincronia.

3. **Áudio (Voz e Normalização):**
   - Para personagens (ex: Marina Costa), **NÃO USAR VOZ ROBÓTICA**.
   - Testar e escolher vozes naturais com emoção e respiração (ex: `Sulafat`, `Aoede`, `Vindemiatrix`).
   - Ajustar velocidade do áudio com `-af "atempo=X"` para caber na duração visual.
   - Juntar áudio e vídeo concatenado.
   - Normalizar áudio final para **-16 LUFS** (`-af "loudnorm=I=-16:TP=-1.5:LRA=11"`).

4. **Overlays Finais (Marca d'água e Preço):**
   - Marca d'água "MOVIE MONEY": `x=w-tw-20:y=h-th-20:fontsize=18:fontcolor=white:alpha=0.5`
   - Overlay de preço (CTA final): `x=(w-tw)/2:y=h-th-80:fontsize=30:fontcolor=white:alpha=0.95:enable='gte(t,TEMPO_CTA)'`

5. **QA Final:**
   - Sempre rodar `manus-analyze-video` exigindo nota nos critérios: consistência do produto, áudio natural, ritmo, e overlay de preço.

---

## Regras de Ouro de Produção

- **Lip Sync:** A fala no prompt deve ser idêntica ao roteiro. Gerar take de vídeo com lip sync, não usar TTS robótico.
- **Vozes Naturais:** Nunca use TTS robótico sem emoção. Para UGC, use vozes com pausas naturais, respiração e entonação de "amiga/amigo" (ex: vozes da skill tts-prompter com instruções de atuação). Ajuste a velocidade (`atempo`) no ffmpeg para manter o dinamismo.
- **Dinamismo:** Alternar entre personagem e tela a cada 5-7 segundos.
- **Transições:** Crossfade de 0.3s entre takes do mesmo personagem.
- **Safe Zone:** Legendas e elementos críticos acima de 320px da base.
- **Volume:** Loudnorm -16 LUFS em todos os segmentos para consistência.
- **Logo final:** Sempre com SFX de notificação de venda (não silêncio).
- **Análise pré-entrega:** Sempre rodar `manus-analyze-video` antes de entregar ao usuário.

---

## Estrutura de Pastas por Produto

```
criativos/
└── {produto}/                    # ex: bodysplash_marina
    ├── imagens_produto/          # imagens OFICIAIS do produto minerado
    │   ├── produto_frente.jpg
    │   ├── produto_verso.jpg
    │   └── produto_uso.jpg
    ├── GC/
    │   ├── roteiro_GC.md
    │   ├── takes/
    │   └── {produto}_{persona}_GC_v1.mp4
    └── POV/
        ├── roteiro_POV.md
        ├── takes/
        └── {produto}_{persona}_POV_v1.mp4
```

---

## Referências Técnicas

- `references/video_standards.md` — comandos ffmpeg, parâmetros de upscale, Ken Burns
- Repositório `trentomotta7-hub/Moviemoney` — templates de personagens, vozes e cenas
- Banco Narrativo — 70 dores mapeadas em `criativos/banco_narrativo.md`
