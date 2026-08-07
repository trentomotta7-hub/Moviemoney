# Checkpoint — Sessão 20: auditoria completa de todos os masters

**Data:** 2026-08-07T17:30:00Z  
**Status:** Auditoria completa concluída. Todos os masters têm veredito definitivo.

## Objetivo concluído

Todos os arquivos de vídeo com master montado no repositório foram submetidos ao gate técnico (`qa_gate.py`) e à auditoria perceptual multimodal. Nenhum arquivo passou. Todos recebem veredito **REJECTED**.

## Vereditos definitivos

| Master | Gate técnico | Gate perceptual | Veredito |
|---|---|---|---|
| GC Sunscreen Stick v5 | TECHNICALLY_REJECTED | REJECTED | **REJECTED** |
| POV Sunscreen Stick v1 | TECHNICALLY_REJECTED | REJECTED | **REJECTED** |
| Vídeo 1 institucional (FINAL) | TECHNICALLY_REJECTED | REJECTED | **REJECTED** |
| Vídeo 1 institucional (MONTADO) | TECHNICALLY_REJECTED | — | **REJECTED** |
| Vídeo 2 institucional (sem_marca) | TECHNICALLY_REJECTED | REJECTED | **REJECTED** |
| Criativo 01 Bodysplash v8 | TECHNICALLY_REJECTED | — | **REJECTED** |
| Criativo 01 Bodysplash v8b | TECHNICALLY_REJECTED | — | **REJECTED** |
| Criativo 01 Bodysplash v8c | TECHNICALLY_REJECTED | REJECTED | **REJECTED** |
| Beto institucional final | TECHNICALLY_REJECTED | — | **REJECTED** |
| Beto institucional v3 | TECHNICALLY_REJECTED | — | **REJECTED** |
| Beto institucional v4 | TECHNICALLY_REJECTED | REJECTED | **REJECTED** |
| GC Sunscreen Stick v6 | (sem .mp4 no repo) | REJECTED (sessão 19) | **REJECTED** |

## Falhas técnicas mais comuns

- Sample rate 96 kHz ou 44,1 kHz (exigido 48 kHz): GC v5, POV v1, Bodysplash v8/v8b
- Loudness abaixo de -17 LUFS: Bodysplash v8c, Beto v3/v4/final, Vídeo 2
- Drift/cauda excessiva: Vídeo 1, Vídeo 2, Beto v3/v4/final
- Freeze não intencional: Vídeo 1 (12,5 s), Vídeo 2 (19,4 s)

## Falhas perceptuais mais comuns

- Lip sync insuficiente (< 9/10): GC v5, Bodysplash v8c, Beto v4
- Produto inconsistente ou sem rótulo: POV v1, Bodysplash v8c
- Narração truncada / CTA ausente: POV v1
- Continuidade quebrada: Vídeo 1 (freeze + cauda), Vídeo 2 (repetição + glitch)

## Evidências salvas

| Evidência | Caminho |
|---|---|
| Relatório consolidado | `docs/auditoria_video/RELATORIO_AUDITORIA_COMPLETA_SESSAO20.md` |
| Gates técnicos (sessão 20) | `docs/auditoria_video/gate_sessao20/` |
| Gates técnicos e perceptuais (sessão 19) | `docs/auditoria_video/gate/` |

## Próximo ponto de retomada

Iniciar a reconstrução dos masters, começando pelo de maior impacto comercial. Ordem sugerida:

1. **GC Sunscreen Stick** — produto âncora definido, takes com áudio nativo 48 kHz, lip sync ≥ 9/10 por take
2. **POV Sunscreen Stick** — produto único, rótulo em português, narração completa
3. **Vídeo 2 institucional** — apenas correções de edição (repetição, glitch, freeze, loudness)
4. **Vídeo 1 institucional** — cortar cauda, eliminar freeze, normalizar áudio
5. **Criativo 01 Bodysplash** — produto âncora com rótulo, lip sync, loudness
6. **Beto institucional** — regerar em 16:9, normalizar, adicionar encerramento
