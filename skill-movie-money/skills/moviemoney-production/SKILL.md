---
name: moviemoney-production
description: "Produção de vídeos institucionais e criativos de alta conversão para a marca Movie Money. Use para: criar vídeos do YouTube com o personagem Beto, aplicar o Modo 50/50, configurar lip sync perfeito, transições crossfade e legendas na Safe Zone de 320px. Inclui regras de mineração de produto, consistência de imagem e obrigatoriedade de dois criativos por produto (GC + POV)."
---

# Movie Money Video Production

Esta skill automatiza o rigor técnico e o estilo visual dos vídeos da Movie Money, garantindo consistência entre o porta-voz (Beto) e as demonstrações técnicas.

---

## ⚠️ REGRAS CRÍTICAS DE PRODUTO — LEIA ANTES DE QUALQUER PRODUÇÃO

### Regra 1 — Consistência de Imagem do Produto (Anti-Strike)

> **O produto que aparece nos vídeos e nas fotos dos criativos DEVE SER IDÊNTICO ao produto minerado.**

Isso significa:
- A embalagem, cor, formato e design do produto no criativo devem ser **pixel-perfect** iguais ao produto listado na loja.
- **Nunca** usar imagens genéricas ou similares de outros fornecedores.
- **Nunca** alterar digitalmente a embalagem de forma que o produto pareça diferente do que o cliente vai receber.
- Usar sempre a imagem oficial do produto minerado como referência visual para todos os takes.
- Motivo: divergência entre o produto anunciado e o produto entregue gera **strike de anúncio falso** no TikTok Shop e pode resultar em suspensão da conta.

**Fluxo correto:**
1. Minerar o produto → salvar as imagens oficiais em `criativos/{produto}/imagens_produto/`
2. Usar essas imagens como referência visual em TODOS os takes e criativos daquele produto
3. Verificar antes de publicar: o produto no vídeo é idêntico ao produto na página da loja?

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

### Fase 3 — Processamento e Montagem
1. Normalizar todos os takes para 1280x720, loudnorm -16 LUFS
2. Gerar SCs animados (Ken Burns ou animação de produto)
3. Combinar SC visual + áudio do take VO (lip sync real, não TTS)
4. Concatenar na ordem do roteiro
5. Aplicar marca d'água
6. Verificar com `manus-analyze-video` antes de entregar

---

## Regras de Ouro de Produção

- **Lip Sync:** A fala no prompt deve ser idêntica ao roteiro. Gerar take de vídeo com lip sync, não usar TTS robótico.
- **Áudio SC:** Sempre usar o áudio extraído de um take de vídeo do personagem, nunca TTS de terceiros.
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
