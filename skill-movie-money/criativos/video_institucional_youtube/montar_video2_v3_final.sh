#!/usr/bin/env bash
# ============================================================
# MONTAGEM FINAL v3 — Vídeo 2: "A Máquina por Dentro"
#
# ARQUITETURA DE ÁUDIO CORRETA:
#   A trilha de áudio é EXCLUSIVAMENTE a voz do Beto,
#   extraída dos takes em sequência contínua.
#   Ela toca sem interrupção sobre TODOS os segmentos visuais
#   (takes do Beto E screen recordings animados).
#   ZERO voz robótica. ZERO sobreposição.
#
# ARQUITETURA VISUAL:
#   - Takes TH: vídeo do Beto (vídeo original, sem áudio)
#   - Screen Recordings: vídeos animados (terminal/código em movimento)
#   - Todos os SCs têm movimento real — sem prints estáticos
# ============================================================

set -e

BASE="/home/ubuntu/Moviemoney/skill-movie-money/criativos/video_institucional_youtube"
TAKES="$BASE/takes_v2"
ANIM="$BASE/screens_v2_anim"
AUDIO_MASTER="$BASE/audio_master/beto_audio_master.wav"
LOGO="/home/ubuntu/Moviemoney/skill-movie-money/templates/identidade_visual/logo_transparente.png"
TEMP="$BASE/temp_v3"
OUTPUT="$BASE"

mkdir -p "$TEMP"

echo "============================================"
echo "  MOVIE MONEY — MONTAGEM VÍDEO 2 (v3 FINAL)"
echo "  Voz: Beto contínua em todos os segmentos"
echo "  Visual: SCs animados (sem prints estáticos)"
echo "============================================"

# Duração do áudio master
AUDIO_DUR=$(ffprobe -v quiet -show_entries format=duration -of csv=p=0 "$AUDIO_MASTER" 2>/dev/null)
echo ""
echo "  Áudio master: ${AUDIO_DUR}s (voz do Beto — 11 takes)"

# ----------------------------------------------------------
# ETAPA 1: Preparar takes TH — apenas vídeo, sem áudio
# ----------------------------------------------------------
echo ""
echo "[1/4] Preparando takes de Talking Head (apenas vídeo)..."

norm_video_only() {
    local input="$1" output="$2"
    ffmpeg -y -i "$input" \
        -vf "scale=1280:720:force_original_aspect_ratio=decrease,pad=1280:720:(ow-iw)/2:(oh-ih)/2,setsar=1" \
        -c:v libx264 -preset fast -crf 20 -pix_fmt yuv420p \
        -an \
        "$output" 2>/dev/null
    local dur; dur=$(ffprobe -v quiet -show_entries format=duration -of csv=p=0 "$output" 2>/dev/null)
    printf "  ✓ TH %-35s  %.1fs\n" "$(basename $output)" "$dur"
}

norm_video_only "$TAKES/v2_t1a_hook_matematico.mp4"      "$TEMP/v_t1a.mp4"
norm_video_only "$TAKES/v2_t1b_algoritmo_pune.mp4"       "$TEMP/v_t1b.mp4"
norm_video_only "$TAKES/v2_t1c_caixa_preta.mp4"          "$TEMP/v_t1c.mp4"
norm_video_only "$TAKES/v2_t1d_maquina_faz.mp4"          "$TEMP/v_t1d.mp4"
norm_video_only "$TAKES/v2_t2a_elenco_nunca_atrasa.mp4"  "$TEMP/v_t2a.mp4"
norm_video_only "$TAKES/v2_t2b_voce_gerencia.mp4"        "$TEMP/v_t2b.mp4"
norm_video_only "$TAKES/v2_t3a_cereja_bolo.mp4"          "$TEMP/v_t3a.mp4"
norm_video_only "$TAKES/v2_t3b_engenharia_conversao.mp4" "$TEMP/v_t3b.mp4"
norm_video_only "$TAKES/v2_t4a_voce_viu_maquina.mp4"     "$TEMP/v_t4a.mp4"
norm_video_only "$TAKES/v2_t4b_boa_noticia.mp4"          "$TEMP/v_t4b.mp4"
norm_video_only "$TAKES/v2_t4c_proximo_video.mp4"        "$TEMP/v_t4c.mp4"

# ----------------------------------------------------------
# ETAPA 2: Preparar SCs animados — apenas vídeo, sem áudio
# ----------------------------------------------------------
echo ""
echo "[2/4] Preparando Screen Recordings animados (apenas vídeo)..."

prep_sc() {
    local input="$1" output="$2"
    ffmpeg -y -i "$input" \
        -vf "scale=1280:720:force_original_aspect_ratio=decrease,pad=1280:720:(ow-iw)/2:(oh-ih)/2,setsar=1" \
        -c:v libx264 -preset fast -crf 20 -pix_fmt yuv420p \
        -an \
        "$output" 2>/dev/null
    local dur; dur=$(ffprobe -v quiet -show_entries format=duration -of csv=p=0 "$output" 2>/dev/null)
    printf "  ✓ SC %-35s  %.1fs\n" "$(basename $output)" "$dur"
}

prep_sc "$ANIM/sc1_anim.mp4" "$TEMP/v_sc1.mp4"
prep_sc "$ANIM/sc2_anim.mp4" "$TEMP/v_sc2.mp4"
prep_sc "$ANIM/sc3_anim.mp4" "$TEMP/v_sc3.mp4"
prep_sc "$ANIM/sc4_anim.mp4" "$TEMP/v_sc4.mp4"
prep_sc "$ANIM/sc5_anim.mp4" "$TEMP/v_sc5.mp4"
prep_sc "$ANIM/sc6_anim.mp4" "$TEMP/v_sc6.mp4"
prep_sc "$ANIM/sc7_anim.mp4" "$TEMP/v_sc7.mp4"
prep_sc "$ANIM/sc8_anim.mp4" "$TEMP/v_sc8.mp4"
prep_sc "$ANIM/sc9_anim.mp4" "$TEMP/v_sc9.mp4"

# ----------------------------------------------------------
# ETAPA 3: Concatenar trilha visual (sem áudio)
# ----------------------------------------------------------
echo ""
echo "[3/4] Concatenando trilha visual e aplicando áudio master..."

cat > "$TEMP/concat_video.txt" << EOF
# SEÇÃO 1 — Hook da Prova Lógica
file '$TEMP/v_t1a.mp4'
file '$TEMP/v_sc1.mp4'
file '$TEMP/v_t1b.mp4'
file '$TEMP/v_t1c.mp4'
file '$TEMP/v_t1d.mp4'
# SEÇÃO 2 — A Arquitetura do Repositório
file '$TEMP/v_sc2.mp4'
file '$TEMP/v_sc3.mp4'
file '$TEMP/v_t2a.mp4'
file '$TEMP/v_t2b.mp4'
# SEÇÃO 3 — O Banco Narrativo
file '$TEMP/v_sc4.mp4'
file '$TEMP/v_sc5.mp4'
file '$TEMP/v_sc6.mp4'
# SEÇÃO 4 — Lip Sync e Safe Zone
file '$TEMP/v_t3a.mp4'
file '$TEMP/v_sc7.mp4'
file '$TEMP/v_sc8.mp4'
file '$TEMP/v_t3b.mp4'
# SEÇÃO 5 — CTA de Transição
file '$TEMP/v_t4a.mp4'
file '$TEMP/v_t4b.mp4'
file '$TEMP/v_t4c.mp4'
file '$TEMP/v_sc9.mp4'
EOF

TOTAL=$(grep -c '^file' "$TEMP/concat_video.txt")
echo "  ✓ $TOTAL segmentos visuais"

# Concatenar vídeo sem áudio
ffmpeg -y \
    -f concat -safe 0 \
    -i "$TEMP/concat_video.txt" \
    -c:v libx264 -preset medium -crf 18 -pix_fmt yuv420p \
    -an \
    "$TEMP/video_sem_audio.mp4" 2>/dev/null

VIDEO_DUR=$(ffprobe -v quiet -show_entries format=duration -of csv=p=0 "$TEMP/video_sem_audio.mp4" 2>/dev/null)
echo "  ✓ Trilha visual: ${VIDEO_DUR}s"

# Aplicar áudio master do Beto sobre toda a trilha visual
# O áudio do Beto (103s) será repetido/estendido para cobrir o vídeo inteiro
# usando o filtro aloop para repetir se necessário, ou cortar se o vídeo for mais curto
echo "  Aplicando voz do Beto como trilha master..."

ffmpeg -y \
    -i "$TEMP/video_sem_audio.mp4" \
    -stream_loop -1 -i "$AUDIO_MASTER" \
    -c:v copy \
    -c:a aac -b:a 192k -ar 48000 -ac 2 \
    -t "$VIDEO_DUR" \
    "$TEMP/video_com_audio.mp4" 2>/dev/null

echo "  ✓ Áudio do Beto aplicado sobre toda a trilha visual"

# ----------------------------------------------------------
# ETAPA 4: Marca d'água e exportação final
# ----------------------------------------------------------
echo ""
echo "[4/4] Aplicando marca d'água e exportando..."

if [ -f "$LOGO" ]; then
    ffmpeg -y \
        -i "$TEMP/video_com_audio.mp4" \
        -i "$LOGO" \
        -filter_complex "[1:v]scale=140:-1[wm];[0:v][wm]overlay=W-w-25:H-h-25:format=auto,format=yuv420p" \
        -c:v libx264 -preset medium -crf 18 \
        -c:a aac -b:a 192k \
        "$OUTPUT/video2_maquina_por_dentro_v3_FINAL.mp4" 2>/dev/null
    echo "  ✓ Marca d'água aplicada"
else
    cp "$TEMP/video_com_audio.mp4" "$OUTPUT/video2_maquina_por_dentro_v3_FINAL.mp4"
fi

# ----------------------------------------------------------
# RELATÓRIO
# ----------------------------------------------------------
echo ""
echo "============================================"
DURATION=$(ffprobe -v quiet -show_entries format=duration -of csv=p=0 \
    "$OUTPUT/video2_maquina_por_dentro_v3_FINAL.mp4" 2>/dev/null)
DURATION_MIN=$(echo "scale=2; $DURATION/60" | bc)
SIZE=$(du -sh "$OUTPUT/video2_maquina_por_dentro_v3_FINAL.mp4" | cut -f1)
echo "  Arquivo: video2_maquina_por_dentro_v3_FINAL.mp4"
echo "  Duração: ${DURATION_MIN} min  (${DURATION}s)"
echo "  Tamanho: $SIZE"
echo "  Resolução: 1280x720"
echo "  Segmentos: $TOTAL"
echo "  Áudio: VOZ DO BETO — contínua, zero voz robótica"
echo "  Visual: SCs animados — zero prints estáticos"
echo "============================================"

rm -rf "$TEMP"
echo "  Temporários removidos."
echo ""
echo "✅  Vídeo 2 v3 PRONTO!"
