# Plano de Takes — Vídeo 2: "A Máquina por Dentro"
**Data:** 01/08/2026 | **Sessão 10**

## Visão Geral

| Parâmetro | Valor |
|-----------|-------|
| Duração alvo | 8–10 min |
| Personagem | Beto (keyframe: `beto_keyframe_16x9.jpg`) |
| Voz TTS | Fenrir (pt-BR) |
| Resolução takes | 1280×720 → upscale 2560×1440 |
| Duração por take TH | 10–12s |
| Crossfade entre TH | 0.3s fade |
| Estrutura | Equilíbrio 50/50 (Tela/Beto) |

---

## Regras de Produção (Skill: moviemoney-production)

1. **Equilíbrio 50/50:** Alternar entre Beto e Tela a cada 5-7 segundos para máximo dinamismo.
2. **Lip sync:** Fala exata entre aspas no prompt de geração do vídeo.
3. **Sem takes de gesto:** Apenas takes de fala direta para evitar redundância.
4. **Crossfade 0.3s:** Aplicar entre todos os takes TH para simular um vídeo contínuo.
5. **Ken Burns:** Zoom dinâmico 1.0→1.08 em todos os Screen Recordings.
6. **Safe Zone:** Legendas posicionadas a 320px da borda inferior.
7. **Normalização:** Todos os segmentos em 48kHz stereo.

---

## Seção 1 — Hook da Prova Lógica (0:00 – 2:00 aprox.)

### TH-1a — Hook Matemático (12s)
**Fala exata:**
> "Mano, eu vou te provar matematicamente porque você tá perdendo dinheiro. Imagina que eu te dou esse produto pra vender no TikTok Shop. Qual a primeira coisa que você faz?"

**Prompt visual:** Beto no escritório moderno, segurando um frasco de perfume na mão direita, olhando diretamente para a câmera com expressão confiante e levemente desafiadora. Gesticula com a mão livre.

---

### TH-1b — Resposta do Algoritmo (12s)
**Fala exata:**
> "Você pega um vídeo do AliExpress, corta no CapCut, joga uma voz de robô e sobe o anúncio. Sabe o que o algoritmo faz com esse vídeo? Ele pune."

**Prompt visual:** Beto no escritório, expressão séria, aponta para a câmera ao dizer "ele pune".

---

### SC-1 — Vídeo Genérico com Voz Robótica
**Imagem:** Screenshot de um vídeo de anúncio genérico no TikTok com interface do app, mostrando um produto com legenda de IA robótica em inglês, CPM alto visível nas métricas.
**VO (Fenrir):**
> "O TikTok não quer que o usuário saia do app. Se o seu vídeo grita anúncio falso, o usuário rola a tela em dois segundos. Retenção zero. CPM nas alturas."
**Duração:** ~8s | Ken Burns ativo

---

### TH-1c — Abertura da Caixa Preta (12s)
**Fala exata:**
> "No último vídeo, eu te mostrei que venda na internet é puramente uma questão de ótica. Hoje, eu vou abrir a caixa preta. Eu vou te mostrar a engrenagem da Movie Money por dentro."

**Prompt visual:** Beto no escritório, se inclina levemente para frente, expressão reveladora, como quem vai contar um segredo.

---

### TH-1d — O que a Máquina Faz (12s)
**Fala exata:**
> "Como a gente substituiu uma agência inteira por uma máquina que gera criativos com lip sync real, atores que não existem e legendas na Safe Zone."

**Prompt visual:** Beto no escritório, gesticula com as mãos ao enumerar os três elementos, expressão orgulhosa.

---

## Seção 2 — A Arquitetura do Repositório (2:00 – 5:00 aprox.)

### SC-2 — VS Code com Repositório Aberto
**Imagem:** Screenshot do VS Code com o repositório `trentomotta7-hub/Moviemoney` aberto, mostrando a estrutura de pastas: `skill-movie-money/`, `templates/`, `personagens/`, `criativos/`. Tema dark, fonte clara.
**VO (Fenrir):**
> "Isso aqui não é uma pastinha no Google Drive. É uma infraestrutura de engenharia. A gente mapeou tudo. Dá uma olhada nessa pasta aqui: Templates de Personagens."
**Duração:** ~10s | Ken Burns ativo

---

### SC-3 — Grid dos 5 Personagens UGC
**Imagem:** Grid 5 fotos lado a lado dos personagens UGC (Lucas, Marina, Rafael, Beatriz, Diego) com seus nomes e nichos escritos abaixo de cada um. Fundo escuro, estilo apresentação profissional.
**VO (Fenrir):**
> "Esses cinco rostos cobrem noventa por cento dos nichos lucrativos. O Lucas pra tech. A Marina pra beleza. O Rafael pra fitness. A Beatriz pra produtividade. E o Diego pra produtos virais. Eles não são atores de banco de imagens. São personas consistentes."
**Duração:** ~14s | Ken Burns ativo

---

### TH-2a — Elenco Nunca Atrasa (10s)
**Fala exata:**
> "Se a Marina faz sucesso vendendo um bodysplash pra você, a gente usa a Marina pra escalar a sua operação com variações de hook. Ela nunca atrasa. Ela nunca cobra a mais."

**Prompt visual:** Beto no escritório, sorriso leve de canto, braços cruzados com confiança.

---

### TH-2b — Você Gerencia a Loja (10s)
**Fala exata:**
> "Você gerencia a loja. Nós gerenciamos o elenco."

**Prompt visual:** Beto no escritório, aponta para si mesmo ao dizer "nós" e depois aponta para a câmera ao dizer "você". Expressão direta e confiante.

---

## Seção 3 — O Banco Narrativo (5:00 – 8:30 aprox.)

### SC-4 — Arquivo banco_narrativo.md Aberto
**Imagem:** Screenshot do arquivo `banco_narrativo.md` aberto no VS Code, mostrando a lista de dores mapeadas com categorias (B1, B2, C1...) e descrições em português. Cursor parado na dor "B1: Cheiro que não dura".
**VO (Fenrir):**
> "Ter um rosto bonito não serve de nada se o roteiro for fraco. O cérebro humano compra por emoção e justifica pela lógica. É por isso que a gente criou o Banco Narrativo."
**Duração:** ~10s | Ken Burns ativo

---

### SC-5 — Rolagem pelo Banco de Dores
**Imagem:** Screenshot do terminal ou editor mostrando uma lista de 70 dores mapeadas, com destaque visual na dor "Cheiro que não dura". Números de linha visíveis, estilo código.
**VO (Fenrir):**
> "A gente analisou mais de trinta e quatro mil vídeos no TikTok. Nós mapeamos setenta dores reais do mercado brasileiro. A gente não inventa que o perfume tem notas amadeiradas. Ninguém liga pra isso."
**Duração:** ~12s | Ken Burns ativo

---

### SC-6 — Terminal Gerando Vídeo com Hook Real
**Imagem:** Screenshot do terminal com saída do ffmpeg gerando um vídeo, mostrando o hook "Passei esse body splash de manhã e minha amiga perguntou o que eu tava usando às dez da noite" como texto visível no processo.
**VO (Fenrir):**
> "A gente escreve: Passei esse body splash de manhã e minha amiga perguntou o que eu tava usando às dez da noite. É assim que a gente estrutura o funil de atenção: Hook nos primeiros quatro segundos. Agitação. Causa. Solução. CTA."
**Duração:** ~14s | Ken Burns ativo

---

## Seção 4 — Lip Sync e Safe Zone (8:30 – 11:30 aprox.)

### TH-3a — A Cereja do Bolo (10s)
**Fala exata:**
> "Agora, a cereja do bolo. O que separa os amadores dos profissionais no TikTok Shop."

**Prompt visual:** Beto no escritório, se aproxima levemente da câmera, expressão de quem vai revelar o segredo mais importante.

---

### SC-7 — Comparação Lado a Lado: IA Genérica vs Movie Money
**Imagem:** Screenshot de dois vídeos lado a lado. Esquerda: vídeo de IA genérica com boca dessincronizada, label "AMADOR" em vermelho. Direita: criativo da Marina com lip sync perfeito, label "MOVIE MONEY" em verde. Interface do TikTok visível.
**VO (Fenrir):**
> "A esquerda é o que os gurus te ensinam a fazer. O lábio mexe, mas não forma as palavras. O cérebro do cliente detecta isso em milissegundos e aciona o alerta de golpe. A direita é a Movie Money. Sincronia labial perfeita. O prompt de geração recebe a fala exata. É indetectável."
**Duração:** ~16s | Ken Burns ativo

---

### SC-8 — Legendas na Safe Zone
**Imagem:** Screenshot de um vídeo do TikTok Shop mostrando as legendas em amarelo e branco posicionadas 320px acima da borda inferior, com o carrinho laranja do TikTok Shop visível na parte de baixo e as legendas claramente acima dele. Seta apontando para a posição das legendas.
**VO (Fenrir):**
> "E não para por aí. Legendas. A gente queima as legendas em amarelo e branco no estilo karaokê. Mas repara na posição. A gente eleva as legendas trezentos e vinte pixels acima da borda inferior. Pra não ficar escondida atrás daquele carrinho laranja do TikTok Shop."
**Duração:** ~14s | Ken Burns ativo

---

### TH-3b — Engenharia de Conversão (10s)
**Fala exata:**
> "Engenharia de conversão. É isso que a gente faz."

**Prompt visual:** Beto no escritório, expressão séria e confiante, faz um gesto afirmativo com a cabeça.

---

## Seção 5 — CTA de Transição para o VSL (11:30 – Fim)

### TH-4a — Você Viu a Máquina (12s)
**Fala exata:**
> "Você viu a máquina por dentro. Você viu o nível de detalhe que a gente aplica em um único vídeo de trinta segundos. Imagina ter essa máquina rodando vinte e quatro horas por dia pra sua loja."

**Prompt visual:** Beto no escritório, relaxa na cadeira, cruza os braços, expressão satisfeita.

---

### TH-4b — A Boa Notícia (12s)
**Fala exata:**
> "A boa notícia é que você não precisa construir essa máquina. A gente já construiu. E a gente tá liberando acesso pra quem quer parar de brincar de dropshipping e começar a operar como empresa grande."

**Prompt visual:** Beto no escritório, descruza os braços, se inclina para frente com energia crescente.

---

### TH-4c — O Próximo Vídeo (12s)
**Fala exata:**
> "No próximo vídeo, eu vou te fazer uma oferta direta. Sem enrolação. Vou te mostrar como plugar a Movie Money na sua operação hoje."

**Prompt visual:** Beto no escritório, aponta para a câmera com dedo indicador, expressão determinada e direta.

---

### SC-9 — Logo Movie Money Final
**Imagem:** Logo da Movie Money centralizada em fundo escuro (#0a0a0a), com brilho sutil. Texto abaixo: "ASSISTA AO VÍDEO 3 — A OFERTA". Efeito de fade in suave.
**Duração:** 5s | Sem Ken Burns (estático com fade)

---

## Resumo de Assets a Gerar

### Takes de Talking Head (8 takes)
| ID | Seção | Duração | Fala Inicial |
|----|-------|---------|--------------|
| v2_t1a | Hook | 12s | "Mano, eu vou te provar matematicamente..." |
| v2_t1b | Hook | 12s | "Você pega um vídeo do AliExpress..." |
| v2_t1c | Caixa Preta | 12s | "No último vídeo, eu te mostrei..." |
| v2_t1d | Máquina | 12s | "Como a gente substituiu uma agência inteira..." |
| v2_t2a | Elenco | 10s | "Se a Marina faz sucesso vendendo..." |
| v2_t2b | Elenco | 10s | "Você gerencia a loja. Nós gerenciamos o elenco." |
| v2_t3a | Lip Sync | 10s | "Agora, a cereja do bolo..." |
| v2_t3b | Engenharia | 10s | "Engenharia de conversão. É isso que a gente faz." |
| v2_t4a | CTA | 12s | "Você viu a máquina por dentro..." |
| v2_t4b | CTA | 12s | "A boa notícia é que você não precisa..." |
| v2_t4c | CTA | 12s | "No próximo vídeo, eu vou te fazer uma oferta direta..." |

**Total TH: 11 takes × ~11s médio = ~121s de TH puro**

### Screen Recordings (9 SCs)
| ID | Conteúdo | VO Duração |
|----|----------|-----------|
| v2_sc1 | Vídeo genérico TikTok | ~8s |
| v2_sc2 | VS Code repositório | ~10s |
| v2_sc3 | Grid 5 personagens | ~14s |
| v2_sc4 | banco_narrativo.md | ~10s |
| v2_sc5 | Lista 70 dores | ~12s |
| v2_sc6 | Terminal gerando vídeo | ~14s |
| v2_sc7 | Comparação lado a lado | ~16s |
| v2_sc8 | Legendas Safe Zone | ~14s |
| v2_sc9 | Logo final | 5s |

**Total SCs: ~103s de screen recordings**

### Duração Total Estimada
- TH com crossfade: ~121s - (10 × 0.3s) = ~118s
- SCs: ~103s
- Logo intro: 5s
- **Total: ~226s ≈ 3min46s de material gerado**

> Nota: O roteiro original prevê 12-15 min. Para atingir essa duração, cada take TH pode ser estendido para 15-20s e os VOs dos SCs podem ser mais longos. A estrutura acima é a versão enxuta — pode ser expandida na Sessão 11 se necessário.
