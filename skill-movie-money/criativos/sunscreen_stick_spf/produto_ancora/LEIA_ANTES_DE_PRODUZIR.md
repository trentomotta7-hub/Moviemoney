# Produto Âncora — Sunscreen Stick SPF 50+

## ⚠️ REGRA ABSOLUTA

> **`produto_referencia.png` é a imagem oficial do produto minerado.**
> Esta imagem DEVE ser passada como `references` ou `keyframes` em **CADA CHAMADA** de geração de imagem ou vídeo onde o produto apareça.
> Se o produto mudar de visual entre takes → strike no TikTok Shop → conta suspensa.

## Como usar

Em toda chamada de `generate_video` ou `generate_image` onde o produto apareça:

```python
# CORRETO
generate_video(
    prompt="... She holds the [DESCRIÇÃO EXATA DO PRODUTO] ...",
    keyframes={"first": "produto_ancora/produto_referencia.png"},
    ...
)

# CORRETO para imagens
generate_image(
    prompt="...",
    references=["produto_ancora/produto_referencia.png"],
    ...
)

# ERRADO — sem referência = produto vai mudar entre takes
generate_video(prompt="... She holds a sunscreen stick ...")
```

## Descrição Oficial do Produto

- **Nome:** Sunscreen Stick SPF 50+
- **Embalagem:** Bastão compacto, corpo branco, tampa azul claro
- **Rótulo:** "SPF 50+ PA++++ SUNSCREEN STICK"
- **Formato:** Cilíndrico, similar a um batom grande
- **Cor dominante:** Branco com detalhes azul claro

## Checklist Anti-Strike

Antes de montar o vídeo final, verificar:
- [ ] Take 1: produto idêntico à `produto_referencia.png`?
- [ ] Take 2: produto idêntico à `produto_referencia.png`?
- [ ] Take 3: produto idêntico à `produto_referencia.png`?
- [ ] Take 4: produto idêntico à `produto_referencia.png`?
- [ ] QA forense: `manus-analyze-video` confirmou produto consistente?
