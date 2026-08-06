# Diagnóstico de Continuidade — Sessão 17

**Data de reconciliação:** 05/08/2026  
**Repositório:** `trentomotta7-hub/Moviemoney`  
**Branch de continuidade:** `main`

## Resumo executivo

A leitura combinada dos checkpoints, da memória operacional, do histórico Git e dos artefatos reais revelou que o repositório avançou além do checkpoint formal da Sessão 16, porém dois itens foram indevidamente tratados como concluídos. O master POV v2, embora citado e auditado, **não está versionado**; somente os intermediários e o relatório de análise permanecem no repositório. O GC v5, embora presente como vídeo final, foi **reprovado para publicação** pela própria auditoria forense por falha total de lip sync.

A continuidade correta exige restaurar primeiro a integridade dos masters, produzir a matriz A/B, corrigir o GC segundo o protocolo forense consolidado, expandir e produzir a VSL de oferta e, em seguida, migrar a landing para uma aplicação full-stack com persistência de leads, confirmação por e-mail e countdown individual de 72 horas.

## Estado reconciliado

| Frente | Estado declarado anteriormente | Estado real verificado | Decisão de continuidade |
|---|---|---|---|
| POV Sunscreen v2 | Finalizado e aprovado com nota 9,8/10 | O arquivo `sunscreen_stick_spf_pov_v2_FINAL.mp4` não existe no Git; há intermediários, script antigo e análise | Reconstruir o master v2 aprovado antes de derivar variações |
| Matriz A/B 5 × 4 | Próxima tarefa | Nenhuma das 20 variações foi produzida | Gerar 5 hooks, 4 CTAs e 20 exports rastreáveis |
| GC Sunscreen v5 | Commitado como correção definitiva | Vídeo existe em 720×1280, 33,099 s, mas a auditoria atribuiu lip sync 1/10 e veredito REPROVADO | Reabrir como pendência crítica e regerar com áudio nativo sincronizado |
| Vídeo 3 — “A Oferta” | Não iniciado; roteiro citado como pronto | `roteiro_v1.md` existe, mas estima 6–8 min e não atende ao alvo posterior de 8–12 min; não há master final | Revisar/expandir roteiro e produzir VSL com Beto |
| Landing Movie Money | Publicada em `moviemoney-dwepojx6.manus.space` | Código-fonte não está no repositório atual; a própria memória registra perda de persistência entre sessões | Recriar/migrar em projeto full-stack, preservando estrutura e identidade documentadas |
| Captura de leads | Planejada | Não há banco, endpoint ou fluxo persistente versionado | Implementar tabela, validação, consentimento e confirmação |
| Countdown 72 h | Planejado | Não implementado | Vincular expiração ao lead no servidor, evitando reset por recarga |

## Evidências técnicas determinantes

O commit da Sessão 16 adicionou os takes, áudios, intermediários e relatórios do POV, mas não adicionou qualquer arquivo com o padrão `*FINAL.mp4` nessa pasta. A análise do POV v2 descreve um vídeo de 32 segundos aprovado, portanto o master deve ser reconstruído a partir de `video_normalizado.mp4`, do CTA estendido e das regras de overlay registradas.

O arquivo `sunscreen_stick_marina_GC_v5_FINAL.mp4` possui vídeo H.264, áudio AAC, resolução 720×1280, 30 fps e duração de 33,099 segundos. Entretanto, `video_sunscreen_stick_marina_GC_v5_FINAL_analysis_20260805_193403.md` registra lip sync 1/10 e conclui **REPROVADO PARA PUBLICAÇÃO**. Pelo protocolo forense do projeto, GC com rosto falando deve usar o texto exato no gerador com áudio nativo habilitado; sobrepor TTS externo a um rosto gerado é proibido.

O roteiro da VSL já cobre hook, dor, solução, prova e CTA, porém foi estimado em 6–8 minutos. O checkpoint mais recente exige 8–12 minutos. A produção deverá preservar o posicionamento “Você gerencia a loja, nós criamos os vídeos”, acrescentar mecanismo, demonstração, objeções, oferta, ancoragem e fechamento sem alegações não comprovadas.

## Pesquisa de mercado incorporada

A amostra pública do TikTok Creative Center para Brasil e Estados Unidos, nos últimos 30 dias, exibiu atividade relevante em Cosmetics e Hair Styling. O painel ressalta que somente anúncios autorizados aparecem e que a seleção não representa todo o universo de anúncios. Assim, os dados foram usados apenas como sinal direcional, não como prova de performance do produto Sunscreen Stick. O registro detalhado está em `docs/sessoes/pesquisa_sessao17_trends_20260805.md`.

## Ordem operacional aprovada

| Prioridade | Entrega | Critério de saída |
|---:|---|---|
| 1 | Restaurar master POV v2 | Arquivo final presente, metadados válidos, sem cauda morta e com overlay correto |
| 2 | Produzir 20 variações A/B | Matriz completa H1–H5 × C1–C4, manifesto de versões e QA técnico |
| 3 | Corrigir GC v5 | Lip sync ≥ 7/10, produto consistente, drift < 0,1 s e veredito aprovado |
| 4 | Produzir VSL “A Oferta” | Roteiro 8–12 min, master final, assets e auditoria audiovisual |
| 5 | Migrar landing e backend | Lead persistido, confirmação disparada, estados de erro/sucesso testados |
| 6 | Ativar countdown individual | Expiração de 72 h persistida no servidor e retomada correta por lead |
| 7 | Consolidar e publicar | Checkpoint novo, histórico limpo e atualizações enviadas ao GitHub |

## Fontes internas de verdade

- `.project-memory/checkpoints/20260805-182200-sessao16-pov-sunscreen.md`
- `.project-memory/next-actions.md`
- `skill-movie-money/skills/moviemoney-production/SKILL.md`
- `skill-movie-money/skills/moviemoney-production/references/protocolo_forense_audiovisual.md`
- `skill-movie-money/criativos/sunscreen_stick_spf/POV/montagem/video_sunscreen_stick_spf_pov_v2_FINAL_analysis_20260805_182200.md`
- `skill-movie-money/criativos/sunscreen_stick_spf/GC/montagem/video_sunscreen_stick_marina_GC_v5_FINAL_analysis_20260805_193403.md`
- `skill-movie-money/criativos/video_institucional_youtube/roteiro_v1.md`

## Referências externas

[1]: https://ads.tiktok.com/business/creativecenter/inspiration/topads/pc/en "TikTok Creative Center — Top Ads"
[2]: https://www.tiktok.com/discover/sunscreen-sticks "TikTok Discover — Sunscreen Sticks"
