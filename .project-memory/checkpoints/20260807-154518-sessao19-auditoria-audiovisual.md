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
