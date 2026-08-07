# Protocolo forense audiovisual obrigatório

> Nenhum vídeo pode ser entregue, publicado ou chamado de final sem aprovação técnica e perceptual vinculada ao checksum do master.

## Princípio de decisão

O protocolo usa **falhas bloqueadoras**, não média compensatória. Ritmo, hook ou edição não compensam lip sync fora, produto diferente, mãos deformadas, narração truncada, claims sem prova, drift ou congelamento.

| Classe | Critérios | Regra |
|---|---|---|
| Técnico | Integridade, formato, drift, início, sample rate, loudness, true peak, cauda, freeze e black frames | Todos devem passar |
| Perceptual | Realismo, lip sync, produto, mãos, olhos, dentes, texto, física, voz, continuidade e acabamento | Todos os críticos devem passar |
| Compliance | SKU, preço, claims, escassez, eficácia e interface da plataforma | Toda afirmação deve ter evidência |
| Entrega | Checksum, relatórios, versão e URL | Devem corresponder ao mesmo arquivo |

## Gate 1 — Auditoria técnica executável

Executar o script oficial:

```bash
python3 skills/moviemoney-production/scripts/qa_gate.py VIDEO \
  --format short \
  --report qa/qa_tecnico.md \
  --json-report qa/qa_tecnico.json
```

Usar `--format youtube` em masters 16:9. O script retorna código `0` somente quando todos os critérios técnicos passam.

### Limites padrão

| Critério | Limite |
|---|---:|
| Drift entre durações de áudio/vídeo | ≤ 0,05 s |
| Diferença de `start_time` | ≤ 0,02 s |
| Cauda silenciosa | ≤ 0,20 s |
| Loudness integrado | -16,0 ± 1,0 LUFS |
| True peak | ≤ -1,0 dBTP |
| Sample rate | 48 kHz |
| Freeze não documentado | ≤ 0,50 s |
| Black frame não documentado | ≤ 0,20 s |
| Shorts | ≥ 720×1280, 9:16 |
| YouTube | ≥ 1280×720, 16:9 |

Uma tela estática planejada ainda deve possuir movimento perceptível de cursor, zoom, destaque ou composição. Se o detector apontar freeze intencional, documentar a exceção e revisar o trecho integralmente; não aprovar automaticamente.

## Gate 2 — Transcrição e narração

Executar transcrição independente e comparar com o roteiro aprovado. Reprovar qualquer palavra ausente, CTA cortado, frase incompleta, idioma indevido ou erro que altere a oferta.

Avaliar separadamente:

| Dimensão | Aprovação |
|---|---|
| Dicção | Todas as palavras inteligíveis |
| Prosódia | Ênfases e pausas coerentes com a intenção |
| Emoção | Tom correspondente à persona e à cena |
| Ritmo | Natural, sem velocidade mecanicamente constante |
| Respiração | Sem ausência artificial evidente ou cortes abruptos |
| Timbre | Consistente entre takes do mesmo personagem |
| Completude | Roteiro e CTA integralmente presentes |

Áudio tecnicamente limpo não equivale a voz humana convincente.

## Gate 3 — Lip sync GC e Talking Head

Avaliar frase por frase e take por take. Observar fechamento labial em `/p/`, `/b/`, `/m/`, contato dentes-lábio em `/f/` e `/v/`, ataques de palavra, pausas e término da articulação.

| Status | Definição |
|---|---|
| PASS | ≥ 9/10, sem fonema crítico visivelmente errado e sem atraso perceptível |
| FAIL | Movimento genérico, boca aberta em fonema fechado, início/fim fora, atraso ou continuação após pausa |

Áudio nativo com `generate_audio=True` reduz o risco estrutural, mas **não garante aprovação**. Cada take precisa ser inspecionado. Regerar o take reprovado; não acelerar, cortar ou mascarar a falha como primeira opção.

## Gate 4 — Realismo humano e física

Reprovar qualquer ocorrência perceptível em reprodução normal:

- dedos extras, fundidos, longos ou sem articulação;
- dentes, língua, olhos ou piscadas deformados;
- pele plastificada, expressão ocular extrema ou microexpressão ausente;
- cabelo com flicker, contorno instável ou morphing;
- objeto flutuando, sem peso, atrito, aderência ou oclusão;
- ação de aplicação sem contato físico plausível;
- personagem, roupa ou cenário mudando entre takes.

Usar reprodução integral e inspeção dirigida nos timestamps suspeitos. Gerar folha de contato ou clipes curtos para registrar a evidência.

## Gate 5 — Produto âncora e texto visual

Comparar todos os takes com as imagens oficiais da mineração. A silhueta, tampa, base, cor, rótulo, proporções, textos e variante devem permanecer idênticos.

Reprovar se ocorrer:

- troca de marca, embalagem ou formato;
- texto ilegível, alucinado, em idioma incorreto ou com ortografia inventada;
- rótulo tremendo, mudando de espessura ou sofrendo warping;
- produto genérico em um take e produto oficial em outro;
- preço, SPF ou especificação visual incompatível com o SKU.

A referência enviada ao modelo não é evidência de consistência. Somente o resultado renderizado é avaliado.

## Gate 6 — Auditoria multimodal

Executar análise com timestamps como uma evidência adicional:

```bash
manus-analyze-video VIDEO "Audite com rigor: realismo, lip sync por fonemas, voz, produto, mãos, olhos, dentes, física, continuidade, texto, hook, CTA, overlays, claims e artefatos. Liste defeitos com timestamps e use REPROVADO quando qualquer critério crítico falhar."
```

Não usar essa análise como única fonte, pois amostragem de frames pode perder falhas de movimento ou confundir timestamps. Cruzar o resultado com ffmpeg, transcrição e revisão dirigida.

## Gate 7 — Compliance

Comparar roteiro, overlays e locução com o dossiê de mineração. Preço, estoque, escassez, duração, eficácia, proteção, antes/depois e comparações precisam de evidência registrada e atual.

Reprovar frases absolutas ou não demonstráveis, como “não estraga maquiagem nenhuma”, “proteção de verdade”, “dura dois meses” ou “esgotou duas vezes”, quando não houver comprovação específica do SKU e da oferta.

## Certificado perceptual

Preencher `templates/qa/certificado_perceptual.md`. Marcar `APPROVED` somente quando todos os critérios críticos estiverem em `PASS`. O relatório deve apontar timestamps, correções e responsável pela revisão.

## Promoção para entrega

1. Produzir `{slug}_CANDIDATE_vN.mp4`.
2. Executar o gate técnico.
3. Executar transcrição, revisão temporal, produto e compliance.
4. Preencher o certificado perceptual.
5. Se houver qualquer `FAIL`, corrigir e reiniciar os gates afetados.
6. Somente com dois vereditos positivos — `TECHNICALLY_APPROVED` e `APPROVED` — promover para `{slug}_APPROVED_vN.mp4`.
7. Calcular SHA-256 e preencher `templates/qa/manifesto_entrega.md`.
8. Entregar o arquivo e os relatórios correspondentes ao mesmo checksum.

## Proibição de falso final

Não usar `FINAL`, `PERFEITO`, `PRONTO` ou `APROVADO` no nome ou na documentação antes da conclusão deste protocolo. Um relatório que exclui artefatos visuais, produto ou lip sync não autoriza publicação.
