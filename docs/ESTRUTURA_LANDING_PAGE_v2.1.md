# Movie Money — Estrutura do Projeto v2.1

**Data:** 04/08/2026  
**Status:** Publicado em [moviemoney-dwepojx6.manus.space](https://moviemoney-dwepojx6.manus.space)  
**Checkpoint:** 6e995833

---

## 1. Visão Geral

A Movie Money é uma produtora de criativos de alta conversão para lojistas do TikTok Shop Brasil. A landing page funciona como o principal funil de captação de leads — lojistas que querem criativos profissionais sem montar equipe interna.

**Proposta de valor:** Criativos com lip sync real, 6 formatos validados, CPA até 50% menor, entregues em 48-72h.

---

## 2. Estrutura Atual da Landing Page (v2.1)

| # | Seção | Objetivo | Status |
|---|-------|----------|--------|
| 1 | **Ticker de Urgência** | Criar FOMO com countdown e oferta de 1 criativo grátis | ✅ Implementado |
| 2 | **Header Fixo** | Navegação + CTA "Quero meu criativo grátis" com scroll-aware bg | ✅ Implementado |
| 3 | **Hero** | Hook psicológico forte + vídeo background + Beto com parallax | ✅ Implementado |
| 4 | **Métricas de Mercado** | Dados impactantes (250M GMV, 67% compraram, 2.8x CTR, 1.5s) | ✅ Implementado |
| 5 | **Problema/Dores** | Diagnóstico das dores do lojista + Antes vs Depois | ✅ Implementado |
| 6 | **6 Formatos** | Apresentação dos formatos com CPA benchmark | ✅ Implementado |
| 7 | **Cases Reais** | Prova social com resultados anonimizados de clientes | ✅ Implementado |
| 8 | **Investimento** | Comparativo de preço (equipe interna vs freelancer vs Movie Money) | ✅ Implementado |
| 9 | **Pipeline (4 Passos)** | Como funciona o processo de produção | ✅ Implementado |
| 10 | **Elenco** | 6 personagens reais com seus formatos | ✅ Implementado |
| 11 | **FAQ** | 5 perguntas frequentes com accordion | ✅ Implementado |
| 12 | **CTA Final** | Formulário de captura + countdown + CTA secundário WhatsApp | ✅ Implementado |
| 13 | **Footer** | Links de navegação + branding | ✅ Implementado |

---

## 3. Efeitos e Tecnologias Implementados

| Efeito | Descrição |
|--------|-----------|
| **Parallax Multi-Layer** | Background, glitch texture e partículas se movem em velocidades diferentes no scroll |
| **Mouse Parallax** | Beto e partículas flutuantes reagem ao movimento do mouse |
| **Vídeo Background** | Loop infinito de vídeo dark/digital no hero (autoplay, muted) |
| **Scroll Reveal** | Seções aparecem com fade-in-up conforme o usuário desce |
| **Scroll Transform** | Seções de formatos e pipeline escalam e mudam opacidade com scroll |
| **Contadores Animados** | Métricas contam de 0 até o valor final quando entram na viewport |
| **Countdown Timer** | Timer regressivo de 7 dias (urgência rolling) |
| **Scan Lines** | Efeito sutil de linhas de varredura sobre toda a página |
| **Scanline Dividers** | Separadores animados entre seções |
| **Neon Glow** | CTAs com brilho cyan pulsante |
| **Machine Frame** | Bordas com corner marks estilo painel de controle |
| **Grid Background** | Malha sutil de fundo para profundidade |
| **Floating Particles** | Pontos de luz que flutuam com parallax |
| **Hover Animations** | Cards com translate-y, scale e border-color transitions |
| **Stagger Animations** | Elementos entram com delay progressivo (30-150ms) |

---

## 4. Melhorias Implementadas nesta Sessão

### 4.1 Correção de Sobreposição (Prioridade 1)
- Padding do hero ajustado (120px com ticker, 80px sem)
- Z-index hierárquico corrigido (ticker z-60, header z-50, conteúdo z-10)
- Seções com padding responsivo (py-24 mobile, py-28 desktop)

### 4.2 Cases Reais — Prova Social (Prioridade 2 e 3)
- 3 cases anonimizados com métricas reais:
  - Beleza & Skincare: CTR +675% (0.4% → 3.1%)
  - Eletrônicos: ROAS 4x (1.2 → 4.8)
  - Fitness: 42 vendas no primeiro vídeo
- Badges de verificação ("Resultado verificado • Cliente ativo")
- Disclaimer legal de confidencialidade

### 4.3 Pista de Investimento (Prioridade 4)
- Comparativo visual em 3 colunas:
  - Equipe interna: R$15k+/mês (riscado)
  - Freelancer: R$3-5k por vídeo (riscado)
  - Movie Money: A partir de R$497 por produto (destaque)
- Qualifica leads antes de chegarem ao formulário

### 4.4 CTA Secundário (Prioridade 5)
- Link "Prefere só tirar uma dúvida? Fale direto no WhatsApp"
- Abaixo do botão principal do formulário
- Menor compromisso para leads indecisos

---

## 5. Melhorias Sugeridas — Próximos Passos

### Curto Prazo (próxima sessão)

| # | Melhoria | Impacto | Esforço |
|---|----------|---------|---------|
| 1 | **Backend para captura de leads** — Adicionar `web-db-user` para salvar formulários no banco + notificação WhatsApp automática | Alto | Médio |
| 2 | **Embed do Vídeo 2** — Quando "A Máquina por Dentro" for publicado no YouTube, inserir embed na página | Alto | Baixo |
| 3 | **Pixel do TikTok + Meta** — Instalar pixels de rastreamento para remarketing e otimização de campanhas | Alto | Baixo |
| 4 | **A/B test de headlines** — Criar variação do hook para testar qual converte mais | Médio | Baixo |
| 5 | **Animação de entrada do hero** — Texto digitando letra por letra (typewriter) no primeiro load | Médio | Baixo |

### Médio Prazo (2-4 semanas)

| # | Melhoria | Impacto | Esforço |
|---|----------|---------|---------|
| 6 | **Página de obrigado pós-formulário** — Redirect para página com vídeo do Beto + próximos passos | Alto | Médio |
| 7 | **Seção de portfólio** — Galeria com previews dos criativos produzidos (quando disponíveis) | Alto | Médio |
| 8 | **Blog/Conteúdo SEO** — Artigos sobre TikTok Shop para tráfego orgânico | Alto | Alto |
| 9 | **Chat ao vivo** — Widget de WhatsApp flutuante para captura imediata | Médio | Baixo |
| 10 | **Depoimentos em vídeo** — Clips curtos de clientes falando sobre resultados | Alto | Médio |

### Longo Prazo (1-3 meses)

| # | Melhoria | Impacto | Esforço |
|---|----------|---------|---------|
| 11 | **Dashboard do cliente** — Área logada para acompanhar produção e métricas | Alto | Alto |
| 12 | **Calculadora de ROI** — Ferramenta interativa que mostra economia vs equipe interna | Alto | Médio |
| 13 | **Multi-idioma** — Versão em inglês para mercado internacional | Médio | Médio |
| 14 | **Automação de email** — Sequência de nurturing para leads que não converteram | Alto | Médio |
| 15 | **Landing pages por nicho** — Páginas específicas para Beleza, Eletrônicos, Fitness etc. | Alto | Alto |

---

## 6. Comando Perpétuo de Melhoria Contínua

> **Regra:** A cada sessão, antes de qualquer implementação, buscar referências atualizadas de:
> - Formatos de vídeo TikTok Shop que estão performando (trends semanais)
> - Landing pages de alta conversão no nicho de serviços criativos
> - Dados de mercado atualizados (GMV, CPA médio, CTR benchmarks)
> - Feedback de leads que chegaram pelo formulário
>
> **Objetivo:** Nunca parar de otimizar. Cada sessão deve deixar o projeto melhor do que encontrou.

---

## 7. Stack Técnica

| Camada | Tecnologia |
|--------|-----------|
| Framework | React 19 + Vite 7 |
| Estilização | Tailwind CSS 4 + CSS custom |
| Componentes | shadcn/ui + Radix UI |
| Animações | Framer Motion + CSS transitions + hooks customizados |
| Fontes | Space Grotesk (display) + Inter (body) + JetBrains Mono (mono) |
| Hospedagem | Manus (Autoscale) |
| Domínio | moviemoney-dwepojx6.manus.space |

---

## 8. Arquivos-Chave

```
movie-money-landing/
├── client/
│   ├── index.html              → Meta tags, fontes, analytics
│   └── src/
│       ├── pages/Home.tsx      → Landing page completa (todas as seções)
│       ├── index.css           → Tema dark, animações, efeitos visuais
│       ├── hooks/
│       │   ├── useParallax.ts  → Hooks de parallax (mouse + scroll + transform)
│       │   └── useScrollReveal.ts → Hook de fade-in ao scroll + contadores
│       └── App.tsx             → Router + ThemeProvider (dark)
├── ideas.md                    → Brainstorm + Style Decisions
├── asset-urls.md               → URLs de todos os assets (imagens, vídeo)
└── ESTRUTURA_PROJETO_v2.1.md   → Este documento
```

---

## 9. Pontos de Retorno (Rollback)

| Versão | Descrição | Data |
|--------|-----------|------|
| 7f6de54b | Landing page v1.0 — Estrutura original com parallax e vídeo | 04/08/2026 |
| a984b245 | Landing page v2.0 — Nova estrutura pesquisa-driven | 04/08/2026 |
| **6e995833** | **Landing page v2.1 — 5 melhorias (ATUAL)** | **04/08/2026** |

---

*Documento gerado automaticamente. Atualizar a cada nova sessão.*
