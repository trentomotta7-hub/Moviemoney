# Movie Money — Mapa do Repositório

> Atualizado em: 04/08/2026 — Sessão 15

---

## Estrutura Raiz

```
Moviemoney/
├── .project-memory/          ← MEMÓRIA DO PROJETO
├── skill-movie-money/        ← NÚCLEO DE PRODUÇÃO
├── docs/                     ← Documentação e estados de sessão
├── docs_projeto/             ← Documentação geral do projeto
└── README.md
```

---

## .project-memory/ — Memória do Projeto

| Arquivo | Conteúdo |
|---|---|
| `current-context.md` | **LEIA PRIMEIRO** — Estado atual, próximas ações, regras |
| `timeline.md` | Histórico cronológico de todas as sessões |
| `next-actions.md` | Próximas ações priorizadas com checklist de início de sessão |
| `repository-map.md` | Este arquivo — mapa completo do repositório |
| `decisions.md` | Decisões técnicas importantes e seus motivos |
| `bugs-and-fixes.md` | Bugs conhecidos, status e correções aplicadas |
| `checkpoints/` | Snapshots detalhados por sessão (YYYYMMDD-HHMMSS-slug.md) |

---

## skill-movie-money/ — Núcleo de Produção

### criativos/

| Pasta | Conteúdo | Status |
|---|---|---|
| `video_institucional_youtube/` | Vídeos 1 e 2 do YouTube + todos os takes, SCs, VOs | ✅ Vídeo 1 e 2 prontos |
| `video_beto_ceo/` | Vídeo CEO Beto — apresentação psicológica TikTok Shop | 🔄 Em produção |
| `criativo_01_bodysplash/` | Criativo produto #1 — Bodysplash (v8c FINAL) | ✅ Pronto |
| `roteiros/` | Roteiros prontos para produção | ✅ POV Sunscreen pronto |
| `banco_narrativo.md` | 70 dores mapeadas para hooks e scripts | ✅ Completo |

### templates/

| Pasta | Conteúdo |
|---|---|
| `personagens/` | Imagens base dos 6 personagens (beto.png, lucas_ferreira.png, marina_costa.png, rafael_santos.png, beatriz_oliveira.png, diego_almeida.png) |
| `cenas/` | Cenas de fundo por personagem (banheiro, quarto, home_office, etc.) |
| `videos/` | Takes de referência do Beto (beto_institucional_final.mp4 e versões) |

### references/

| Arquivo | Conteúdo |
|---|---|
| `elenco.md` | Fichas completas dos 6 personagens (visual, personalidade, tom de voz, nichos) |
| `mapa_vozes.md` | Mapeamento de voz por personagem (Fenrir = Beto) |
| `banco_narrativo.md` | 70 dores mapeadas por nicho |
| `pesquisa_formatos_tiktok_shop_2026.md` | 11 formatos, 10 hooks, benchmarks, Creative Codes |
| `checkpoint.md` | Checkpoint legado (substituído por .project-memory/) |
| `video_standards.md` | Padrões técnicos: resolução, codec, loudnorm, Ken Burns, safe zone |

### scripts/

| Script | Função |
|---|---|
| `montar_video2_v12_final.sh` | Montagem definitiva do Vídeo 2 v12 com re-encode total |
| `gerar_scs_v12.py` | Gera os 8 SCs com Ken Burns + VO + SC-3 com rostos reais |

### skills/moviemoney-production/

| Arquivo | Conteúdo |
|---|---|
| `SKILL.md` | Pipeline completo de produção (regras críticas, fases, estrutura de pastas) |

---

## docs/sessoes/

| Arquivo | Conteúdo |
|---|---|
| `ESTADO_SESSAO_13.md` | Vídeo 2 v12 FINAL — detalhes técnicos completos |
| `ESTADO_SESSAO_14.md` | Landing page + pesquisa formatos TikTok Shop 2026 |

---

## Vídeos Finais Disponíveis

| Vídeo | Caminho | Tamanho | Duração |
|---|---|---|---|
| Vídeo 1 — Quebrando Mitos | `criativos/video_institucional_youtube/video1_quebra_mitos_FINAL.mp4` | 54 MB | ~4min |
| Vídeo 2 — A Máquina por Dentro (v12) | `criativos/video_institucional_youtube/` (segmentos em temp_v10) | 33 MB | 3min58s |
| Bodysplash v8c FINAL | `criativos/criativo_01_bodysplash/criativo01_v8c_FINAL.mp4` | ~15 MB | ~30s |
| Beto Institucional Final | `templates/videos/beto_institucional_final.mp4` | ~10 MB | ~30s |
