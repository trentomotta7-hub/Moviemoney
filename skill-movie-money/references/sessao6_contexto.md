# Contexto da Sessão 6 — Movie Money (01/08/2026)

## Estado ao Iniciar a Sessão 6
- Repositório clonado de: trentomotta7-hub/Moviemoney
- Checkpoint lido: references/checkpoint.md (Sessão 5, 31/07/2026)
- Voz do Beto: **Fenrir** (masc., excitável) — pt-BR
- Estilo: "You are a sharp, warm Brazilian entrepreneur speaking directly to a potential client like a trusted friend, not a salesperson..."

## Vídeo 1 YouTube (Quebra-Mitos) — Status Sessão 6

### Takes de Talking Head (TH) — TODOS GERADOS
| Arquivo | Seção | Status |
|---------|-------|--------|
| takes/t1_hook.mp4 | Hook — fala principal | ✅ Existia |
| takes/t1b_voiceover_sonho.mp4 | Hook — sonho dos gurus | ✅ Gerado S6 |
| takes/t1c_mentira_retencao.mp4 | Hook — mentira/retenção | ✅ Gerado S6 |
| takes/t2_mentira.mp4 | Dor Real — anúncio barato | ✅ Existia |
| takes/t3_dor.mp4 | Dor Real — UGC caro | ✅ Existia |
| takes/t3b_dono_negocio.mp4 | Dor Real — dono de negócio | ✅ Gerado S6 |
| takes/t4_ilusao.mp4 | Máquina — ótica/percepção | ✅ Existia |
| takes/t4b_banco_narrativo.mp4 | Máquina — banco narrativo | ✅ Gerado S6 |
| takes/t5_cta.mp4 | Resultado — lip sync/safe zone | ✅ Existia |
| takes/t5b_municao.mp4 | Resultado — munição/gatilho | ✅ Gerado S6 |
| takes/t_cta_a.mp4 | CTA — próximo vídeo | ✅ Gerado S6 |
| takes/t_cta_b.mp4 | CTA — bora vender | ✅ Gerado S6 |

### Screen Recordings / B-Rolls — TODOS GERADOS
| Arquivo | Descrição | Status |
|---------|-----------|--------|
| takes/sc1_youtube_gurus.png | YouTube com thumbnails de gurus | ✅ Gerado S6 |
| takes/sc2_pasta_videos_chines.png | Pasta com vídeos genéricos | ✅ Gerado S6 |
| takes/sc3_whatsapp_cliente.png | WhatsApp — cliente pedindo vídeo | ✅ Gerado S6 |
| takes/sc4_repositorio_terminal.png | VS Code + terminal gerando | ✅ Gerado S6 |
| takes/sc5_ffmpeg_gerando.png | Terminal ffmpeg com progresso | ✅ Gerado S6 |
| takes/sc7_whatsapp_resposta.png | WhatsApp — cliente responde fogo | ✅ Gerado S6 |
| takes/sc8_logo_final.png | Logo MM glitch em fundo dark | ✅ Gerado S6 |

### Voice Overs para Screen Recordings — A GERAR
Os trechos de voice over do roteiro que ficam sobre as telas precisam de áudio TTS (Fenrir):

| ID | Sobre qual SC | Fala exata |
|----|--------------|------------|
| vo_sc1 | sc1_youtube_gurus | "Eles te vendem o sonho perfeito. Falam que é só pegar um vídeo chinês, jogar no CapCut, botar uma voz de robô e pronto. Você tá rico." |
| vo_sc2 | sc2_pasta_videos | "Eu sei exatamente o que você tá passando. Você minera um produto vencedor. Aí você sobe a campanha com isso aqui. Você acha mesmo que alguém vai parar de rolar o feed pra comprar de um vídeo que grita 'eu sou um anúncio barato'?" |
| vo_sc3 | sc3_whatsapp_cliente | "Venda na internet é uma questão de ótica. É percepção. Se o seu vídeo parece amador, o seu produto parece barato. E é por isso que a gente parou de editar vídeo na mão. A gente construiu uma máquina." |
| vo_sc4 | sc4_repositorio | "Minerar o produto é só dez por cento do trabalho. Noventa por cento é o criativo. A gente não inventa roteiro da nossa cabeça. A gente puxa da nossa base validada. E aí a mágica acontece." |
| vo_sc7 | sc7_whatsapp_resposta | "A gente entrega a munição. Você só aperta o gatilho." |

### Montagem Parcial
- Script: scripts/montar_video1_youtube.sh ✅ Criado S6
- Vídeo parcial (sem VOs): criativos/video_institucional_youtube/video1_quebra_mitos_FINAL.mp4
  - Duração: 2min 29s (curto — falta os VOs)
  - Resolução: 2560x1440 ✅
  - Marca d'água: ✅ injetada

## Próximos Passos Imediatos (Sessão 6 continuação)
1. Gerar os 5 voice overs (TTS Fenrir) listados acima
2. Combinar cada VO com seu SC correspondente (ffmpeg -i sc.mp4 -i vo.wav)
3. Remontar o vídeo completo na ordem correta com todos os segmentos + VOs
4. Verificar duração final (alvo: 8-10 min)
5. Commit no GitHub

## Roteiro do Vídeo 2 — ESCRITO S6
- Arquivo: criativos/video_institucional_youtube/video2_maquina_por_dentro_roteiro_v1.md
- Status: ✅ Roteiro completo escrito, produção pendente

## Roteiro do Vídeo 3 (VSL) — EXISTIA DESDE S5
- Arquivo: criativos/video_institucional_youtube/roteiro_v1.md
- Status: ✅ Roteiro pronto, produção pendente
