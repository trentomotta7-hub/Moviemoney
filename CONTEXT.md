# CONTEXT.md — Moviemoney

> Documento de continuidade. Ler este arquivo e os checkpoints específicos do projeto antes de retomar o trabalho.

## Última atualização

| Campo | Valor |
|---|---|
| Data | 2026-08-07 15:48:39 UTC |
| Branch | `master` |
| Commit base antes deste checkpoint | `4af218d6bd53f961cc97aaf9c823c653ff92aefd` |
| Remote | `https://github.com/trentomotta7-hub/Moviemoney.git` |

## Contexto da sessão

# Checkpoint — Sessão 19: auditoria audiovisual e gate obrigatório

**Data:** 2026-08-07T15:45:18Z
**Status:** Processo auditado e protocolo implantado; masters recentes reclassificados como não entregáveis.

## Objetivo concluído

A sessão revisou o processo completo de vídeo, da mineração à entrega, e verificou os masters mais recentes com critérios técnicos e perceptuais independentes. A auditoria demonstrou que os relatórios anteriores confundiam integridade técnica com qualidade real: vídeos podiam receber `FINAL`, `PRONTO` ou nota alta sem validação rigorosa de lip sync, realismo, produto, narração e claims.

## Vereditos corrigidos

| Master | Gate técnico | Gate perceptual | Entrega |
|---|---|---|---|
| GC Sunscreen Stick v6 | `TECHNICALLY_APPROVED` | `REJECTED` | **BLOQUEADA** |
| POV Sunscreen Stick v2 | `TECHNICALLY_REJECTED` | `REJECTED` | **BLOQUEADA** |
| Vídeo 1 institucional | `TECHNICALLY_REJECTED` | `REJECTED` | **BLOQUEADA** |

O GC v6 possui drift de 0,007 s e loudness de -16 LUFS, mas falha em lip sync perceptual, realismo, mãos, rótulo, voz e claims. O POV v2 usa produtos diferentes entre takes, apresenta mãos/física artificiais, texto visual inadequado e narração truncada. O institucional contém drift/cauda de 7,453 s e freeze de 12,533 s, além de problemas perceptuais.

## Mudanças implantadas

| Entrega | Caminho |
|---|---|
| Pipeline da mineração à entrega | `skill-movie-money/skills/moviemoney-production/references/pipeline_ponta_a_ponta.md` |
| Protocolo forense completo | `skill-movie-money/skills/moviemoney-production/references/protocolo_forense_audiovisual.md` |
| Gate técnico executável | `skill-movie-money/skills/moviemoney-production/scripts/qa_gate.py` |
| Templates de mineração, takes, certificado e entrega | `skill-movie-money/skills/moviemoney-production/templates/qa/` |
| Diagnóstico e evidências | `docs/auditoria_video/` |
| Skill segura de continuidade | `/home/ubuntu/skills/continuity-sync/` |

## Novas regras perpétuas

1. Não usar `FINAL`, `PERFEITO`, `PRONTO` ou `APROVADO` antes dos gates.
2. A montagem gera somente `CANDIDATE`.
3. O gate técnico deve retornar `TECHNICALLY_APPROVED`.
4. O certificado perceptual deve retornar `APPROVED` sem média compensatória.
5. Lip sync GC/TH exige nota mínima 9/10 e nenhum fonema crítico visivelmente errado.
6. Produto deve ser idêntico ao produto âncora em todos os takes.
7. Narração deve estar completa, natural e coerente; CTA cortado reprova.
8. Claims, preço e escassez exigem evidência específica do SKU e da oferta.
9. Entrega exige manifesto e SHA-256 do mesmo arquivo auditado.
10. Continuidade usa prévia e staging explícito; nunca `git add .` automático.

## Validações

As skills `movie-money`, `moviemoney-production` e `tiktokshop-creative-audit` passaram na validação estrutural. O script `qa_gate.py` passou em compilação Python e foi executado nos três masters. A skill `continuity-sync` revisada passou em compilação, validação estrutural e teste de prévia sem escrita, commit ou push.

## Próximo ponto de retomada

Não gerar novas variações nem entregar os masters atuais. A próxima produção deve começar pelo dossiê de mineração e pelo manifesto de takes. Para o Sunscreen Stick, refazer primeiro o GC e o POV como `CANDIDATE`, aprovando cada take isoladamente. Executar os dois gates antes de promover qualquer arquivo para `APPROVED`.

## Estado do checkout antes do checkpoint

```text
[31mM[m .project-memory/current-context.md
 [31mM[m .project-memory/next-actions.md
 [31mM[m .project-memory/timeline.md
 [31mM[m skill-movie-money/SKILL.md
 [31mM[m skill-movie-money/references/pipeline_producao.md
 [31mM[m skill-movie-money/skills/moviemoney-production/SKILL.md
 [31mM[m skill-movie-money/skills/moviemoney-production/references/protocolo_forense_audiovisual.md
 [31mM[m skill-movie-money/skills/tiktokshop-creative-audit/SKILL.md
[31m??[m .project-memory/checkpoints/20260807-154518-sessao19-auditoria-audiovisual.md
[31m??[m docs/auditoria_video/achados_visuais_quadros.md
[31m??[m docs/auditoria_video/diagnostico_pipeline.md
[31m??[m docs/auditoria_video/gate/gc_v6_perceptual.md
[31m??[m docs/auditoria_video/gate/gc_v6_tecnico.json
[31m??[m docs/auditoria_video/gate/gc_v6_tecnico.md
[31m??[m docs/auditoria_video/gate/institucional_v1_perceptual.md
[31m??[m docs/auditoria_video/gate/institucional_v1_tecnico.json
[31m??[m docs/auditoria_video/gate/institucional_v1_tecnico.md
[31m??[m docs/auditoria_video/gate/pov_v2_perceptual.md
[31m??[m docs/auditoria_video/gate/pov_v2_tecnico.json
[31m??[m docs/auditoria_video/gate/pov_v2_tecnico.md
[31m??[m docs/auditoria_video/gc_contact_sheet.jpg
[31m??[m docs/auditoria_video/institucional_contact_sheet.jpg
[31m??[m docs/auditoria_video/pov_contact_sheet.jpg
[31m??[m docs/auditoria_video/relatorios/gc_v6_transcricao_independente.txt
[31m??[m docs/auditoria_video/relatorios/pov_v2_transcricao_independente.txt
[31m??[m docs/auditoria_video/relatorios/video_sunscreen_gc_v6_analysis_20260807_152438.md
[31m??[m docs/auditoria_video/relatorios/video_sunscreen_pov_v2_analysis_20260807_152528.md
[31m??[m docs/auditoria_video/relatorios/video_video1_quebra_mitos_FINAL_analysis_20260807_152634.md
[31m??[m docs/auditoria_video/revisao_continuity_sync.md
[31m??[m docs/auditoria_video/tecnico/gc_v6_resumo.txt
[31m??[m docs/auditoria_video/tecnico/institucional_v1_resumo.txt
[31m??[m docs/auditoria_video/tecnico/pov_v2_resumo.txt
[31m??[m docs/auditoria_video/validacao_protocolo.md
[31m??[m skill-movie-money/skills/moviemoney-production/references/pipeline_ponta_a_ponta.md
[31m??[m skill-movie-money/skills/moviemoney-production/scripts/qa_gate.py
[31m??[m skill-movie-money/skills/moviemoney-production/templates/qa/certificado_perceptual.md
[31m??[m skill-movie-money/skills/moviemoney-production/templates/qa/manifesto_entrega.md
[31m??[m skill-movie-money/skills/moviemoney-production/templates/qa/manifesto_takes.csv
[31m??[m skill-movie-money/skills/moviemoney-production/templates/qa/mineracao_produto.md
```

## Histórico recente

```text
[33m4af218d[m fix: remover placeholder de analytics do build
[33m513e634[m checkpoint: atualização automática de continuidade [2026-08-07 03:38:23 UTC]
[33me829ed6[m docs: sessão 18 — code-splitting, otimização de bundle e landing pronta para publicação
[33ma1d8a5b[m feat: code-splitting e otimização de bundle
[33me5423d7[m feat: conclude session 17 full-stack and creative pipeline
[33me7edfe7[m feat(skill): produto âncora + atuação vocal — regras perpétuas anti-strike
[33m05ab9e1[m docs(skill): padrão v5 definitivo — lip sync real, pipeline GC+POV, protocolo forense
[33m9669ac4[m feat(gc-v5): GC Sunscreen Stick v5 FINAL — padrão definitivo de produção
[33mb11b869[m fix(lip-sync): protocolo forense perpétuo + GC v4 + limitação técnica documentada
[33m975c5fc[m feat(sunscreen-stick-gc): GC v1 FINAL — Marina Costa, 30s, QA 10/10 + skill atualizada
[33m9211216[m feat(sunscreen-stick): POV v2 FINAL — Marina Costa, 32s, QA 9.8/10
[33m5975c2d[m fix(BUG-007): vídeo CEO v2 — keyframe único + áudio natural + crossfades + lip sync corrigido. QA aprovado 7/7
[33m4580746[m checkpoint(sessão-15-final): vídeo CEO Beto completo (38s QA aprovado) + landing page v3.0 com correção mobile + sistema .project-memory atualizado
[33ma620dc6[m checkpoint(sessão-15): sistema .project-memory criado — continuidade permanente entre sessões + take1 vídeo CEO Beto
[33m4e39f35[m roteiro: POV Sunscreen Stick SPF — produto #1 trending TikTok Shop Ago/2026 (Marina Costa)
```

## Arquivos rastreados

```text
.gitignore
.project-memory/.gitkeep
.project-memory/bugs-and-fixes.md
.project-memory/checkpoints/20260804-225000-sessao15-sistema-memoria.md
.project-memory/checkpoints/20260804-231500-sessao15-completa.md
.project-memory/checkpoints/20260804-232500-sessao15-video-v2.md
.project-memory/checkpoints/20260805-182200-sessao16-pov-sunscreen.md
.project-memory/checkpoints/20260806-015547-sessao17-fullstack-gc-vsl.md
.project-memory/current-context.md
.project-memory/decisions.md
.project-memory/next-actions.md
.project-memory/repository-map.md
.project-memory/sessao18-melhorias.md
.project-memory/timeline.md
CHANGELOG.md
CONTEXT.md
FRAMEWORK_ROTEIROS.md
GUIA_POV.md
README.md
ROTEIROS_EXEMPLO.md
apps/movie-money-fullstack/.githooks/pre-commit
apps/movie-money-fullstack/.gitignore
apps/movie-money-fullstack/.gitkeep
apps/movie-money-fullstack/.prettierignore
apps/movie-money-fullstack/.prettierrc
apps/movie-money-fullstack/.project-memory/CONTINUITY_PROTOCOL.md
apps/movie-money-fullstack/.project-memory/PERMISSIONS.md
apps/movie-money-fullstack/.project-memory/checkpoints/20260806-013511-fullstack-continuity-baseline.md
apps/movie-money-fullstack/.project-memory/checkpoints/20260806-015547-fullstack-landing-admin-final.md
apps/movie-money-fullstack/.project-memory/checkpoints/20260806-015823-auto-main.md
apps/movie-money-fullstack/.project-memory/checkpoints/TEMPLATE.md
apps/movie-money-fullstack/.project-memory/current-context.md
apps/movie-money-fullstack/.project-memory/next-actions.md
apps/movie-money-fullstack/ONBOARDING.md
apps/movie-money-fullstack/README.md
apps/movie-money-fullstack/client/index.html
apps/movie-money-fullstack/client/public/.gitkeep
apps/movie-money-fullstack/client/public/__manus__/debug-collector.js
apps/movie-money-fullstack/client/src/App.tsx
apps/movie-money-fullstack/client/src/_core/hooks/useAuth.ts
apps/movie-money-fullstack/client/src/components/AIChatBox.tsx
apps/movie-money-fullstack/client/src/components/DashboardLayout.tsx
apps/movie-money-fullstack/client/src/components/DashboardLayoutSkeleton.tsx
apps/movie-money-fullstack/client/src/components/ErrorBoundary.tsx
apps/movie-money-fullstack/client/src/components/ManusDialog.tsx
apps/movie-money-fullstack/client/src/components/Map.tsx
apps/movie-money-fullstack/client/src/components/ui/accordion.tsx
apps/movie-money-fullstack/client/src/components/ui/alert-dialog.tsx
apps/movie-money-fullstack/client/src/components/ui/alert.tsx
apps/movie-money-fullstack/client/src/components/ui/aspect-ratio.tsx
apps/movie-money-fullstack/client/src/components/ui/avatar.tsx
apps/movie-money-fullstack/client/src/components/ui/badge.tsx
apps/movie-money-fullstack/client/src/components/ui/breadcrumb.tsx
apps/movie-money-fullstack/client/src/components/ui/button-group.tsx
apps/movie-money-fullstack/client/src/components/ui/button.tsx
apps/movie-money-fullstack/client/src/components/ui/calendar.tsx
apps/movie-money-fullstack/client/src/components/ui/card.tsx
apps/movie-money-fullstack/client/src/components/ui/carousel.tsx
apps/movie-money-fullstack/client/src/components/ui/chart.tsx
apps/movie-money-fullstack/client/src/components/ui/checkbox.tsx
apps/movie-money-fullstack/client/src/components/ui/collapsible.tsx
apps/movie-money-fullstack/client/src/components/ui/command.tsx
apps/movie-money-fullstack/client/src/components/ui/context-menu.tsx
apps/movie-money-fullstack/client/src/components/ui/dialog.tsx
apps/movie-money-fullstack/client/src/components/ui/drawer.tsx
apps/movie-money-fullstack/client/src/components/ui/dropdown-menu.tsx
apps/movie-money-fullstack/client/src/components/ui/empty.tsx
apps/movie-money-fullstack/client/src/components/ui/field.tsx
apps/movie-money-fullstack/client/src/components/ui/form.tsx
apps/movie-money-fullstack/client/src/components/ui/hover-card.tsx
apps/movie-money-fullstack/client/src/components/ui/input-group.tsx
apps/movie-money-fullstack/client/src/components/ui/input-otp.tsx
apps/movie-money-fullstack/client/src/components/ui/input.tsx
apps/movie-money-fullstack/client/src/components/ui/item.tsx
apps/movie-money-fullstack/client/src/components/ui/kbd.tsx
apps/movie-money-fullstack/client/src/components/ui/label.tsx
apps/movie-money-fullstack/client/src/components/ui/menubar.tsx
apps/movie-money-fullstack/client/src/components/ui/navigation-menu.tsx
apps/movie-money-fullstack/client/src/components/ui/pagination.tsx
apps/movie-money-fullstack/client/src/components/ui/popover.tsx
apps/movie-money-fullstack/client/src/components/ui/progress.tsx
apps/movie-money-fullstack/client/src/components/ui/radio-group.tsx
apps/movie-money-fullstack/client/src/components/ui/resizable.tsx
apps/movie-money-fullstack/client/src/components/ui/scroll-area.tsx
apps/movie-money-fullstack/client/src/components/ui/select.tsx
apps/movie-money-fullstack/client/src/components/ui/separator.tsx
apps/movie-money-fullstack/client/src/components/ui/sheet.tsx
apps/movie-money-fullstack/client/src/components/ui/sidebar.tsx
apps/movie-money-fullstack/client/src/components/ui/skeleton.tsx
apps/movie-money-fullstack/client/src/components/ui/slider.tsx
apps/movie-money-fullstack/client/src/components/ui/sonner.tsx
apps/movie-money-fullstack/client/src/components/ui/spinner.tsx
apps/movie-money-fullstack/client/src/components/ui/switch.tsx
apps/movie-money-fullstack/client/src/components/ui/table.tsx
apps/movie-money-fullstack/client/src/components/ui/tabs.tsx
apps/movie-money-fullstack/client/src/components/ui/textarea.tsx
apps/movie-money-fullstack/client/src/components/ui/toggle-group.tsx
apps/movie-money-fullstack/client/src/components/ui/toggle.tsx
apps/movie-money-fullstack/client/src/components/ui/tooltip.tsx
apps/movie-money-fullstack/client/src/const.ts
apps/movie-money-fullstack/client/src/contexts/ThemeContext.tsx
apps/movie-money-fullstack/client/src/hooks/useComposition.ts
apps/movie-money-fullstack/client/src/hooks/useMobile.tsx
apps/movie-money-fullstack/client/src/hooks/usePersistFn.ts
apps/movie-money-fullstack/client/src/index.css
apps/movie-money-fullstack/client/src/lib/trpc.ts
apps/movie-money-fullstack/client/src/lib/utils.ts
apps/movie-money-fullstack/client/src/main.tsx
apps/movie-money-fullstack/client/src/pages/Admin.tsx
apps/movie-money-fullstack/client/src/pages/ComponentShowcase.tsx
apps/movie-money-fullstack/client/src/pages/Home.tsx
apps/movie-money-fullstack/client/src/pages/NotFound.tsx
apps/movie-money-fullstack/client/src/pages/Offer.tsx
apps/movie-money-fullstack/components.json
apps/movie-money-fullstack/docs/architecture.md
apps/movie-money-fullstack/docs/design-reference.md
apps/movie-money-fullstack/docs/email-setup.md
apps/movie-money-fullstack/docs/visual-qa-landing.md
apps/movie-money-fullstack/drizzle.config.ts
apps/movie-money-fullstack/drizzle/0000_magenta_moondragon.sql
... (791 arquivos adicionais)
```

## Como retomar

1. Clonar o repositório ou executar `git fetch`.
2. Fazer checkout do commit informado no prompt de continuidade entregue ao final do checkpoint.
3. Ler este arquivo, os checkpoints específicos e o histórico recente.
4. Executar as verificações técnicas descritas no contexto antes de continuar.
