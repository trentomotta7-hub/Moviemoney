# QA Técnico — Sunscreen Stick Marina GC v6 FINAL

**Arquivo:** `sunscreen_stick_marina_GC_v6_FINAL.mp4`  
**Duração:** 40,500 s  
**Formato:** 720 × 1280, H.264 + AAC, vertical 9:16  
**Método:** sete takes curtos, cada um gerado com fala nativa em português brasileiro e áudio embutido; concatenação das streams completas; aceleração de áudio e vídeo em conjunto a 1,20×.

## Resultado objetivo

| Critério | Resultado | Status |
|---|---:|---|
| Integridade de decodificação | Arquivo decodificado integralmente sem erro | **APROVADO** |
| Drift entre streams | 0,007 s | **APROVADO** (`< 0,1 s`) |
| Resolução e orientação | 720 × 1280, 9:16 | **APROVADO** |
| Codecs | H.264 + AAC | **APROVADO** |
| Cauda morta | Nenhum silêncio final detectado | **APROVADO** |
| Fidelidade do roteiro | Transcrição integral correspondente às 13 frases previstas | **APROVADO** |
| Overlay de oferta | Configurado a partir de 33 s | **IMPLEMENTADO** |
| Watermark | `MOVIE MONEY` em todo o master | **IMPLEMENTADO** |

## Transcrição consolidada

> Gente, eu precisava te mostrar esse protetor que mudou minha rotina de skincare. Antes eu usava protetor líquido e simplesmente não reaplicava, porque suja a mão, estraga a maquiagem, é uma bagunça. E aí minha pele começou a manchar. Aí eu descobri esse bastão SPF cinquenta. Olha como é fácil. Abre aqui, passa direto no rosto e fecha. Mão completamente limpa, não estraga maquiagem nenhuma. Eu reaplico no carro, no trabalho, em qualquer lugar. Quinze segundos e tô protegida de verdade. Tá menos de trinta e cinco reais e dura uns dois meses. Eu recomendo de verdade pra quem usa maquiagem e não consegue reaplicar protetor. Toca no carrinho laranja ali embaixo. Já esgotou duas vezes esse mês, então corre.

## Correção aplicada em relação ao v5

O v5 havia sido reprovado com lip sync 1/10. O v6 elimina a causa estrutural registrada: nenhuma voz externa foi sobreposta ao rosto. Cada take contém a própria fala nativa gerada junto com o movimento facial; qualquer ajuste temporal posterior foi aplicado simultaneamente às streams de vídeo e áudio, preservando a relação temporal original.

## Observação de validação

A validação desta sessão foi limitada a integridade, metadados, drift, silêncio e fidelidade do áudio. A inspeção subjetiva de artefatos visuais de vídeo generativo não foi usada como critério automático. O master permanece disponível para revisão humana antes da publicação em mídia paga.
