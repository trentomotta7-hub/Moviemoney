# Diagnóstico Forense — Vídeo 1 v4c "Quebrando Mitos"
**Sessão 7 — 01/08/2026**

---

## Resumo Executivo

O vídeo `video1_quebra_mitos_v4c_FINAL.mp4` (3min57s, 2560×1440, 163MB) foi montado com sucesso técnico (sem silêncio espúrio, áudio normalizado, Ken Burns nos SCs), mas apresenta **5 falhas críticas de conteúdo** que impedem a publicação no YouTube sem correção.

---

## Problemas Identificados

### CRÍTICO — Áudio em Inglês (5 takes contaminados)

Os 5 takes de "gesto/reação" (takes do tipo `t_s*`) foram gerados pelo modelo de IA com **áudio em inglês embutido**. O modelo usou frases motivacionais genéricas em inglês como placeholder de lip sync. O Beto aparece visualmente falando, mas o áudio é completamente em inglês e sem relação com o roteiro.

| Take | Timestamp no Vídeo | Áudio em Inglês (transcrição exata) |
|------|--------------------|--------------------------------------|
| `t_s1d_retencao.mp4` | 00:28 → 00:37 | *"If you want to grow, you need to understand this basic concept: consistency is the key to success."* |
| `t_s3c_aponta_tela.mp4` | 01:52 → 02:02 | *"Look, this is my secret weapon. First, you automate all of your daily outreach. Just take a look right here. Second, you filter all the hot leads, and third, you close them. It is really that simple."* |
| `t_s2c_bracos_cruzados.mp4` | 02:02 → 02:12 | *"I see so many people making this exact same mistake. You need to focus on quality first."* |
| `t_s4b_sorriso_canto.mp4` | 03:01 → 03:11 | *"You see, managing your projects doesn't have to be complicated. With the right method, it's that simple. So let's start applying this to your routine today."* |
| `t_s5b_aponta_camera.mp4` | 03:34 → 03:44 | *"Listen to me. Don't ever let anyone tell you that you can't do it. You have the power to change your life. Believe in yourself. You've got this."* |

**Causa raiz:** O modelo de geração de vídeo (Veo/Gemini) usa frases em inglês como "filler" de lip sync quando o prompt não especifica a fala exata em português. Os takes de gesto (`t_s*`) foram gerados sem fala específica no prompt, deixando o modelo livre para inventar o áudio.

**Solução:** Substituir o áudio desses 5 takes pelo áudio v2 do Fenrir correspondente (já gerado e disponível em `takes/audio_s*_v2.wav`), usando ffmpeg para trocar apenas o stream de áudio mantendo o vídeo original.

---

### GRAVE — Cortes Abruptos (jump cuts visíveis)

O Beto muda de posição instantaneamente a cada 8-10s porque cada take foi gerado separadamente. Os cortes mais visíveis:

| Timestamp | Descrição |
|-----------|-----------|
| 00:27 → 00:28 | Mãos na mesa → gesticulando (corte seco) |
| 01:00 → 01:00 | Gesticulando → braços cruzados |
| 01:10 → 01:10 | Gesticulando → braços cruzados |
| 02:02 → 02:02 | Gesticulando → braços cruzados |
| 02:55 → 02:56 | Apontando câmera → mãos na mesa |

**Solução:** Aplicar crossfade de vídeo de 4 frames (0.16s) entre todos os takes de TH usando o filtro `xfade` do ffmpeg. Praticamente invisível mas elimina o corte seco.

---

### MODERADO — Repetição de Conteúdo

Algumas frases aparecem **duas vezes** no vídeo — uma vez nos takes de TH e novamente nos VOs dos SCs:

| Frase | 1ª ocorrência | 2ª ocorrência |
|-------|---------------|---------------|
| "Venda na internet é uma questão de ótica" | 01:32 (TH) | 02:17 (VO SC) |
| "Minerar o produto é só 10% do trabalho" | 01:42 (TH) | 02:26 (VO SC) |
| "A gente entrega a munição, você aperta o gatilho" | 02:55 (TH) | 03:13 (VO SC) |

**Solução:** Reorganizar a ordem dos segmentos ou substituir os VOs dos SCs por narração complementar (não repetida).

---

### LEVE — Alucinações Visuais nas Mãos

As mãos do Beto têm aspecto artificial em alguns momentos (dedos fundidos, articulações rígidas), mais visível entre **00:18-00:22**. O rosto, cenário, caneca e logo permanecem consistentes e sem distorções ao longo de todo o vídeo.

**Solução:** Cobrir esses momentos com B-roll (screenshots/screencasts) quando possível, ou aceitar como limitação do modelo atual.

---

## Plano de Refatoração — Sessão 8

### Prioridade 1 — Corrigir os 5 takes com inglês

**Abordagem:** Substituir apenas o stream de áudio dos 5 takes problemáticos usando ffmpeg:

```bash
# Exemplo: substituir áudio do t_s1d_retencao pelo segmento correto do audio_s1_hook_v2.wav
ffmpeg -y \
  -i t_s1d_retencao.mp4 \          # vídeo original (lip sync visual)
  -i audio_s1_hook_v2.wav \         # áudio em português
  -ss [offset] -t 10 \              # recortar o trecho correto do áudio
  -map 0:v -map 1:a \               # vídeo do take + áudio do Fenrir
  -c:v copy -c:a aac -ar 48000 \
  t_s1d_retencao_v2.mp4
```

**Mapeamento de áudio para cada take:**

| Take com Inglês | Áudio Correto | Trecho do Áudio | Fala Esperada |
|-----------------|---------------|-----------------|---------------|
| `t_s1d_retencao.mp4` | `audio_s1_hook_v2.wav` | 26s-36s | "O algoritmo do TikTok liga pra uma única coisa: retenção visual" |
| `t_s3c_aponta_tela.mp4` | `audio_s3_maquina_v2.wav` | 20s-30s | "A gente não inventa roteiro da nossa cabeça, a gente puxa da nossa base validada" |
| `t_s2c_bracos_cruzados.mp4` | `audio_s3_maquina_v2.wav` | 30s-40s | "E aí a mágica acontece" |
| `t_s4b_sorriso_canto.mp4` | `audio_s4_resultado_v2.wav` | 20s-30s | "A gente entrega a munição. Você só aperta o gatilho." |
| `t_s5b_aponta_camera.mp4` | `audio_s5_cta_v2.wav` | 20s-30s | "Bora vender?" |

### Prioridade 2 — Logo animada no início

Criar uma sequência de abertura de 4s com a logo Movie Money:
- Frames 0-2s: Logo centralizada, grande, zoom out suave (scale 1.5→1.0)
- Frames 2-4s: Logo continua se afastando (scale 1.0→0.3) + fade out para preto
- Transição para o primeiro take do Beto com fade in

**Assets necessários:**
- `templates/identidade_visual/logo_transparente.png` ✅ (já existe)
- Gerar sequência com ffmpeg usando `zoompan` + `fade`

### Prioridade 3 — Crossfade entre takes de TH

Aplicar `xfade=fade:duration=0.16` entre todos os takes de TH consecutivos usando ffmpeg filter_complex.

### Prioridade 4 — Estrutura dinâmica com narração contínua

Nova arquitetura de montagem:
- Narração em português corre **continuamente** sem interrupção
- Takes de TH aparecem como "talking head" enquanto a narração flui
- Screenshots/B-roll entram como **insert cuts** por cima da narração (sem cortar o áudio)
- Resultado: parece um vídeo de criador real, não um slideshow de takes

---

## Assets Disponíveis para Sessão 8

| Asset | Localização | Status |
|-------|-------------|--------|
| Keyframe Beto 16x9 | `criativos/video_institucional_youtube/beto_keyframe_16x9.jpg` | ✅ |
| 17 takes de TH | `criativos/video_institucional_youtube/takes/t*.mp4` | ✅ (5 com inglês) |
| Áudios Fenrir v2 | `criativos/video_institucional_youtube/takes/audio_s*_v2.wav` | ✅ |
| VOs SC v2 | `criativos/video_institucional_youtube/takes/vo_sc*_v2.wav` | ✅ |
| Screenshots SC | `criativos/video_institucional_youtube/takes/sc*.png` | ✅ |
| Logo transparente | `templates/identidade_visual/logo_transparente.png` | ✅ |
| Script v4c | `scripts/montar_video1_v4c.sh` | ✅ |

---

## Transcrição Completa do Vídeo v4c (para referência)

```
[00:00.1 - 00:09.4] Mano, sério, quantas vezes você já viu um anúncio no YouTube de um moleque dentro dum Porsche alugado dizendo que faturou cem mil reais no TikTok Shop em uma semana?
[00:09.4 - 00:11.8] Eles te vendem o sonho perfeito.
[00:11.8 - 00:18.0] Falam que é só pegar um vídeo chinês, jogar no CapCut, botar uma voz de robô e pronto, cê tá rico.
[00:18.0 - 00:22.4] Mentira, se fosse só isso, por que 90% das lojas de dropshipping quebram no primeiro mês?
[00:22.4 - 00:23.6] Você não faz uma venda.
[00:23.6 - 00:26.2] O algoritmo do TikTok não tá nem aí pros seus seguidores.
[00:26.2 - 00:28.7] Ele liga pra uma única coisa: tem visual.
[00:28.7 - 00:37.0] ⚠️ INGLÊS: "If you want to grow, you need to understand this basic concept: consistency is the key to success."
[00:37.0 - 00:41.4] Eles te vendem o sonho perfeito.
[00:41.4 - 00:49.4] Falam que é só pegar um vídeo chinês, jogar no CapCut, botar uma voz de robô e pronto, cê tá rico.
[00:49.4 - 00:51.5] Eles te vendem o sonho perfeito.
[00:51.5 - 00:54.9] Falam que é só pegar um vídeo chinês, jogar no CapCut, botar uma voz de robô...
[00:54.9 - 00:55.6] Mentira.
[00:55.6 - 00:57.2] Se fosse só isso, por que primeiro mês?
[00:57.2 - 01:00.0] O algoritmo do TikTok liga pruma única coisa: retenção visual.
[01:00.0 - 01:01.4] Eu sei o que você tá passando.
[01:01.4 - 01:04.6] Minera um produto e sobe campanha com vídeo pixelado.
[01:04.6 - 01:07.2] Aí contrata um criador UGC e o roteiro vem fraco.
[01:07.2 - 01:10.0] Mano, cê é dono de negócio, seu trabalho não é virar um TikToker.
[01:10.0 - 01:14.4] Mano, cê é dono de negócio, o seu trabalho é gerenciar a sua loja.
[01:14.4 - 01:21.5] O seu trabalho não é virar um TikToker ou ficar doze horas no Premi- Eu sei exatamente o que você tá passando.
[01:21.5 - 01:26.3] Você minera um produto vencedor, aí você sobe a campanha com isso aqui.
[01:26.3 - 01:32.2] Você acha mesmo que alguém vai parar de rolar o feed pra comprar de um vídeo que grita: "Eu sou um anúncio barato"?
[01:32.2 - 01:34.7] Venda na internet é uma questão de ótica.
[01:34.7 - 01:37.9] Se o seu vídeo parece amador, o seu produto parece barato.
[01:37.9 - 01:40.0] Noventa por cento é o criativo.
[01:40.0 - 01:42.6] Se não tem vídeo que converte, não tem negócio.
[01:42.6 - 01:47.0] Minerar o produto é só dez por cento do trabalho, noventa por cento é o criativo.
[01:47.0 - 01:52.5] A gente não inventa roteiro da nossa cabeça, a gente puxa da nossa base validada, e aí a mágica acontece.
[01:52.5 - 02:02.4] ⚠️ INGLÊS: "Look, this is my secret weapon. First, you automate all of your daily outreach..."
[02:02.4 - 02:10.9] ⚠️ INGLÊS: "I see so many people making this exact same mistake. You need to focus on quality first."
[02:10.9 - 02:17.2] Venda na internet é uma questão de ótica, é percepção.
[02:17.2 - 02:21.2] Se o seu vídeo parece amador, o seu produto parece barato.
[02:21.2 - 02:24.6] E é por isso que a gente parou de editar vídeo na mão.
[02:24.6 - 02:26.5] A gente construiu uma máquina.
[02:26.5 - 02:33.6] Minerar o produto é só dez por cento do trabalho, noventa por cento é o criativo.
[02:33.6 - 02:40.4] A gente não inventa roteiro da nossa cabeça, a gente puxa da nossa base validada, e aí a mágica acontece.
[02:40.4 - 02:47.5] Isso não é promessa pro futuro.
[02:47.5 - 02:49.0] A gente construiu essa máquina.
[02:49.0 - 02:50.6] Nós somos a Movman.
[02:50.6 - 02:54.2] E eu vou te mostrar exatamente como essa máquina funciona.
[02:54.2 - 02:55.8] Clica no vídeo e bora vender.
[02:55.8 - 02:58.5] A gente entrega a munição.
[02:58.5 - 03:01.2] Você só aperta o gatilho.
[03:01.2 - 03:10.3] ⚠️ INGLÊS: "You see, managing your projects doesn't have to be complicated. With the right method, it's that simple."
[03:10.3 - 03:13.7] A gente entrega a munição.
[03:13.7 - 03:15.7] Você só aperta o gatilho.
[03:15.7 - 03:18.7] Isso não é promessa pro futuro, isso tá acontecendo agora.
[03:18.7 - 03:19.8] Nós somos a Movman.
[03:19.8 - 03:25.9] E no próximo vídeo dessa série, como a gente minera esses produtos antes deles estourarem e como a gente sem gastar um centavo com criador UGC.
[03:25.9 - 03:31.6] Se você tá cansado de perder dinheiro com vídeo ruim, clica no vídeo que tá aparecendo aqui na tela agora.
[03:31.6 - 03:33.3] Vem ver como os profissionais jogam.
[03:33.3 - 03:34.7] Bora vender?
[03:34.7 - 03:43.5] ⚠️ INGLÊS: "Listen to me. Don't ever let anyone tell you that you can't do it. You have the power to change your life. Believe in yourself. You've got this."
```

---

## Decisão de Arquitetura para Sessão 8

O usuário aprovou o plano de refatoração. A Sessão 8 deve executar:

1. **Substituir áudio dos 5 takes com inglês** → usar Fenrir v2 com trecho correto do roteiro
2. **Logo animada no início** → zoom out + fade, 4s, antes do Hook
3. **Crossfade 0.16s** entre todos os takes de TH consecutivos
4. **Estrutura dinâmica** → narração contínua com B-roll como insert cuts
5. **Eliminar repetições** → reorganizar ordem dos segmentos

**Arquivo de saída alvo:** `video1_quebra_mitos_v5_FINAL.mp4`
