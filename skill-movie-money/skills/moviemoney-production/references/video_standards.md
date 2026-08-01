# Padrões de Produção Movie Money — "Modo 50/50"

Este documento define o rigor técnico para os vídeos da marca, focando no equilíbrio entre autoridade (Talking Head) e demonstração técnica (Screen Recording).

## 1. O Equilíbrio 50/50 (Regra de Ouro)
O vídeo deve alternar constantemente entre o porta-voz e a prova real na tela.
- **Talking Head (TH):** Usado para Hooks, viradas de assunto, CTAs e conclusões lógicas.
- **Screen Recording (SC):** Usado para demonstração de código, terminal, dashboards e prova social.
- **Ritmo:** Nunca exceder 7 segundos na mesma imagem sem um corte ou movimento (Ken Burns).

## 2. Transições e Dinamismo
- **Crossfade Visual:** Aplicar `xfade` de 0.3s (7 frames a 24fps) entre todos os takes de Talking Head. Isso elimina o jump cut e dá a sensação de um take contínuo.
- **Ken Burns (Zoom Dinâmico):** Todos os SCs devem ter um zoom suave de 1.0 para 1.08. 
    - *Comando:* `scale=4000:-1,zoompan=z='min(zoom+0.0005,1.08)':d=125:x='iw/2-(iw/zoom/2)':y='ih/2-(ih/zoom/2)':s=1280x720`

## 3. Safe Zone e Legendas
- **Estilo:** Amarelo e Branco, estilo Karaokê (highlight por palavra).
- **Posicionamento:** As legendas devem estar a exatamente **320px** da borda inferior.
- **Motivo:** Evitar obstrução pelos elementos da interface do TikTok Shop (carrinho laranja e descrição).

## 4. Áudio e Voz
- **Voz:** Fenrir (pt-BR).
- **Tratamento:** Normalização para 48kHz Stereo.
- **Lip Sync:** O prompt de geração do vídeo deve conter a fala exata entre aspas para garantir sincronia labial perfeita.

## 5. Estrutura de Montagem (Pipeline)
1. Gerar Takes TH com fala embutida.
2. Gerar SCs silenciosos.
3. Gerar VOs (Fenrir) para os SCs.
4. Normalizar todos os áudios e vídeos.
5. Concatenar com xfade nos pontos de TH e cortes secos nos SCs.
6. Upscale final para 2560x1440 (2K).
