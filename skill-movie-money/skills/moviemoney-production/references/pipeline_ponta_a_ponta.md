# Pipeline ponta a ponta — Movie Money

Executar as fases em ordem. Nenhuma fase posterior pode compensar uma reprovação anterior.

## Visão geral

| Fase | Saída obrigatória | Gate para avançar |
|---:|---|---|
| 0 | Dossiê de mineração | Produto, oferta e claims comprovados |
| 1 | Produto âncora | Referências oficiais legíveis e consistentes |
| 2 | Estratégia GC + POV | Dores, personas e hipóteses distintas |
| 3 | Roteiro aprovado | Texto natural, demonstrável e sem claims sem evidência |
| 4 | Manifesto de takes | Cada take vinculado a fala, ação, referências e aceitação |
| 5 | Takes candidatos | Cada take aprovado isoladamente antes da montagem |
| 6 | Master `CANDIDATE` | Montagem tecnicamente concluída, ainda não entregável |
| 7 | Gate técnico | `TECHNICALLY_APPROVED` obrigatório |
| 8 | Certificado perceptual | `APPROVED` obrigatório, sem média compensatória |
| 9 | Manifesto de entrega | Checksum e evidências vinculados ao arquivo entregue |
| 10 | Checkpoint seguro | Contexto, relatório e código sincronizados sem segredos/masters indevidos |

## Fase 0 — Mineração

Criar o dossiê a partir de `templates/qa/mineracao_produto.md`. Registrar a URL exata da oferta, vendedor, SKU, variante, preço, data, região, imagens oficiais, especificações, sinais de demanda, saturação, logística e riscos. Salvar screenshots e fontes. Tratar dados de terceiros como sinais, nunca como garantia de performance.

Reprovar a mineração quando o produto não puder ser identificado visualmente com segurança, quando as imagens forem insuficientes, quando o rótulo for complexo demais para reprodução confiável ou quando os claims essenciais não possuírem evidência.

## Fase 1 — Produto âncora

Salvar imagens oficiais em `criativos/{produto}/produto_ancora/`. Manter ao menos frente, verso/rótulo e uso. Definir nome, formato, dimensões relativas, cor, tampa, rótulo e textos permitidos.

Usar a referência oficial em toda geração onde o produto apareça. A presença da referência no prompt não basta: comparar o resultado gerado contra o produto âncora antes de aceitar o take.

## Fase 2 — Estratégia de criativos

Produzir no mínimo um GC e um POV por produto. Usar dores e hipóteses distintas, mantendo o mesmo SKU. Definir o papel de cada versão, a audiência, a prova visual e a métrica que será testada. Quando criar matriz A/B, manter corpo, produto, áudio, correção de cor e duração constantes; variar apenas os fatores declarados.

## Fase 3 — Roteiro e compliance

Usar Hook → Problema → Causa → Solução → CTA. Escrever no tom da persona e ler em voz alta antes da geração. Eliminar frases que soem como anúncio artificial.

Registrar evidência para preço, escassez, estoque, duração, proteção, eficácia, comparação, antes/depois e qualquer promessa objetiva. Remover claims absolutos como “não estraga maquiagem nenhuma” se não houver comprovação aplicável ao SKU.

## Fase 4 — Manifesto de takes

Preencher `templates/qa/manifesto_takes.csv`. Cada linha deve conter fala exata, emoção, ação visual, referência do personagem, produto âncora, claims, duração e critério de aprovação.

Planejar takes curtos, preferencialmente uma frase por take. Evitar ações de alto risco generativo — mãos muito próximas da câmera, dedos abertos dominando o quadro, rótulo em movimento rápido, aplicação com contato complexo — salvo quando houver capacidade de revisar e regerar.

## Fase 5 — Geração e QA por take

### GC e Talking Head

Gerar áudio nativo junto com o vídeo. Incluir a fala exata e a direção de atuação no prompt. Não substituir a voz por TTS externo. Aprovar cada take isoladamente para lip sync, boca, dentes, olhos, mãos, pele, voz, personagem, produto e cenário. Regerar imediatamente o take reprovado; não tentar mascarar falhas graves com cortes rápidos.

### POV

Usar TTS externo somente porque não há boca. Exigir produto âncora, mãos anatômicas, física plausível e ação simples. Reprovar texto alucinado, produto diferente, dedos deformados, creme com morphing, objeto flutuante ou contato sem peso.

## Fase 6 — Montagem do candidato

Nomear a saída como `{produto}_{persona}_{tipo}_CANDIDATE_v{n}.mp4`. Preservar áudio nativo em GC/TH. Normalizar para 48 kHz e -16 LUFS. Usar 720×1280/30 fps para TikTok e pelo menos 1280×720 para YouTube. Manter overlays na Safe Zone e usar somente preço comprovado.

Nunca criar um arquivo `FINAL` antes dos gates. A montagem não autoriza entrega.

## Fase 7 — Gate técnico

Executar:

```bash
python3 skills/moviemoney-production/scripts/qa_gate.py VIDEO \
  --format short \
  --report CAMINHO/qa_tecnico.md \
  --json-report CAMINHO/qa_tecnico.json
```

Para YouTube, usar `--format youtube`. Código de saída diferente de zero bloqueia o pipeline. Corrigir e executar novamente; nunca ignorar uma falha sem justificativa documentada.

## Fase 8 — Certificado perceptual

Preencher `templates/qa/certificado_perceptual.md`. Combinar reprodução integral, auditoria multimodal com timestamps, transcrição independente e inspeção dirigida de quadros ou clipes críticos.

Lip sync, produto, realismo, narração, claims e texto visual são critérios críticos. Uma única falha reprova; notas altas de ritmo ou edição não compensam produto diferente, mão deformada ou boca fora de sincronia.

## Fase 9 — Promoção e entrega

Somente após `TECHNICALLY_APPROVED` e `APPROVED`, copiar ou renomear o arquivo para `{produto}_{persona}_{tipo}_APPROVED_v{n}.mp4`. Calcular SHA-256 e preencher `templates/qa/manifesto_entrega.md`.

Entregar apenas o arquivo cujo checksum aparece no manifesto. Anexar o relatório técnico, o certificado perceptual e, quando pertinente, as imagens-chave e o dossiê de mineração.

## Fase 10 — Continuidade

Atualizar o checkpoint do projeto e usar a skill `continuity-sync` em modo de prévia antes de escrever. Incluir somente documentos, scripts, manifests e arquivos pequenos explicitamente autorizados. Preservar masters pesados no armazenamento externo e registrar seus URLs e checksums.
