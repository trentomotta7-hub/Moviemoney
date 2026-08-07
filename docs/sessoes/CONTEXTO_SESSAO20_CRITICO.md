# Contexto crítico — Sessão 20 (salvo antes de compactação)

## Estado do projeto
- Repositório: trentomotta7-hub/Moviemoney (clonado em /home/ubuntu/Moviemoney)
- Skill continuity-sync instalada em /home/ubuntu/skills/continuity-sync/
- Todos os masters auditados e REJECTED (sessão 20)
- Usuário quer tudo APPROVED usando APENAS ferramentas nativas da Manus (sem conectores externos)

## Ferramentas nativas disponíveis
- `generate` (modo geração nativa Manus) — imagens, vídeo, áudio, TTS, música
- `manus-speech-to-text` — transcrição
- `manus-analyze-video` — análise multimodal
- `ffmpeg` — montagem, normalização, correção técnica
- `qa_gate.py` — gate técnico automatizado
- LLMs via OPENAI_API_KEY (gpt-5, claude-sonnet-4-6, gemini-3.1-pro-preview)

## Decisão de arquitetura para cada master

### Vídeos que precisam de RECONSTRUÇÃO (novos takes):
1. **GC Sunscreen Stick** — talking head, lip sync ruim. Gerar com `generate` (vídeo nativo com áudio)
2. **POV Sunscreen Stick** — produto inconsistente, texto em inglês. Gerar imagens/vídeo + TTS nativo
3. **Criativo 01 Bodysplash** — produto sem rótulo, lip sync ruim. Gerar com `generate`
4. **Beto institucional** — aspect ratio errado, lip sync 2/10. Gerar com `generate` em 16:9

### Vídeos que precisam de CORREÇÃO TÉCNICA (ffmpeg):
5. **Vídeo 2 institucional** — repetição 0:07, glitch 1:30, freeze, loudness. Cortar e normalizar
6. **Vídeo 1 institucional** — cauda 7,45s, freeze 12,5s, loudness -19 LUFS. Cortar e normalizar

## Falhas técnicas a corrigir (ffmpeg)
- Sample rate 96 kHz → 48 kHz: `-ar 48000`
- Loudness -19/-20 LUFS → -16 LUFS: `loudnorm=I=-16:TP=-1.5:LRA=11`
- Cauda silenciosa: cortar com `-t duration`
- Freeze: identificar timestamp e cortar segmento
- Aspect ratio Beto (9:16 → 16:9): regerar

## Roteiro GC Sunscreen (transcrição v6 validada)
Take 1 (hook): "Gente, eu precisava te mostrar esse protetor que mudou minha rotina de skincare."
Take 2 (problema): "Antes eu usava protetor líquido e simplesmente não reaplicava, porque suja a mão, estraga a maquiagem, é uma bagunça. E aí minha pele começou a manchar."
Take 3a (solução/demo): "Aí eu descobri esse bastão SPF cinquenta. Olha como é fácil. Abre aqui, passa direto no rosto e fecha. Mão completamente limpa."
Take 3b1 (make): "Não estraga maquiagem nenhuma."
Take 3b2 (portabilidade): "Eu reaplico no carro, no trabalho, em qualquer lugar. Quinze segundos e tô protegida de verdade."
Take 4a (oferta): "Tá menos de R$35 e dura uns dois meses. Eu recomendo de verdade pra quem usa maquiagem e não consegue reaplicar protetor."
Take 4b (CTA): "Toca no carrinho laranja ali embaixo."

## Roteiro Beto institucional v4 (transcrição validada)
"Mano, eu vou ser direto com você. A maioria das pessoas que tenta vender no TikTok Shop erra no mesmo lugar: o criativo. Não é o produto, não é o preço, é o vídeo. E os gurus da internet não vão te contar isso porque eles ganham dinheiro vendendo curso de como ganhar dinheiro. É exatamente isso que a Movie Money resolve. A gente pega o seu produto e transforma em criativo que para a rolagem nos quatro primeiros segundos. Sem você aparecer, sem filmar nada, sem contratar ninguém. Vem pra Movie Money, dê brilho no seu caminho. Bora vender?"

## Roteiro Bodysplash (transcrição v8c validada)
"Passei esse body splash de manhã e minha amiga perguntou o que eu tava usando às dez da noite. Eu já testei tanta marca. Passa de manhã chega meio-dia e sumiu. Fico o dia todo sem cheiro. Aí uma amiga me mandou esse. Fui sem fé mas gente, o cheiro fixa de verdade. Já tô no terceiro frasco. Tá no link aqui embaixo. Se você quer ser lembrada pelo seu cheiro esse é o caminho. Corre que os kits tão acabando."

## Caminhos dos masters atuais
- GC v5: skill-movie-money/criativos/sunscreen_stick_spf/GC/montagem/sunscreen_stick_marina_GC_v5_FINAL.mp4
- POV v1: skill-movie-money/criativos/sunscreen_stick_spf/POV/montagem/video_normalizado.mp4
- Video1: skill-movie-money/criativos/video_institucional_youtube/video1_quebra_mitos_FINAL.mp4
- Video2: skill-movie-money/criativos/video_institucional_youtube/temp_v2_montagem/video2_sem_marca.mp4
- Bodysplash v8c: skill-movie-money/criativos/criativo_01_bodysplash/criativo01_v8c_FINAL.mp4
- Beto v4: skill-movie-money/templates/videos/beto_institucional_v4.mp4

## Gate técnico
Script: skill-movie-money/skills/moviemoney-production/scripts/qa_gate.py
Uso: python3 qa_gate.py VIDEO --format short|youtube --report out.md --json-report out.json
Saída 0 = TECHNICALLY_APPROVED, saída 1 = TECHNICALLY_REJECTED

## Próxima ação
Começar pela CORREÇÃO TÉCNICA do Vídeo 2 e Vídeo 1 (mais simples, só ffmpeg).
Depois gerar os novos takes para GC, POV, Bodysplash e Beto com ferramentas nativas.
