---
name: tiktokshop-creative-audit
description: "Guia de auditoria audiovisual, análise técnica e pipeline de correção para criativos de venda (UGC e POV) focados no TikTok Shop. Use para: diagnosticar problemas de conversão em vídeos curtos, corrigir posicionamento de legendas (Safe Zone), detectar drift de áudio/vídeo, identificar caudas mortas (silêncio) e orientar refações de lip sync."
---

# Auditoria e Correção de Criativos — TikTok Shop

Esta skill fornece o pipeline processual e os critérios técnicos para auditar e corrigir vídeos de conversão (anúncios) para o ecossistema TikTok Shop. O rigor audiovisual define o CPA (Custo por Aquisição); pequenas falhas técnicas destroem a confiança do usuário.

## 1. Pipeline de Auditoria Forense

Sempre que receber um vídeo para análise de conversão, execute este diagnóstico em 4 etapas:

### Passo 1: Análise Visual com Inteligência Artificial
Execute a ferramenta nativa para obter o diagnóstico visual inicial:
```bash
manus-analyze-video /caminho/do/video.mp4 "Você é um especialista em edição para TikTok Shop. Analise com máximo rigor: 1) Hook (0-3s); 2) Lip sync (sincronia labial exata); 3) Legendas (posicionamento e leitura); 4) Qualidade de imagem e iluminação; 5) Ritmo/Pacing; 6) CTA final. Aponte problemas com timestamps exatos."
```

### Passo 2: Extração de Metadados e Drift
Verifique o sincronismo técnico das streams (Drift):
```bash
ffprobe -v quiet -print_format json -show_format -show_streams video.mp4
```
*Sintoma:* Se a stream de áudio e a de vídeo tiverem durações diferentes ou `start_time` diferentes, o vídeo sofrerá de dessincronização progressiva.

### Passo 3: Análise de Cauda Morta (Tail Silence)
O TikTok prioriza vídeos que rodam em loop sem interrupção. Silêncio no final do vídeo mata o loop.
```bash
ffmpeg -i video.mp4 -af silencedetect=noise=-35dB:d=0.1 -f null - 2>&1 | grep silence
```
*Sintoma:* Se houver silêncio maior que 0.3s no final absoluto do vídeo, a "cauda morta" deve ser cortada.

### Passo 4: Auditoria de Safe Zone (Legendas)
O TikTok Shop possui uma interface poluída na parte inferior (Nome, Descrição, Música e o **Carrinho Laranja**).
*Regra de Ouro:* Legendas `.ass` nunca podem ter `MarginV` menor que `300px` em resoluções 1080x1920 ou 720x1280. O padrão ideal é `320px` para fugir da zona morta.

---

## 2. Padrões de Correção e Remontagem

Quando a auditoria revelar falhas, aplique as seguintes correções:

### A. Correção de Legendas (Safe Zone)
Se o vídeo usa legendas ASS (Advanced SubStation Alpha), abra o arquivo `.ass` e modifique a linha de `Style`:
```text
# Antes (escondido pelo carrinho):
Style: Karaoke,Arial,34,&H00FFFFFF,...,20,20,80,1

# Depois (Safe Zone):
Style: Karaoke,Arial,34,&H00FFFFFF,...,30,30,320,1
```

### B. Correção de Cauda Morta (Corte de Silêncio)
Se a fala termina em `27.19s` mas o vídeo vai até `28.06s` em silêncio:
```bash
# Cortar o vídeo exatamente onde a fala termina para forçar loop
ffmpeg -i video_original.mp4 -t 27.19 -c:v libx264 -preset fast -crf 18 -c:a aac video_cortado.mp4
```

### C. Refação de Takes Gerados por IA (Lip Sync)
**Falha comum:** Modelos de geração de vídeo geram diálogos aleatórios e lip sync falho se a fala não for explicitada no prompt.
**Correção:** Ao usar `generate_video` (ex: `gemini-omni-flash-preview`), o prompt **deve conter a fala exata** do roteiro e a instrução explícita de lip sync e áudio nativo.
*Exemplo de Prompt Correto:* `"A young woman looking at the camera. She says out loud in Brazilian Portuguese with precise natural lip sync: 'Tá no link aqui embaixo. Corre que os kits tão acabando.' Natural movement, UGC style."`

### D. Remontagem Limpa (Concatenação)
Nunca aplique legendas sobre um vídeo que já tem legendas queimadas.
1. Extraia os takes brutos (sem legenda).
2. Concatene-os: `ffmpeg -f concat -i lista.txt -c:v libx264 -an video_raw.mp4`
3. Adicione o áudio mestre sincronizado.
4. Aplique o `.ass` corrigido: `ffmpeg -i video_raw.mp4 -vf "ass=legendas.ass" -c:a copy video_final.mp4`

---

## 3. Critérios de Aprovação (Checklist)

Antes de entregar o criativo finalizado, valide:
- [ ] **Lip Sync:** A articulação labial corresponde perfeitamente aos fonemas (se for UGC).
- [ ] **Safe Zone:** As legendas estão no terço médio-inferior (MarginV ~320px).
- [ ] **Loop:** O vídeo corta exatamente após a última sílaba do CTA (zero cauda morta).
- [ ] **Hook:** O produto e o benefício aparecem nos primeiros 3 segundos.
- [ ] **CTA:** A chamada para ação é verbalizada integralmente ("Clica no link abaixo").
