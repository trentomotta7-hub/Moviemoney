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

### Causa raiz do lip sync fora e Estratégia Definitiva

**A Regra de Ouro do Lip Sync (Padrão v5):**
Para garantir que o movimento da boca seja idêntico à palavra dita pelo roteiro, **NUNCA** gere takes com `generate_audio=False` para depois sobrepor áudio externo em vídeos de rosto falante.

**O Pipeline Definitivo (Testado e Aprovado):**
1. O roteiro deve ser dividido frase por frase (um take por frase).
2. Em cada take, o texto **EXATO** da fala deve ser incluído no prompt.
3. **OBRIGATÓRIO:** Usar `generate_audio=True` em todos os takes de rosto falante.
4. O modelo gerará o vídeo com o áudio nativo correspondente.
5. Na montagem, **NÃO EXTRAIA** o áudio. Concatene os takes originais completos (vídeo + áudio nativo).
6. Ajuste o volume final com `loudnorm -16 LUFS`.

**Tabela de Estratégias por Formato:**

| Formato | Estratégia de Áudio | Lip Sync |
|---------|---------------------|----------|
| **POV** (mãos, sem rosto) | `generate_audio=False` + TTS externo (Sulafat/Aoede) | N/A — sem boca |
| **GC** (rosto visível) | `generate_audio=True` + Texto exato no prompt + Áudio nativo | **Real** (gerado junto com o vídeo) |

---

## ⚠️ REGRAS CRÍTICAS DE PRODUTO E QUALIDADE — LEIA ANTES DE PRODUZIR

### Regra 1 — Produto Âncora Obrigatório (A Regra de Ouro Anti-Strike)

> **O produto que aparece nos vídeos DEVE SER IDÊNTICO ao produto minerado em TODOS OS TAKES.**

Esta é a regra perpétua mais importante da Movie Money. Se o produto mudar de cor, formato, tampa ou rótulo entre os takes, o vídeo será REPROVADO no QA. O TikTok Shop processa anunciantes por "anúncio falso" (strike grave) se o produto do vídeo diferir do produto entregue.

**O Sistema de Produto Âncora:**
1. Para cada novo produto, rode o script: `bash skills/moviemoney-production/scripts/criar_projeto_produto.sh "nome_produto"`
2. Salve a imagem oficial do produto minerado em: `criativos/nome_produto/produto_ancora/produto_referencia.png`
3. Esta imagem é a sua **ÂNCORA VISUAL**. Ela nunca muda.

**Uso Obrigatório em Geração (IA):**
- Você **DEVE** passar o `produto_referencia.png` no parâmetro `references` (para imagens) ou `keyframes` (para vídeos) em **CADA CHAMADA** de geração onde o produto apareça.
- **Nunca** gere takes com produto baseado apenas em texto (prompt). O modelo vai alucinar designs diferentes a cada take.

**Checklist Anti-Strike:**
- [ ] O arquivo `produto_referencia.png` foi passado como referência no Take 1?
- [ ] O arquivo `produto_referencia.png` foi passado como referência no Take 2?
- [ ] O arquivo `produto_referencia.png` foi passado como referência no Take N?
- [ ] QA forense confirmou que o produto é 100% idêntico do início ao fim?

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
   - **Para GC (Rosto visível):** Manter o áudio nativo gerado junto com o vídeo (`generate_audio=True`). Concatenar as streams juntas.
   - **Para POV (Sem rosto):** Usar vozes naturais (`Sulafat`, `Aoede`, `Vindemiatrix`). Ajustar velocidade com `-af "atempo=X"` e juntar ao vídeo concatenado.
   - Normalizar áudio final de ambos os formatos para **-16 LUFS** (`-af "loudnorm=I=-16:TP=-1.5:LRA=11"`).

4. **Overlays Finais (Marca d'água e Preço):**
   - Marca d'água "MOVIE MONEY": `x=w-tw-20:y=h-th-20:fontsize=18:fontcolor=white:alpha=0.5`
   - Overlay de preço (CTA final): `x=(w-tw)/2:y=h-th-80:fontsize=30:fontcolor=white:alpha=0.95:enable='gte(t,TEMPO_CTA)'`

5. **QA Final:**
   - Sempre rodar `manus-analyze-video` exigindo nota nos critérios: consistência do produto, áudio natural, ritmo, e overlay de preço.

---

## Regras de Ouro de Produção

- **Lip Sync:** A fala no prompt deve ser idêntica ao roteiro. Gerar take de vídeo com lip sync, não usar TTS robótico.
- **Atuação Vocal (Prompt de Áudio Obrigatório):** O áudio (seja via TTS externo ou `generate_audio=True`) **NUNCA** deve receber apenas o texto puro. Você deve fornecer instruções de atuação, emoção, ritmo e respeitar pontuações (vírgulas, pontos).
  - *Exemplo Ruim:* "Compre agora tá barato"
  - *Exemplo Padrão Ouro:* "Fale em português brasileiro com um tom de amiga sincera e urgente. Faça uma pequena pausa após a vírgula para dar ênfase: 'Tá menos de trinta e cinco reais, [pausa leve] e dura uns dois meses!'"
- **Lip Sync Real (GC):** Para vídeos GC, o áudio deve ser nativo (`generate_audio=True`). O prompt de áudio deve conter as instruções de atuação + o texto EXATO do roteiro. Não use TTS externo para vídeos com rosto falante.
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
