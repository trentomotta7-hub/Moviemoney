# Certificado perceptual — Vídeo 1 institucional

| Campo | Valor |
|---|---|
| Arquivo candidato | `video1_quebra_mitos_FINAL.mp4` |
| SHA-256 | `66dd968179c1e9b162728f6df9575ab09eefb8b0efdca49fd1f75d49c57174ad` |
| Formato | Institucional / 16:9 |
| Relatório técnico | `institucional_v1_tecnico.md` — `TECHNICALLY_REJECTED` |
| Auditoria multimodal | `../institucional_v1_analise_perceptual.txt` |
| Evidência de quadros | `../institucional_contact_sheet.jpg` |

## Critérios críticos

| Critério | Evidência | Status |
|---|---|---|
| Drift e cauda | Áudio termina 7,453 s antes do vídeo | **FAIL** |
| Freeze | Segmento congelado de 12,533 s entre aproximadamente 68,73–81,27 s | **FAIL** |
| Lip sync | Articulação insuficiente de fonemas bilabiais e labiodentais; trecho UGC sem sincronia confiável | **FAIL** |
| Realismo | Porta-voz rígido e repetição de pose; mãos/gestos com aparência artificial | **FAIL** |
| Narração | Voz inteligível, mas sem respirações e com ressonância artificial | **FAIL** |
| Continuidade | Retornos ao porta-voz na mesma pose e encerramento abrupto | **FAIL** |
| Acabamento | Loudness -19 LUFS, true peak -0,9 dBTP, trecho final sem fechamento adequado | **FAIL** |

A similaridade SSIM entre quadros extraídos em 69 s e 75 s foi `0,999975`, confirmando congelamento praticamente idêntico ao longo do trecho.

## Veredito

**REJECTED.** Corrigir a timeline, eliminar o freeze e a cauda, reequilibrar loudness/peak, refazer os trechos com lip sync insuficiente e concluir o encerramento antes de executar novamente os dois gates.
