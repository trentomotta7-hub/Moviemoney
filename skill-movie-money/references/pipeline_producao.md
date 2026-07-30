# Pipeline de Produção de Criativos — Movie Money

Fluxo padrão para produzir um criativo de venda a partir de um produto minerado. Executar as etapas em ordem.

## Entrada Esperada

O usuário (ou lead) fornece: nome do produto, link ou imagens do produto (vindas do site de mineração), público-alvo (se souber) e formato desejado (POV, UGC ou ambos). Se faltar apenas o formato, decidir pelo produto: produtos de demonstração física/uso manual favorecem POV; produtos de transformação/experiência pessoal favorecem UGC.

## Etapa 1 — Análise do Produto e Escalação

Analisar o produto: benefício principal, dor que resolve, público-alvo, faixa de preço. Selecionar 1–2 personagens do elenco pelo nicho (tabela em `references/elenco.md`) e a cena mais adequada do banco (`templates/cenas/`).

## Etapa 2 — Roteiro

Escrever roteiro seguindo a estrutura obrigatória, com duração alvo de 25–40 segundos:

| Seção | Tempo | Função |
|-------|-------|--------|
| Hook | 0–4s | Parar a rolagem. Usar hook-assinatura do personagem ou variação. Nunca começar com o nome do produto. |
| Problema | 4–10s | A dor do público, em primeira pessoa, relato pessoal. |
| Causa | 10–16s | Por que as soluções comuns falham (agita o problema). |
| Solução | 16–30s | Apresentar o produto como descoberta, mostrar benefícios concretos, prova. |
| CTA | últimos 4–6s | Comando direto + urgência/escassez ("toca no carrinho laranja antes que acabe"). |

Escrever o roteiro no tom de voz do personagem escalado (vocabulário e ritmo definidos em `references/elenco.md`). Para venda invisível, o texto deve soar como relato espontâneo, nunca como anúncio.

## Etapa 3 — Produção dos Takes de Vídeo

Gerar os takes por seção do roteiro, sempre em 9:16 (portrait):

**Formato UGC:** para cada take, usar como keyframe/referência a imagem da cena escolhida do personagem (`templates/cenas/{personagem}/{cena}.png`). No prompt de vídeo, incluir a fala exata do trecho do roteiro (em PT-BR) e exigir lip sync natural, estilo selfie UGC, com áudio. Manter o mesmo personagem e cena entre takes contíguos; trocar de cena apenas entre seções, se fizer sentido narrativo.

**Formato POV:** usar as imagens do produto (mineração) como referência para gerar cenas em primeira pessoa — câmera na altura dos olhos/ombro, mãos manipulando o produto, ambiente doméstico realista. A narração descreve os benefícios enquanto as mãos demonstram. Preservar fielmente a forma, cor e rótulos do produto.

Gerar cada take com duração de 4–10 segundos. Para o take do hook, priorizar movimento e impacto visual imediato no primeiro segundo.

## Etapa 4 — Montagem Final

Concatenar os takes com `ffmpeg` na ordem do roteiro. Adicionar legendas queimadas (estilo TikTok: fonte bold, palavras destacadas, centralizadas no terço inferior) — legendas aumentam retenção. Verificar áudio contínuo e transições limpas. Exportar MP4 vertical.

## Etapa 5 — Controle de Qualidade

Verificar antes de entregar: (1) hook prende nos 4 primeiros segundos, (2) lip sync natural nos takes UGC, (3) produto visualmente fiel às imagens da mineração, (4) CTA claro e forte no final, (5) duração total entre 25–45 segundos, (6) identidade do personagem consistente entre takes.

## Regra de Ouro

Nunca pedir ao usuário para filmar, fotografar ou fornecer material próprio. Toda a produção é gerada internamente a partir das imagens de mineração e dos assets do elenco.
