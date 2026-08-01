---
name: moviemoney-production
description: "Produção de vídeos institucionais e criativos de alta conversão para a marca Movie Money. Use para: criar vídeos do YouTube com o personagem Beto, aplicar o Modo 50/50, configurar lip sync perfeito, transições crossfade e legendas na Safe Zone de 320px."
---

# Movie Money Video Production

Esta skill automatiza o rigor técnico e o estilo visual dos vídeos da Movie Money, garantindo consistência entre o porta-voz (Beto) e as demonstrações técnicas.

## Fluxo de Trabalho Principal

1. **Plano de Takes:** Dividir o roteiro em blocos de Talking Head (TH) e Screen Recording (SC) na proporção 50/50.
2. **Geração de Assets:**
   - **TH:** Usar `beto_keyframe_16x9.jpg` como referência. Incluir a fala exata no prompt para lip sync.
   - **SC:** Capturar screenshots de alta resolução do repositório, terminal ou dashboards.
   - **VO:** Usar a voz Fenrir (pt-BR) para narrações de suporte.
3. **Processamento:** Aplicar os padrões técnicos definidos em `references/video_standards.md`.
4. **Montagem:** Usar scripts Bash para concatenar com crossfade visual e Ken Burns.

## Regras de Ouro

- **Lip Sync:** A fala no prompt deve ser idêntica ao roteiro.
- **Dinamismo:** Alternar entre Beto e Tela a cada 5-7 segundos.
- **Transições:** Sempre usar crossfade de 0.3s entre takes do Beto para simular um vídeo contínuo.
- **Safe Zone:** Manter legendas e elementos críticos acima de 320px da base.

## Referências Úteis

- Leia `references/video_standards.md` para os comandos exatos de ffmpeg e parâmetros de upscale.
- Consulte o repositório `trentomotta7-hub/Moviemoney` para templates de personagens e vozes.
