# Relatório de Análise Forense — Movie Money
**Data:** 30 de julho de 2026 | **Versão:** 1.0

---

## Sumário Executivo

O projeto Movie Money está em estado **funcional e bem estruturado** para uma fase inicial de produção. A base de assets (personagens, cenas, vozes, documentação) está sólida. No entanto, a análise identificou **17 achados** distribuídos em 4 categorias de severidade, sendo 3 críticos, 5 de alta prioridade, 6 médios e 3 baixos. Os problemas críticos envolvem precisão das legendas karaokê, inconsistência de nomenclatura e uma cena fora do padrão de resolução.

---

## 1. ANÁLISE TÉCNICA DE VÍDEO

### 1.1 Parâmetros Gerais

| Parâmetro | Valor atual | Padrão TikTok recomendado | Status |
|-----------|------------|--------------------------|--------|
| Resolução | 720×1280 | 1080×1920 (mínimo 720×1280) | ⚠️ Aceitável, mas abaixo do ideal |
| FPS (final) | 24 fps | 24–30 fps | ✅ OK |
| FPS (raw) | 120 fps | — | ⚠️ Arquivo intermediário não limpo |
| Codec de vídeo | H.264 | H.264 ou H.265 | ✅ OK |
| Codec de áudio | AAC | AAC | ✅ OK |
| Sample rate áudio | 48.000 Hz | 44.100 ou 48.000 Hz | ✅ OK |
| Canais de áudio | Estéreo (2ch) | Estéreo | ✅ OK |
| Bitrate total | ~1.699 kbps | 1.500–4.000 kbps | ✅ OK |
| Formato do container | MP4 (moov,mp4) | MP4 | ✅ OK |
| Orientação | Vertical 9:16 | Vertical 9:16 | ✅ OK |

**Achado 1 — CRÍTICO:** A resolução de 720×1280 é o mínimo aceitável do TikTok. O algoritmo do TikTok favorece vídeos em **1080×1920** no rankeamento orgânico. Todos os vídeos futuros devem ser gerados em 1080p. Os takes gerados pela IA já vêm em 720p — isso é uma limitação do modelo de geração atual, mas o pipeline de montagem pode fazer upscale antes de exportar.

**Achado 2 — MÉDIO:** Os arquivos `beto_institucional_raw.mp4` e `beto_v2_raw.mp4` têm FPS de 120 (artefato do modelo de geração). Esses arquivos intermediários estão ocupando 13MB desnecessários na pasta de entregáveis finais.

### 1.2 Estrutura de Takes

| Take | Duração | Função no roteiro |
|------|---------|------------------|
| v2_take1.mp4 | 4s | Hook de abertura |
| v2_take2.mp4 | 10s | Problema + ironia dos gurus |
| v2_take3.mp4 | 8s | Solução Movie Money |
| v2_take4.mp4 | 5s | CTA final |

**Achado 3 — MÉDIO:** O take 2 tem 10 segundos — é o mais longo e o mais arriscado. No TikTok, o drop de retenção é mais agressivo entre 4s e 12s. Idealmente, nenhum take individual deve ultrapassar 8s. Recomenda-se quebrar o take 2 em dois takes de 5s cada em produções futuras.

### 1.3 Legendas Karaokê (ASS)

O arquivo `beto_karaoke.ass` foi inspecionado linha a linha.

**Configuração atual:**
- Fonte: Arial, tamanho 22
- Cor padrão: branco (`&H00FFFFFF`)
- Cor de destaque: amarelo (`&H0000FFFF`)
- Alinhamento: 2 (centralizado inferior)
- Sombra e borda: ativas

**Achado 4 — CRÍTICO:** O sistema de karaokê atual usa **timing por segmento**, não por palavra individual. A transcrição retorna segmentos (ex: "Mano, eu vou ser direto com você.") e o script divide o tempo do segmento igualmente entre as palavras usando `\k` com valor fixo por grupo. Isso significa que o highlight amarelo não segue a fala real palavra a palavra — ele avança em blocos de 5 palavras com timing igual, o que cria uma experiência de karaokê aproximada, não precisa. Para criativos de venda premium, isso é perceptível e reduz a qualidade percebida.

**Solução:** usar a API Whisper com `word_timestamps=True` para obter timestamps reais por palavra, e gerar o ASS com `\k` individual por palavra. Isso requer um passo extra no pipeline mas entrega karaokê de qualidade profissional.

**Achado 5 — MÉDIO:** O arquivo `beto_institucional.srt` (versão SRT estática, gerada na v1) ainda está na pasta de produção. Deve ser removido — a regra da skill proíbe SRT estático.

---

## 2. ANÁLISE DE ASSETS DE IMAGEM

### 2.1 Personagens

| Personagem | Arquivo | Resolução | Ratio | Qualidade visual |
|-----------|---------|-----------|-------|-----------------|
| Beto | `beto.png` | 1792×2400 | 0.75 | ✅ Excelente — retrato profissional, identidade forte |
| Lucas Ferreira | `lucas_ferreira.png` | 1632×2176 | 0.75 | ✅ Boa |
| Marina Costa | `marina_costa.png` | 1632×2176 | 0.75 | ✅ Boa — rosto expressivo, cabelo cacheado marcante |
| Rafael Santos | `rafael_santos.png` | 1632×2176 | 0.75 | ✅ Boa |
| Beatriz Oliveira | `beatriz_oliveira.png` | 1632×2176 | 0.75 | ✅ Boa |
| Diego Almeida | `diego_almeida.png` | 1632×2176 | 0.75 | ✅ Boa |

**Achado 6 — MÉDIO:** O Beto tem resolução diferente dos demais (1792×2400 vs 1632×2176). Não é um problema funcional, mas indica que foi gerado em uma sessão diferente. Para consistência de pipeline, padronizar todos em 1632×2176 ou superior.

**Achado 7 — ALTO:** Os retratos dos personagens estão em **ratio 0.75 (3:4)**, não em 9:16. Isso é correto para retratos de referência, mas significa que ao usar como keyframe em vídeos 9:16, o modelo de IA vai precisar completar as bordas laterais/superior/inferior — o que pode gerar inconsistências visuais. A cena de contexto (9:16) deve sempre ser o keyframe do vídeo, não o retrato do personagem.

### 2.2 Banco de Cenas

| Personagem | Cenas | Resolução dominante | Outlier |
|-----------|-------|---------------------|---------|
| Beto | 5 | 1536×2752 / 1440×2560 | — |
| Beatriz | 4 | 1536×2752 | — |
| Diego | 4 | 1536×2752 | — |
| Lucas | 4 | 1440×2560 | — |
| Marina | 4 | 1440×2560 | **sala_plantas.png: 768×1344** |
| Rafael | 4 | 1536×2752 | — |

**Achado 8 — CRÍTICO:** `marina/sala_plantas.png` está em **768×1344** — exatamente metade da resolução das outras cenas. Se usada como keyframe em um vídeo, o modelo vai receber uma imagem de baixa qualidade e o resultado visual vai ser inferior. Esta cena precisa ser regerada em 1440×2560 ou superior.

**Achado 9 — ALTO:** Há **três resoluções diferentes** no banco de cenas: 1536×2752, 1440×2560 e 768×1344. Isso indica que as cenas foram geradas em sessões diferentes com parâmetros diferentes. Para consistência de pipeline, padronizar todas em **1440×2560** (9:16 em alta resolução).

**Achado 10 — ALTO:** O Beto tem **5 cenas** enquanto todos os outros personagens têm **4 cenas**. Isso é esperado (Beto é o rosto da marca), mas o banco de cenas do Beto ainda inclui `estudio_oficial.png` como cenário padrão, enquanto a regra da skill já foi atualizada para `escritorio_moderno.png`. A documentação do `elenco.md` ainda menciona o estúdio como "cenário padrão" do Beto — há uma inconsistência entre a regra nova (SKILL.md) e o documento de referência (elenco.md).

### 2.3 Identidade Visual

| Asset | Resolução | Uso | Status |
|-------|-----------|-----|--------|
| `logo_final.png` | 2048×2048 | Logo principal | ✅ Excelente — forte, legível, identidade clara |
| `perfil_icone.png` | 2048×2048 | Avatar de perfil | ✅ OK |
| `capa_banner.png` | 2752×1536 | Banner/capa 16:9 | ✅ OK |

**Achado 11 — BAIXO:** O logo não tem versão com fundo transparente (PNG com alpha). Para uso em sobreposição de vídeo, watermark ou composição, será necessário uma versão transparente. Recomenda-se gerar uma versão com fundo removido.

---

## 3. ANÁLISE DE VOZES TTS

### 3.1 Parâmetros Técnicos

Todas as vozes estão em **PCM s16le, 24kHz, mono, 384 kbps** — formato consistente e adequado para produção.

| Personagem | Arquivo | Duração | Observação |
|-----------|---------|---------|-----------|
| Beto (v1) | `beto.wav` | 19.8s | Versão original — estilo genérico |
| Beto (v2) | `beto_v2.wav` | 38.0s | **Versão oficial** — estilo baseado na voz do criador |
| Beto (v3) | `beto_v3.wav` | 33.4s | Variação alternativa |
| Lucas | `lucas_ferreira.wav` | 13.6s | Amostra curta |
| Marina | `marina_costa.wav` | 23.8s | OK |
| Rafael | `rafael_santos.wav` | 25.6s | OK |
| Beatriz | `beatriz_oliveira.wav` | 16.9s | Amostra curta |
| Diego | `diego_almeida.wav` | 16.3s | Amostra curta |

**Achado 12 — ALTO:** `beto.wav` (versão original) ainda existe na pasta junto com `beto_v2.wav` e `beto_v3.wav`. Isso cria ambiguidade: qual é a voz oficial? O mapa de vozes aponta para Fenrir com o novo prompt, mas não especifica qual arquivo `.wav` é a referência atual. Recomenda-se: (1) renomear `beto_v2.wav` para `beto_oficial.wav`, (2) mover `beto.wav` e `beto_v3.wav` para uma pasta `vozes/arquivo/` ou deletar.

**Achado 13 — MÉDIO:** Lucas (13.6s), Beatriz (16.9s) e Diego (16.3s) têm amostras de voz mais curtas que Marina (23.8s) e Rafael (25.6s). Amostras curtas são menos representativas do estilo do personagem. Recomenda-se gerar amostras mais longas (30–40s) para esses três personagens.

**Achado 14 — BAIXO:** As amostras de voz existentes são apenas hooks e frases de apresentação. Não há amostras de voz em modo "meio de roteiro" (construção de problema) ou "CTA" para cada personagem. Isso dificulta avaliar se o estilo se mantém consistente em diferentes partes do roteiro.

---

## 4. ANÁLISE DOCUMENTAL

### 4.1 Consistência entre Documentos

**Achado 15 — ALTO:** Inconsistência de nomenclatura entre os três sistemas de referência:

| Sistema | Padrão usado | Exemplo |
|---------|-------------|---------|
| `templates/personagens/` | Nome completo com underscore | `marina_costa.png` |
| `templates/cenas/` | Primeiro nome apenas | `marina/` |
| `templates/vozes/` | Nome completo com underscore | `marina_costa.wav` |
| `references/elenco.md` | Nome completo | Marina Costa |

Isso cria risco em automações futuras: um script que tenta acessar `templates/cenas/marina_costa/` vai falhar porque a pasta se chama `marina/`. **Solução:** padronizar tudo com primeiro nome (`marina/`, `marina.png`, `marina.wav`) ou tudo com nome completo.

**Achado 16 — MÉDIO:** O `elenco.md` ainda descreve o cenário padrão do Beto como "Estúdio com fundo escuro texturizado" — mas a regra 9 da SKILL.md já define `escritorio_moderno.png` como padrão. Há contradição entre os dois documentos.

**Achado 17 — MÉDIO:** O banco narrativo (`banco_narrativo.md`) menciona 4 nichos no cabeçalho "Como Usar Este Banco" (linha 10), mas o documento agora cobre 9 nichos. A linha foi atualizada, mas a tabela "Tabela Mestre de Nichos" ao final do documento lista os 9 nichos corretamente. Verificar se há outras referências desatualizadas no documento.

### 4.2 Higiene da Pasta de Produção

**Arquivos temporários/intermediários em `templates/videos/`:**

| Arquivo | Tipo | Ação recomendada |
|---------|------|-----------------|
| `beto_institucional_raw.mp4` | Intermediário (120fps) | Deletar |
| `beto_v2_raw.mp4` | Intermediário (120fps) | Deletar |
| `beto_v2_raw_converted_*.mp3` | Intermediário de transcrição | Deletar |
| `beto_v2_raw_converted_*_transcription_*.json` | Intermediário de transcrição | Mover para `references/` ou deletar |
| `beto_v2_raw_converted_*_transcription_*.txt` | Intermediário de transcrição | Mover para `references/` ou deletar |
| `concat_list.txt` | Script de montagem v1 | Deletar |
| `concat_v2.txt` | Script de montagem v2 | Deletar |
| `gerar_karaoke.py` | Script de produção | Mover para `scripts/` |
| `beto_institucional.srt` | Legenda SRT proibida pela skill | Deletar |
| `beto_institucional_take1-4.mp4` | Takes da v1 (obsoletos) | Deletar ou mover para `arquivo/` |

**Impacto:** 13 arquivos desnecessários ocupando ~25MB na pasta de entregáveis.

---

## 5. PLANO DE CORREÇÕES PRIORIZADAS

### Prioridade CRÍTICA (fazer primeiro)

| # | Problema | Ação | Esforço |
|---|---------|------|---------|
| C1 | Resolução 720p nos vídeos finais | Adicionar passo de upscale 720→1080p no pipeline de montagem ffmpeg | Baixo |
| C2 | Karaokê com timing aproximado (por segmento) | Implementar transcrição com `word_timestamps=True` e gerar ASS com `\k` por palavra | Médio |
| C3 | `marina/sala_plantas.png` em 768×1344 (metade da resolução) | Regerar a cena em 1440×2560 com o mesmo prompt + referência da Marina | Baixo |

### Prioridade ALTA

| # | Problema | Ação | Esforço |
|---|---------|------|---------|
| A1 | Ambiguidade de voz oficial do Beto (3 arquivos) | Renomear `beto_v2.wav` → `beto_oficial.wav`; arquivar os outros | Baixo |
| A2 | Inconsistência de nomenclatura (nome completo vs primeiro nome) | Padronizar pastas de cenas para nome completo: `marina_costa/`, `lucas_ferreira/` etc. | Baixo |
| A3 | Retratos em 3:4 usados como keyframe em vídeos 9:16 | Documentar explicitamente na SKILL.md: keyframe = cena (9:16), não retrato (3:4) | Baixo |
| A4 | Inconsistência entre SKILL.md (escritório) e elenco.md (estúdio) | Atualizar `elenco.md` para refletir escritório moderno como cenário padrão do Beto | Baixo |
| A5 | Amostras de voz curtas para Lucas, Beatriz e Diego | Regerar amostras com 30–40s de roteiro completo | Médio |

### Prioridade MÉDIA

| # | Problema | Ação | Esforço |
|---|---------|------|---------|
| M1 | Take 2 com 10s (risco de drop de retenção) | Documentar limite de 8s por take no pipeline | Baixo |
| M2 | Três resoluções diferentes no banco de cenas | Padronizar todas as novas cenas em 1440×2560 | Baixo (para novas) |
| M3 | Arquivos temporários na pasta de entregáveis | Limpeza completa: deletar 13 arquivos, criar pasta `scripts/` | Baixo |
| M4 | SRT estático (`beto_institucional.srt`) na pasta | Deletar | Mínimo |
| M5 | Beto tem 5 cenas, outros têm 4 | Não é problema — é intencional. Documentar como padrão | Mínimo |
| M6 | Banco narrativo com referência a 4 nichos no cabeçalho | Verificar e corrigir todas as referências desatualizadas | Baixo |

### Prioridade BAIXA

| # | Problema | Ação |
|---|---------|------|
| B1 | Logo sem versão transparente | Gerar `logo_transparente.png` com fundo removido |
| B2 | Amostras de voz sem cobertura de "meio de roteiro" e "CTA" | Gerar amostras adicionais por personagem |
| B3 | Beto em resolução diferente dos outros personagens (1792×2400 vs 1632×2176) | Não é urgente — manter como está |

---

## 6. DIAGNÓSTICO FINAL

### Pontos Fortes do Projeto

A estrutura documental é **excepcionalmente bem organizada** para um projeto de IA criativa. O elenco tem personalidades distintas e bem definidas, o banco narrativo é robusto e estratégico, e a SKILL.md funciona como um manual operacional completo. O logo e a identidade visual têm força e coerência. A voz do Beto com estilo baseado na voz real do criador é um diferencial genuíno.

### Pontos de Atenção

O maior risco técnico atual é a **qualidade do karaokê** — que é um elemento de diferenciação visual nos criativos. O segundo risco é a **resolução 720p** nos vídeos finais, que está no limite do aceitável para o algoritmo do TikTok. O terceiro é a **inconsistência de nomenclatura**, que vai causar erros em automações futuras se não for corrigida agora.

### Prontidão para Produção

O projeto está **pronto para o primeiro criativo de teste ponta a ponta** com as ressalvas acima documentadas. As correções críticas (C1, C2, C3) podem ser feitas em paralelo com a produção do primeiro criativo real, sem bloquear o avanço.

---

*Relatório gerado por análise técnica automatizada + inspeção visual multimodal. Todos os dados são baseados nos assets reais do projeto em `/home/ubuntu/skills/movie-money/`.*
