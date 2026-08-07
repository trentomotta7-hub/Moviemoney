# Validação prática do novo protocolo

O gate técnico foi executado nos três masters representativos e retornou códigos de saída coerentes com as evidências.

| Master | Gate técnico | Gate perceptual | Resultado de entrega |
|---|---|---|---|
| GC Sunscreen Stick v6 | `TECHNICALLY_APPROVED` | `REJECTED` | **BLOQUEADO** |
| POV Sunscreen Stick v2 | `TECHNICALLY_REJECTED` | `REJECTED` | **BLOQUEADO** |
| Vídeo 1 institucional | `TECHNICALLY_REJECTED` | `REJECTED` | **BLOQUEADO** |

O GC comprova a separação necessária entre integridade técnica e qualidade perceptual: ele possui formato, drift, loudness e cauda corretos, mas não pode ser entregue por falhas de lip sync, realismo, produto, voz e claims.

O POV comprova o bloqueio combinado: além de usar sample rate fora do padrão, apresenta múltiplos produtos, mãos e física artificiais, texto em inglês, rótulos instáveis e narração sem CTA completo.

O institucional comprova que o gate detecta erros de timeline antes invisíveis no processo anterior: drift e cauda de 7,453 segundos, freeze de 12,533 segundos, loudness fora do alvo e true peak acima do limite.

A validação confirma o comportamento desejado: nenhum master é promovido por média, nome de arquivo ou relatório anterior. A entrega só ocorre quando o gate técnico e o certificado perceptual estão simultaneamente aprovados.
