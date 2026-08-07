---
name: movie-money
description: Operação Movie Money para mineração, roteiros, produção, auditoria e entrega de criativos GC, POV e vídeos institucionais. Use para qualquer trabalho audiovisual do projeto, incluindo Beto, elenco UGC, TikTok Shop, VSL, lip sync, narração, produto e QA.
---

# Movie Money

Produzir vídeos de venda e institucionais com rastreabilidade da mineração à entrega. Usar Beto como porta-voz institucional e o elenco oficial nos criativos UGC.

## Regra de entrada

Ler `skills/moviemoney-production/SKILL.md` antes de planejar, gerar, montar, auditar ou entregar qualquer vídeo. Essa skill contém o pipeline vigente e substitui procedimentos antigos que permitiam aprovação apenas por metadados ou nota média.

## Regra perpétua de qualidade

> Nenhum vídeo pode ser entregue, publicado ou chamado de final sem gate técnico e certificado perceptual aprovados e vinculados ao checksum do master.

Uma falha crítica reprova. Não compensar lip sync fora, produto diferente, mão deformada, voz truncada, texto alucinado, claim sem prova, drift ou freeze com notas altas de ritmo, hook ou edição.

## Formatos

| Formato | Estratégia |
|---|---|
| GC/UGC com rosto | Fala e áudio nativos no mesmo take; QA de lip sync ≥ 9/10 |
| POV sem rosto | TTS externo permitido; QA rígido de mãos, física e produto |
| Institucional/YouTube | Beto + screen recordings/B-roll; continuidade, voz e acabamento completos |

TikTok/Reels usa 9:16. YouTube usa 16:9. Manter elementos críticos na Safe Zone e usar marca d'água conforme a identidade Movie Money.

## Recursos obrigatórios

| Recurso | Quando ler |
|---|---|
| `skills/moviemoney-production/SKILL.md` | Sempre |
| `skills/moviemoney-production/references/pipeline_ponta_a_ponta.md` | Da mineração à entrega |
| `skills/moviemoney-production/references/protocolo_forense_audiovisual.md` | Antes de montar, auditar ou entregar |
| `references/elenco.md` | Antes de escolher personagem |
| `references/banco_narrativo.md` | Antes de escrever roteiro |
| `references/checkpoint.md` e `.project-memory/` | Ao retomar sessão |

## Continuidade

Ao concluir uma mudança significativa, atualizar o checkpoint e usar a skill segura `continuity-sync` primeiro em modo de prévia. Sincronizar somente arquivos autorizados; não incluir segredos, dependências, builds, caches ou masters pesados no Git.
