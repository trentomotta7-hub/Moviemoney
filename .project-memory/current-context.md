# Contexto atual — Movie Money

> Ler este arquivo primeiro ao iniciar qualquer nova sessão.

## Identificação

| Campo | Valor |
|---|---|
| Projeto | Movie Money — Criativos que Vendem no TikTok Shop |
| Repositório | `trentomotta7-hub/Moviemoney` |
| Branch ativa | `master` |
| Última sessão | Sessão 19 — auditoria audiovisual e gate obrigatório |
| Aplicação full-stack | `apps/movie-money-fullstack/` |
| Checkpoint web gerenciado | `4132e698` |

## Estado consolidado

| Área | Estado | Evidência |
|---|---|---|
| Aplicação full-stack | Implementada, testada e otimizada | `apps/movie-money-fullstack/` |
| Backend de leads, oferta e admin | Concluído | `apps/movie-money-fullstack/server/`, `drizzle/` |
| E-mail real | Código pronto; credenciais pendentes | `apps/movie-money-fullstack/docs/email-setup.md` |
| Pipeline audiovisual | Reestruturado da mineração à entrega | `skill-movie-money/skills/moviemoney-production/` |
| Gate técnico | Implementado e validado | `scripts/qa_gate.py` |
| GC Sunscreen Stick v6 | **REJECTED** — tecnicamente íntegro, perceptualmente inadequado | `docs/auditoria_video/gate/` |
| POV Sunscreen Stick v2 | **REJECTED** — produto inconsistente e narração truncada | `docs/auditoria_video/gate/` |
| Vídeo 1 institucional | **REJECTED** — drift, cauda e freeze prolongado | `docs/auditoria_video/gate/` |
| Vídeo 2 institucional | Não reauditado nesta sessão; não presumir aprovação | Aplicar o protocolo antes de qualquer uso |
| Vídeo 3 / VSL | Rascunho de aproximadamente 5 minutos; incompleto | `skill-movie-money/criativos/video_institucional_youtube/VSL_Beto/` |

## Regra perpétua audiovisual

Nenhum arquivo pode ser entregue, publicado ou chamado de final sem `TECHNICALLY_APPROVED` e certificado perceptual `APPROVED`, ambos vinculados ao SHA-256 do master. Uma única falha crítica reprova; notas de ritmo, hook ou edição não compensam lip sync, produto, realismo, narração, claims, drift ou freeze.

A montagem deve produzir `CANDIDATE`. Somente após todos os gates o arquivo pode ser promovido para `APPROVED` e receber manifesto de entrega.

## Como retomar

1. Ler o checkpoint mais recente em `.project-memory/checkpoints/`.
2. Ler `skill-movie-money/skills/moviemoney-production/SKILL.md`.
3. Para nova produção, iniciar pelo dossiê de mineração e pelo manifesto de takes.
4. Aprovar cada take isoladamente antes da montagem.
5. Executar `qa_gate.py`, transcrição, revisão multimodal, inspeção dirigida, comparação com produto âncora e compliance.
6. Não reutilizar os vereditos antigos de `FINAL`, `PRONTO`, `9,8/10` ou `QA técnico` como autorização de entrega.

## Decisões que não devem regredir

Na aplicação, o countdown é calculado no servidor e não reinicia no recadastro; LGPD é obrigatória; tokens não expõem o e-mail; admin usa autorização server-side; prova social não contém números inventados.

No audiovisual, produto âncora, lip sync ≥ 9/10, narração completa, realismo, claims comprovados, gate técnico, certificado perceptual e checksum são obrigatórios.

## Bloqueios externos

O envio de confirmação depende de `RESEND_API_KEY` e `EMAIL_FROM`. A publicação da aplicação depende do proprietário. A refação dos vídeos não está bloqueada externamente, mas deve seguir o pipeline novo desde a mineração.
