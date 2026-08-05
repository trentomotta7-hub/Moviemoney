#!/bin/bash
# Script: criar_projeto_produto.sh
# Uso: bash criar_projeto_produto.sh "nome_do_produto" "caminho/para/imagem_produto.png"
# Cria a estrutura completa de pastas para um novo produto minerado
# e configura o produto âncora automaticamente.

set -e

PRODUTO_NOME="${1:-produto_novo}"
IMAGEM_PRODUTO="${2:-}"
BASE_DIR="/home/ubuntu/Moviemoney/skill-movie-money/criativos"

echo "=== CRIANDO PROJETO: $PRODUTO_NOME ==="

# Criar estrutura de pastas
mkdir -p "$BASE_DIR/$PRODUTO_NOME/produto_ancora"
mkdir -p "$BASE_DIR/$PRODUTO_NOME/imagens_produto"
mkdir -p "$BASE_DIR/$PRODUTO_NOME/POV/takes"
mkdir -p "$BASE_DIR/$PRODUTO_NOME/POV/audio"
mkdir -p "$BASE_DIR/$PRODUTO_NOME/POV/montagem"
mkdir -p "$BASE_DIR/$PRODUTO_NOME/GC/takes"
mkdir -p "$BASE_DIR/$PRODUTO_NOME/GC/audio"
mkdir -p "$BASE_DIR/$PRODUTO_NOME/GC/montagem"

echo "Estrutura de pastas criada."

# Copiar imagem do produto como âncora (se fornecida)
if [ -n "$IMAGEM_PRODUTO" ] && [ -f "$IMAGEM_PRODUTO" ]; then
  cp "$IMAGEM_PRODUTO" "$BASE_DIR/$PRODUTO_NOME/produto_ancora/produto_referencia.png"
  cp "$IMAGEM_PRODUTO" "$BASE_DIR/$PRODUTO_NOME/imagens_produto/produto_frente.png"
  echo "Produto âncora configurado: produto_referencia.png"
else
  echo "ATENÇÃO: Nenhuma imagem fornecida."
  echo "Após minerar o produto, execute:"
  echo "  cp /caminho/imagem.png $BASE_DIR/$PRODUTO_NOME/produto_ancora/produto_referencia.png"
fi

# Criar README do produto âncora
cat > "$BASE_DIR/$PRODUTO_NOME/produto_ancora/LEIA_ANTES_DE_PRODUZIR.md" << 'ANCHOR_EOF'
# Produto Âncora

## ⚠️ REGRA ABSOLUTA — ANTI-STRIKE

> `produto_referencia.png` é a imagem oficial do produto minerado.
> Esta imagem DEVE ser passada como `references` ou `keyframes` em CADA geração de imagem/vídeo onde o produto apareça.
> Produto diferente entre takes = strike no TikTok Shop = conta suspensa.

## Como usar em CADA take

```python
# generate_video — OBRIGATÓRIO passar o produto âncora
generate_video(
    keyframes={"first": "produto_ancora/produto_referencia.png"},
    ...
)

# generate_image — OBRIGATÓRIO passar o produto âncora
generate_image(
    references=["produto_ancora/produto_referencia.png"],
    ...
)
```

## Checklist Anti-Strike (antes de montar o vídeo)
- [ ] Todos os takes usaram produto_referencia.png como referência?
- [ ] QA forense confirmou produto idêntico em todos os takes?
ANCHOR_EOF

echo ""
echo "=== PROJETO CRIADO COM SUCESSO ==="
echo "Caminho: $BASE_DIR/$PRODUTO_NOME"
echo ""
echo "PRÓXIMOS PASSOS:"
echo "1. Salvar imagem oficial do produto em: produto_ancora/produto_referencia.png"
echo "2. Criar roteiro em: roteiro_POV.md e roteiro_GC.md"
echo "3. Gerar takes SEMPRE passando produto_ancora/produto_referencia.png como referência"
echo "4. Rodar protocolo forense antes de entregar"
