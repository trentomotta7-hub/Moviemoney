# Matriz A/B POV Sunscreen Stick

Este diretório contém a infraestrutura para gerar as 20 variações de teste A/B para o criativo POV do Sunscreen Stick.

## Composição
- **Corpo fixo:** Beats 2 (Problema), 3 (Causa) e 4 (Solução).
- **Hooks variáveis (5):** A, B, C, D, E.
- **CTAs variáveis (4):** A, B, C, D.
- **Total:** 20 variações únicas.

## Status Atual
A infraestrutura de listas de concatenação foi gerada com sucesso via script `gerar_matriz.sh`. 
A produção real dos assets visuais e de áudio de cada variação exige o acionamento do gerador visual e de TTS para os takes modulares, seguida da concatenação FFmpeg. Como o master v2 foi restaurado com sucesso, o pipeline de escala A/B está formalmente pronto para execução assim que os inputs de mídia das variações forem gerados na próxima fase de produção ativa.
