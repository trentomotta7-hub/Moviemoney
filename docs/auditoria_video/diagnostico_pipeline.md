# Diagnóstico do Pipeline Audiovisual Movie Money

**Data da auditoria:** 07/08/2026
**Escopo:** mineração, planejamento, roteiro, geração, áudio, montagem, controle de qualidade e entrega.

## Conclusão executiva

O projeto possui uma base operacional relevante — pesquisa de tendências, banco narrativo, elenco, produto âncora, formatos GC/POV, normalização técnica e protocolo forense documentado — mas o processo real ainda não garante qualidade de entrega. A principal falha é a separação entre **regra escrita** e **execução automatizada**: os scripts produzem arquivos chamados `FINAL` antes de executar inspeção perceptual, consistência de produto, lip sync frase a frase e revisão de claims.

Os três masters representativos auditados foram reprovados sob um padrão conservador de publicação. O GC v6 é tecnicamente íntegro, mas falha em realismo, sincronização labial perceptual e estabilidade do produto. O POV v2 apresenta inconsistência objetiva do produto entre takes e narração incompleta. O institucional Vídeo 1 contém drift severo e congelamento prolongado, incompatíveis com entrega profissional.

## Auditoria dos masters representativos

| Master | Integridade técnica | Percepção audiovisual | Veredito atual |
|---|---|---|---|
| GC Sunscreen Stick v6 | 720×1280, 30 fps, drift de 0,007 s, loudness de -16,0 LUFS, sem cauda terminal detectada | Lip sync genérico, pele e gestos artificiais, mão deformada, rótulo instável e claims sem evidência | **REPROVADO** |
| POV Sunscreen Stick v2 | 720×1280, 30 fps, streams alinhadas, loudness de -16,7 LUFS | Produto muda de marca, formato e rótulo; mãos/creme artificiais; texto em inglês; locução termina em “Meninas” sem CTA completo | **REPROVADO** |
| Vídeo 1 institucional | 2560×1440, 30 fps | Áudio termina 7,453 s antes do vídeo; freeze técnico de 12,53 s entre 68,73–81,27 s; lip sync e realismo abaixo do padrão | **REPROVADO** |

## Diagnóstico por etapa

| Etapa | O que funciona | Falha observada | Risco | Correção necessária |
|---|---|---|---|---|
| Mineração | Pesquisa recente identifica ângulos e fontes | Não existe ficha obrigatória com URL da oferta, SKU, preço, vendedor, data, imagens oficiais, claims permitidos e evidências | Produto errado, preço desatualizado e promessas não comprovadas | Criar dossiê de mineração com evidências e data de validade |
| Produto âncora | Regra formal exige `produto_referencia.png` em toda geração | O POV aprovado anteriormente contém múltiplos produtos; a checagem não bloqueou a entrega | Strike, propaganda enganosa e perda de confiança | Comparação obrigatória take a take antes da montagem |
| Roteiro | Estrutura Hook → Problema → Causa → Solução → CTA é clara | Claims absolutos e escassez não comprovada entram no texto | Bloqueio de anúncio e risco reputacional | Gate de compliance antes de gerar áudio/vídeo |
| Plano de takes | Separação por frases e formatos está documentada | Não há storyboard com produto, ação, fala, referência e critério de aceitação por take | Geração sem controle e retrabalho tardio | Manifesto de takes obrigatório |
| Geração GC | Áudio nativo preserva o alinhamento temporal estrutural | Áudio nativo não garante articulação fonética perfeita nem realismo humano | Uncanny valley e depoimento pouco convincente | Aprovar cada take antes da montagem; lip sync mínimo 9/10 |
| Geração POV | TTS externo é tecnicamente aceitável sem rosto | Mãos, física e produto variam; referências não são aplicadas ou verificadas de forma confiável | Produto inconsistente e aparência de golpe | Produto âncora em todos os takes + análise de anatomia e física |
| Narração | Transcrição e loudness são verificáveis | GC tem prosódia artificial; POV v2 termina de forma truncada; ausência de respiração e interpretação natural | Baixa credibilidade e CTA perdido | QA de voz separado: dicção, emoção, pausa, timbre e completude |
| Montagem | Resolução, fps, codecs e loudnorm estão padronizados | Scripts geram `FINAL` e apenas exibem `ffprobe`; não executam gates forenses | Arquivo ruim recebe status final | Gerar `CANDIDATO`, executar QA e só depois promover para `APPROVED` |
| QA técnico | Drift, silêncio e formato estão documentados | Nem todos os scripts executam os testes; o institucional prova que erros críticos passaram | Congelamento, drift e cauda silenciosa | Script único obrigatório com código de saída não zero ao reprovar |
| QA perceptual | Há orientação para análise multimodal | Relatórios anteriores aceitaram explicitamente produto diferente e classificaram como 9,8/10; GC v6 limitou QA a metadados e transcrição | Falso positivo de qualidade | Dupla revisão: auditoria multimodal + inspeção dirigida de quadros/clipes |
| Entrega | Masters e relatórios podem ser preservados externamente | Não existe certificado de aprovação ligado por checksum ao arquivo entregue | Troca acidental de versão e ausência de rastreabilidade | Manifesto de entrega com SHA-256, relatório e veredito |

## Causa raiz das aprovações incorretas

A causa raiz não é apenas a tecnologia de geração. O problema central é que o pipeline trata **integridade técnica** como se fosse **qualidade perceptual**. Drift baixo, resolução correta e áudio em -16 LUFS não comprovam lip sync, naturalidade, anatomia, consistência do produto ou credibilidade comercial.

O relatório anterior do POV v2 reconheceu que o produto inicial era diferente do produto final e, ainda assim, atribuiu nota 9,8/10. O relatório do GC v6 declarou explicitamente que a validação não incluiu artefatos visuais subjetivos. Portanto, os dois documentos não poderiam autorizar publicação sob as regras atuais do próprio projeto.

## Regras de aprovação recomendadas

| Critério crítico | Limite de aprovação | Consequência |
|---|---|---|
| Produto | Identidade visual 100% consistente em todos os takes | Qualquer divergência reprova |
| Lip sync GC/TH | Nota perceptual mínima 9/10, sem fonema crítico visivelmente errado | Qualquer take abaixo do limite é regerado |
| Realismo humano | Mínimo 9/10; sem mãos, dentes, olhos ou pele evidentemente artificiais | Reprova o take |
| Narração | Texto completo, dicção clara, prosódia natural, emoção coerente e sem corte | Regravar ou regerar áudio/take |
| Drift A/V | Menor que 0,05 s para master final | Re-encode/remontagem |
| Cauda final | Menor que 0,20 s sem intenção narrativa | Cortar/remontar |
| Freeze não intencional | Zero segmento acima de 0,50 s | Reprovar |
| Claims | Cada promessa, preço e escassez possui evidência registrada | Remover ou comprovar |
| Texto visual | Zero texto alucinado ou idioma incorreto | Regerar/cobrir |
| Formato | Resolução, fps, codec e safe zone conforme o canal | Re-encode |

## Novo princípio operacional

> Nenhum arquivo deve receber `FINAL` durante a montagem. O pipeline deve produzir um `CANDIDATO`, executar gates técnicos, perceptuais e de compliance, gerar um relatório vinculado por checksum e somente então promover o arquivo para `APPROVED` e disponibilizá-lo para entrega.

## Evidências locais

- `docs/auditoria_video/tecnico/gc_v6_resumo.txt`
- `docs/auditoria_video/tecnico/pov_v2_resumo.txt`
- `docs/auditoria_video/tecnico/institucional_v1_resumo.txt`
- `docs/auditoria_video/relatorios/gc_v6_analise_perceptual.txt`
- `docs/auditoria_video/relatorios/pov_v2_analise_perceptual.txt`
- `docs/auditoria_video/relatorios/institucional_v1_analise_perceptual.txt`
- `docs/auditoria_video/achados_visuais_quadros.md`
- `docs/auditoria_video/gc_contact_sheet.jpg`
- `docs/auditoria_video/pov_contact_sheet.jpg`
- `docs/auditoria_video/institucional_contact_sheet.jpg`
