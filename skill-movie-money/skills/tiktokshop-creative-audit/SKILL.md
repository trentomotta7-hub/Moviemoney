---
name: tiktokshop-creative-audit
description: Auditoria técnica, perceptual e de compliance para criativos TikTok Shop. Use para avaliar lip sync, realismo, narração, produto, mãos, texto, claims, drift, silêncio, Safe Zone e prontidão de entrega de GC ou POV.
---

# Auditoria de criativos TikTok Shop

Usar o protocolo vigente em `../moviemoney-production/references/protocolo_forense_audiovisual.md`. Não aprovar por nota média e não usar o nome do arquivo ou relatórios anteriores como evidência de qualidade.

## Ordem obrigatória

1. Executar o gate técnico com `../moviemoney-production/scripts/qa_gate.py`.
2. Transcrever o áudio e comparar com o roteiro.
3. Revisar o vídeo integralmente com áudio.
4. Executar auditoria multimodal com timestamps.
5. Inspecionar quadros ou clipes nos timestamps suspeitos.
6. Comparar cada take com o produto âncora.
7. Conferir claims, preço e escassez contra o dossiê de mineração.
8. Preencher o certificado perceptual.

## Falhas bloqueadoras

| Critério | Regra |
|---|---|
| Lip sync GC/TH | ≥ 9/10 e nenhum fonema crítico errado |
| Produto | Idêntico em todos os takes |
| Realismo | Zero deformação perceptível de mãos, dentes, olhos, pele ou objetos |
| Narração | Texto completo, natural e coerente com a persona |
| Texto visual | Zero alucinação, tremor ou idioma indevido |
| Claims | Evidência específica do SKU e da oferta |
| Técnica | Todos os checks do gate técnico em `PASS` |

Qualquer falha crítica determina `REJECTED`. Regerar ou remontar, executar novamente os gates afetados e somente então reconsiderar a aprovação.

## Entrega

Somente entregar um master promovido de `CANDIDATE` para `APPROVED`, acompanhado de relatório técnico, certificado perceptual e manifesto com SHA-256. Nunca entregar arquivo chamado `FINAL` que não tenha passado pelo protocolo completo.
