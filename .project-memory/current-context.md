# Movie Money — Contexto Atual do Projeto

> **⚡ LEIA ESTE ARQUIVO PRIMEIRO ao iniciar qualquer nova sessão.**
> Ele é o ponto de retomada oficial. Não perca tempo contextualizando do zero.

---

## Identificação

| Campo | Valor |
|---|---|
| **Projeto** | Movie Money — Criativos que Vendem no TikTok Shop |
| **Repositório** | `trentomotta7-hub/Moviemoney` |
| **Branch ativa** | `master` |
| **Última sessão** | Sessão 16 — 05/08/2026 |
| **Último commit** | `sessao16` — vídeo POV Sunscreen Stick SPF v2 (QA 9.8/10) |
| **Landing page** | [moviemoney-dwepojx6.manus.space](https://moviemoney-dwepojx6.manus.space) |

---

## O que é o projeto

A Movie Money é uma empresa de produção de criativos de alta conversão para TikTok Shop. O repositório contém:

1. **Skill de produção** (`skill-movie-money/`) — pipeline completo de criação de vídeos com elenco de 6 personagens com IA
2. **Vídeos institucionais YouTube** — série de vídeos do Beto (CEO) explicando a ferramenta
3. **Criativos de produto** — vídeos GC + POV por produto minerado
4. **Landing page** — publicada em `moviemoney-dwepojx6.manus.space`
5. **Documentação** — roteiros, estados de sessão, referências técnicas

---

## Estado de Cada Entrega

| Entrega | Status | Arquivo / URL |
|---|---|---|
| **Vídeo 1 — Quebrando Mitos** | ✅ PRONTO | `criativos/video_institucional_youtube/video1_quebra_mitos_FINAL.mp4` (54 MB) |
| **Vídeo 2 — A Máquina por Dentro** | ✅ PRONTO (v12) | `criativos/video_institucional_youtube/` — aprovado QA, 3min58s, 20 segmentos |
| **Landing Page** | ✅ NO AR (v3.0) | [moviemoney-dwepojx6.manus.space](https://moviemoney-dwepojx6.manus.space) — dark glitch, 13 seções, vídeo Beto integrado, mobile corrigido |
| **Roteiro POV Sunscreen Stick** | ✅ PRONTO | `criativos/roteiros/POV_sunscreen_stick_spf_v1.md` |
| **Vídeo CEO (Beto apresentação)** | ✅ PRONTO | `criativos/video_beto_ceo/video_beto_ceo_v1_FINAL.mp4` (7.1 MB, 38s, QA aprovado) |
| **Vídeo POV Sunscreen Stick** | ✅ PRONTO (v2) | `criativos/sunscreen_stick_spf/POV/montagem/sunscreen_stick_spf_pov_v2_FINAL.mp4` (6.4 MB, 32s, QA 9.8/10) |
| **Vídeo 3 — A Oferta (VSL)** | ❌ NÃO INICIADO | Próxima campanha |
| **Backend de leads (landing)** | ❌ NÃO INICIADO | Formulário não salva no banco ainda |

---

## Próximas Ações IMEDIATAS (Sessão 16 — CONCLUÍDA)

1. **[✅ CONCLUÍDO]** Vídeo POV Sunscreen Stick SPF v1 produzido (QA 5.4/10)
2. **[✅ CONCLUÍDO]** Correções aplicadas: CTA completo, áudio regravado, duração estendida
3. **[✅ CONCLUÍDO]** Vídeo POV Sunscreen Stick SPF v2 aprovado em QA (9.8/10)
4. **[✅ CONCLUÍDO]** Checkpoint salvo e commit no GitHub

---

## Próximas Ações FUTURAS (Sessões seguintes)

1. Criar variações A/B do POV Sunscreen Stick (5 hooks x 4 CTAs = 20 vídeos)
2. Produzir criativo GC do Sunscreen Stick (Marina Costa, formato depoimento)
3. Produzir Vídeo 3 "A Oferta" (VSL de vendas, 8-12 min, Beto CEO)
4. Integrar backend de leads na landing page (web-db-user)
5. Adicionar countdown de urgência no CTA da landing
6. Criar criativos GC + POV para produto #2 (a definir)

---

## Regras Permanentes do Projeto

### Regra de Continuidade (OBRIGATÓRIA)
> A cada nova sessão, ANTES de qualquer produção:
> 1. Ler este arquivo (`current-context.md`)
> 2. Ler o último checkpoint em `.project-memory/checkpoints/`
> 3. Verificar novos trends no TikTok Creative Center
> 4. Checar Top Ads Dashboard
> 5. Buscar novos benchmarks da categoria
> 6. Analisar feedback de performance dos vídeos anteriores
> 7. Ajustar hooks e formatos baseado em dados reais

### Regra de Produto (Anti-Strike)
> O produto nos vídeos DEVE SER IDÊNTICO ao produto minerado. Nunca usar imagens genéricas.

### Regra de Dois Criativos
> Todo produto minerado deve ter GC + POV obrigatoriamente.

### Regra de Voz
> Voz do Beto = **Fenrir** (voz oficial). Nunca usar TTS robótico (gTTS).

### Regra de Qualidade
> Sempre rodar `manus-analyze-video` antes de entregar qualquer vídeo.

---

## Estrutura do Repositório (Mapa Rápido)

```
Moviemoney/
├── .project-memory/          ← MEMÓRIA DO PROJETO (este diretório)
│   ├── current-context.md    ← LEIA PRIMEIRO em nova sessão
│   ├── timeline.md           ← Histórico de sessões
│   ├── next-actions.md       ← Próximas ações detalhadas
│   ├── repository-map.md     ← Mapa completo do repositório
│   ├── decisions.md          ← Decisões técnicas importantes
│   ├── bugs-and-fixes.md     ← Bugs conhecidos e correções
│   └── checkpoints/          ← Snapshots por sessão
├── skill-movie-money/
│   ├── criativos/            ← Todos os vídeos e assets produzidos
│   │   ├── video_institucional_youtube/  ← Vídeos 1 e 2
│   │   ├── video_beto_ceo/   ← Vídeo CEO (em produção)
│   │   ├── criativo_01_bodysplash/       ← Criativo produto #1
│   │   └── roteiros/         ← Roteiros prontos para produção
│   ├── templates/
│   │   ├── personagens/      ← Imagens base dos 6 personagens
│   │   └── videos/           ← Takes de referência do Beto
│   ├── references/           ← Elenco, vozes, banco narrativo, pesquisas
│   └── skills/               ← Skill de produção com pipeline completo
├── docs/
│   └── sessoes/              ← Estados detalhados por sessão
└── docs_projeto/             ← Documentação geral do projeto
```

---

## Personagens do Elenco

| Personagem | Arquivo | Voz | Nicho |
|---|---|---|---|
| **Beto** (CEO) | `templates/personagens/beto.png` | Fenrir | Institucional, apresentação |
| **Lucas Ferreira** | `templates/personagens/lucas_ferreira.png` | — | Tech, gadgets, masculino |
| **Marina Costa** | `templates/personagens/marina_costa.png` | — | Beleza, skincare, feminino |
| **Rafael Santos** | `templates/personagens/rafael_santos.png` | — | Fitness, saúde, premium |
| **Beatriz Oliveira** | `templates/personagens/beatriz_oliveira.png` | — | Produtividade, home office |
| **Diego Almeida** | `templates/personagens/diego_almeida.png` | — | Viral, unboxing, Gen Z |

---

## Informações Técnicas da Landing Page

- **URL:** moviemoney-dwepojx6.manus.space
- **Stack:** Vite + React + TypeScript + TailwindCSS (web-static)
- **Estética:** Dark Digital Glitch (preto, cyan #00E5FF, magenta #FF1744)
- **Bug conhecido:** No mobile, o vídeo hero e imagens não aparecem corretamente
- **Projeto webdev:** Criado em sessão anterior (não está no sandbox atual — precisa recriar ou usar webdev_init_project com o ID do projeto existente)
