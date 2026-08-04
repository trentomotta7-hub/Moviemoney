# Movie Money — Próximas Ações

> Atualizado em: 04/08/2026 — Sessão 15
> **Ao iniciar nova sessão: execute as ações na ordem listada.**

---

## 🔴 URGENTE — Sessão 15 (em andamento)

### 1. Finalizar vídeo do Beto CEO
- Take 1 gerado: `criativos/video_beto_ceo/beto_ceo_take1_hook.mp4`
- Gerar takes 2, 3 e 4 (corpo + CTA)
- Montar vídeo completo com ffmpeg
- Aplicar marca d'água Movie Money
- Rodar `manus-analyze-video` para QA
- Salvar como `video_beto_ceo_v1_FINAL.mp4`

### 2. Corrigir bug mobile da landing page
- No mobile: vídeo hero não aparece, imagens não carregam
- Causa provável: `<video autoplay>` sem `playsinline` no iOS / imagens sem `loading="lazy"` adequado
- Solução: adicionar `playsinline muted` no video tag + fallback de imagem para mobile
- Recriar projeto webdev ou usar ID do projeto existente

### 3. Integrar vídeo do Beto CEO na landing page
- Adicionar seção "Conheça o CEO" ou substituir placeholder de vídeo no hero
- Usar player HTML5 com poster frame (keyframe do Beto)
- Garantir que funcione em mobile (controls, playsinline)

### 4. Commit + push completo
- Incluir `.project-memory/` no commit
- Mensagem: `checkpoint(sessão-15): vídeo CEO + correção mobile landing + sistema de memória`

---

## 🟡 PRÓXIMAS SESSÕES

### Sessão 16
- Produzir vídeo POV Sunscreen Stick SPF (roteiro pronto em `criativos/roteiros/POV_sunscreen_stick_spf_v1.md`)
  - Gerar takes POV com Marina Costa
  - Montar com música + legendas safe zone 320px
  - Publicar no TikTok Shop

### Sessão 17
- Produzir Vídeo 3 "A Oferta" (VSL de vendas)
  - Roteiro a criar
  - Formato: 8-12 minutos, Beto como apresentador
  - CTA direto para landing page

### Sessão 18
- Integrar backend de leads na landing page
  - Migrar para `web-db-user` (com banco de dados)
  - Formulário salva no MySQL
  - Email de confirmação automático

### Sessões futuras
- Adicionar countdown de urgência no CTA da landing
- Criar criativos GC + POV para produto #2 (a definir por mineração)
- Criar criativos GC + POV para produto #3
- Publicar Vídeo 1 e Vídeo 2 no YouTube
- Configurar TikTok Shop Affiliate

---

## Checklist de Início de Sessão (SEMPRE EXECUTAR)

Ao iniciar qualquer nova sessão no projeto Movie Money:

1. Clonar repositório: `gh repo clone trentomotta7-hub/Moviemoney`
2. Ler: `.project-memory/current-context.md`
3. Ler: último arquivo em `.project-memory/checkpoints/`
4. Verificar trends: TikTok Creative Center + Top Ads Dashboard
5. Checar benchmarks atualizados da categoria
6. Continuar pelas ações listadas neste arquivo
