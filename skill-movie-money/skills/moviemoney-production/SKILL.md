---
name: moviemoney-production
description: Produção e auditoria ponta a ponta de vídeos Movie Money, da mineração à entrega. Use para criar GC, POV e vídeos institucionais; selecionar produto; escrever roteiro; gerar takes; montar masters; avaliar realismo, lip sync, narração, produto e compliance; ou entregar qualquer vídeo do projeto.
---

# Movie Money Video Production

Executar o pipeline completo. Nenhum vídeo pode ser entregue ou chamado de final sem gate técnico e certificado perceptual aprovados.

## Fluxo obrigatório

| Fase | Saída | Gate |
|---:|---|---|
| 0 | Dossiê de mineração | Produto, oferta e claims comprovados |
| 1 | Produto âncora | Referências oficiais legíveis |
| 2 | Estratégia GC + POV | Hipóteses e dores definidas |
| 3 | Roteiro aprovado | Texto natural e conforme |
| 4 | Manifesto de takes | Fala, ação, referência e aceitação por take |
| 5 | Takes candidatos | QA individual antes da montagem |
| 6 | Master `CANDIDATE` | Montagem concluída, ainda não entregável |
| 7 | Gate técnico | `TECHNICALLY_APPROVED` |
| 8 | Certificado perceptual | `APPROVED` |
| 9 | Manifesto de entrega | Checksum e evidências vinculados |
| 10 | Checkpoint seguro | Continuidade registrada |

Ler `references/pipeline_ponta_a_ponta.md` antes de iniciar uma produção. Ler `references/protocolo_forense_audiovisual.md` antes de montar, auditar ou entregar.

## Regra perpétua de entrega

> Não usar `FINAL`, `PERFEITO`, `PRONTO` ou `APROVADO` antes de concluir todos os gates. Gerar primeiro um arquivo `CANDIDATE`; promover para `APPROVED` somente depois da aprovação técnica e perceptual.

Uma única falha crítica reprova. Não usar média compensatória. Ritmo, hook ou edição não compensam produto diferente, lip sync fora, mão deformada, voz truncada, claim sem prova, drift ou congelamento.

## Mineração e produto âncora

Preencher `templates/qa/mineracao_produto.md`. Registrar URL, vendedor, SKU, preço, data, região, imagens oficiais, especificações, sinais de demanda e evidências de cada claim.

Salvar as imagens oficiais em `criativos/{produto}/produto_ancora/`. Passar o produto âncora como referência em toda geração onde ele apareça e comparar o resultado renderizado contra a referência. Reprovar qualquer mudança de embalagem, tampa, cor, rótulo, escala ou texto.

## Dois criativos por produto

Produzir ao menos um GC e um POV para o mesmo SKU. Usar dores e hipóteses diferentes, preservando produto, oferta e evidências. Nomear:

- `{produto}_{persona}_GC_CANDIDATE_v{n}.mp4`
- `{produto}_{persona}_POV_CANDIDATE_v{n}.mp4`

## Roteiro e plano de takes

Usar Hook → Problema → Causa → Solução → CTA. Escrever no tom da persona, ler em voz alta e eliminar frases artificiais. Remover claims sem evidência.

Preencher `templates/qa/manifesto_takes.csv`. Dividir a fala em takes curtos, preferencialmente uma frase por take. Vincular fala exata, atuação, ação visual, personagem, produto âncora e critério de aceitação.

## Geração GC e Talking Head

1. Usar `generate_audio=True`.
2. Incluir a fala exata e a direção de atuação no prompt.
3. Manter áudio e vídeo nativos juntos.
4. Aprovar cada take isoladamente para lip sync, voz, boca, dentes, olhos, mãos, pele, personagem, produto e cenário.
5. Regerar qualquer take abaixo do padrão; não mascarar falhas graves com cortes rápidos.

Áudio nativo preserva a relação temporal estrutural, mas não garante lip sync perceptual. Exigir no mínimo 9/10, sem fonema crítico visivelmente errado.

## Geração POV

Usar TTS externo somente quando não houver boca. Exigir produto âncora, anatomia de mãos, física de contato, rótulo estável e ação simples. Reprovar dedos deformados, creme com morphing, objeto flutuante, produto genérico, texto inventado ou idioma incorreto.

## Montagem do candidato

Preservar áudio nativo em GC/TH. Normalizar para 48 kHz e -16 LUFS. Usar 720×1280/30 fps para TikTok e pelo menos 1280×720 para YouTube. Manter legendas e elementos críticos na Safe Zone, a aproximadamente 320 px da base em 720×1280.

A montagem produz `CANDIDATE`, nunca aprovação.

## Gate técnico executável

Executar:

```bash
python3 skills/moviemoney-production/scripts/qa_gate.py VIDEO \
  --format short \
  --report qa/qa_tecnico.md \
  --json-report qa/qa_tecnico.json
```

Usar `--format youtube` para 16:9. Código de saída não zero bloqueia o pipeline.

## Certificado perceptual

Preencher `templates/qa/certificado_perceptual.md`. Combinar:

1. reprodução integral com áudio;
2. auditoria multimodal com timestamps;
3. inspeção dirigida de quadros ou clipes críticos;
4. transcrição independente;
5. comparação com produto âncora;
6. revisão de claims contra o dossiê.

Reprovar qualquer falha crítica de lip sync, realismo, mãos, dentes, olhos, produto, texto, física, narração, continuidade, CTA, Safe Zone ou compliance.

## Promoção e entrega

Promover para `{slug}_APPROVED_vN.mp4` somente quando o gate técnico indicar `TECHNICALLY_APPROVED` e o certificado perceptual indicar `APPROVED`. Calcular SHA-256 e preencher `templates/qa/manifesto_entrega.md`.

Entregar o master, o relatório técnico, o certificado perceptual e as evidências vinculadas ao mesmo checksum. Atualizar o checkpoint e sincronizar apenas documentos, scripts e manifests autorizados; manter masters pesados em armazenamento externo.

## Recursos

| Recurso | Uso |
|---|---|
| `references/pipeline_ponta_a_ponta.md` | Fluxo da mineração à entrega |
| `references/protocolo_forense_audiovisual.md` | Critérios técnicos, perceptuais e de compliance |
| `references/video_standards.md` | Parâmetros de vídeo e edição |
| `scripts/qa_gate.py` | Gate técnico com código de saída |
| `scripts/criar_projeto_produto.sh` | Estrutura inicial por produto |
| `templates/qa/mineracao_produto.md` | Dossiê de mineração |
| `templates/qa/manifesto_takes.csv` | Plano de takes |
| `templates/qa/certificado_perceptual.md` | Aprovação perceptual |
| `templates/qa/manifesto_entrega.md` | Rastreabilidade da entrega |
