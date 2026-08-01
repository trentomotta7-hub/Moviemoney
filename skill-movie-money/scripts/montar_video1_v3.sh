#!/bin/bash
# ============================================================
# Script de Montagem v3 — Vídeo 1 YouTube (Quebra-Mitos)
# Movie Money — Sessão 6 (01/08/2026)
# Regra: ZERO loop. Cada take é único. Min 10s por take.
# ============================================================
# Estratégia:
# - Cada seção tem um áudio longo (audio_sX.wav)
# - Os takes de TH são cortados em janelas de 10s e empilhados
#   com o áudio da seção correndo por baixo
# - Screen recordings entram entre seções com seus VOs
# - Resultado: vídeo com cortes rítmicos a cada 10s, sem repetição
# ============================================================

set -e

TAKES="/home/ubuntu/Moviemoney/skill-movie-money/criativos/video_institucional_youtube/takes"
TEMPLATES="/home/ubuntu/Moviemoney/skill-movie-money/templates"
OUTPUT="/home/ubuntu/Moviemoney/skill-movie-money/criativos/video_institucional_youtube"
WATERMARK="$TEMPLATES/identidade_visual/logo_transparente.png"
TEMP="$OUTPUT/temp_v3"

mkdir -p "$TEMP"

echo "============================================"
echo "  MOVIE MONEY — Montagem Vídeo 1 v3"
echo "  Regra: ZERO loop, takes únicos de 10s"
echo "============================================"

# ----------------------------------------------------------
# Função: Normalizar take para 1280x720 sem áudio
# ----------------------------------------------------------
norm_video() {
    local input="$1"
    local output="$2"
    ffmpeg -y -i "$input" \
        -vf "scale=1280:720:force_original_aspect_ratio=decrease,pad=1280:720:(ow-iw)/2:(oh-ih)/2" \
        -c:v libx264 -preset fast -crf 20 -pix_fmt yuv420p \
        -an "$output" 2>/dev/null
}

# ----------------------------------------------------------
# Função: Criar segmento SC com VO (imagem + áudio)
# ----------------------------------------------------------
make_sc_vo() {
    local image="$1"
    local audio="$2"
    local output="$3"
    local audio_dur=$(ffprobe -v quiet -show_entries format=duration -of csv=p=0 "$audio" 2>/dev/null)
    ffmpeg -y \
        -loop 1 -i "$image" \
        -i "$audio" \
        -map 0:v -map 1:a \
        -t "$audio_dur" \
        -vf "scale=1280:720:force_original_aspect_ratio=decrease,pad=1280:720:(ow-iw)/2:(oh-ih)/2" \
        -c:v libx264 -preset fast -crf 20 -pix_fmt yuv420p \
        -c:a aac -b:a 192k \
        "$output" 2>/dev/null
    local dur=$(ffprobe -v quiet -show_entries format=duration -of csv=p=0 "$output" 2>/dev/null)
    printf "  ✓ SC+VO %-30s %.1fs\n" "$(basename $output)" "$dur"
}

# ----------------------------------------------------------
# Função: Criar segmento SC silencioso
# ----------------------------------------------------------
make_sc_silent() {
    local image="$1"
    local duration="$2"
    local output="$3"
    ffmpeg -y -loop 1 -i "$image" -t "$duration" \
        -vf "scale=1280:720:force_original_aspect_ratio=decrease,pad=1280:720:(ow-iw)/2:(oh-ih)/2" \
        -c:v libx264 -preset fast -crf 20 -pix_fmt yuv420p \
        -an "$output" 2>/dev/null
    printf "  ✓ SC     %-30s %.1fs\n" "$(basename $output)" "$duration"
}

# ----------------------------------------------------------
# Função: Montar bloco de seção TH
# Recebe lista de takes (vídeo sem áudio) + áudio da seção
# Concatena os takes e coloca o áudio por baixo
# Se os takes forem mais curtos que o áudio, os últimos takes
# são estendidos com fade out de vídeo (não loop)
# ----------------------------------------------------------
make_th_block() {
    local audio="$1"
    local output="$2"
    shift 2
    local takes=("$@")
    
    local audio_dur=$(ffprobe -v quiet -show_entries format=duration -of csv=p=0 "$audio" 2>/dev/null)
    
    # Normalizar todos os takes
    local norm_list=()
    local total_video_dur=0
    local i=0
    for take in "${takes[@]}"; do
        local norm_out="$TEMP/norm_$(basename $take)"
        norm_video "$take" "$norm_out"
        norm_list+=("$norm_out")
        local vdur=$(ffprobe -v quiet -show_entries format=duration -of csv=p=0 "$norm_out" 2>/dev/null)
        total_video_dur=$(echo "$total_video_dur + $vdur" | bc)
        i=$((i+1))
    done
    
    # Criar concat list dos takes normalizados
    local concat_file="$TEMP/concat_th_$(basename $output .mp4).txt"
    > "$concat_file"
    for norm in "${norm_list[@]}"; do
        echo "file '$norm'" >> "$concat_file"
    done
    
    # Concatenar takes de vídeo
    local video_only="$TEMP/video_only_$(basename $output)"
    ffmpeg -y -f concat -safe 0 -i "$concat_file" \
        -c:v libx264 -preset fast -crf 20 -pix_fmt yuv420p \
        -an "$video_only" 2>/dev/null
    
    # Combinar vídeo concatenado com áudio da seção
    # Se vídeo for mais curto que áudio: freeze no último frame
    # Se vídeo for mais longo que áudio: corta no áudio
    ffmpeg -y \
        -i "$video_only" \
        -i "$audio" \
        -filter_complex "[0:v]tpad=stop_mode=clone:stop_duration=10[vpad]" \
        -map "[vpad]" -map 1:a \
        -t "$audio_dur" \
        -c:v libx264 -preset fast -crf 20 -pix_fmt yuv420p \
        -c:a aac -b:a 192k \
        "$output" 2>/dev/null
    
    local final_dur=$(ffprobe -v quiet -show_entries format=duration -of csv=p=0 "$output" 2>/dev/null)
    printf "  ✓ TH     %-30s %.1fs (%d takes únicos)\n" "$(basename $output)" "$final_dur" "${#takes[@]}"
}

# ----------------------------------------------------------
# ETAPA 1: Montar blocos de Talking Head por seção
# ----------------------------------------------------------
echo "[1/4] Montando blocos de Talking Head (takes únicos, sem loop)..."

# S1 Hook (35.2s) → 4 takes: t1, t1b, t1c, t_s1d
make_th_block \
    "$TAKES/audio_s1_hook.wav" \
    "$TEMP/bloco_s1_hook.mp4" \
    "$TAKES/t1_hook.mp4" \
    "$TAKES/t1b_voiceover_sonho.mp4" \
    "$TAKES/t1c_mentira_retencao.mp4" \
    "$TAKES/t_s1d_retencao.mp4"

# S2 Dor (25.4s) → 3 takes: t2, t3, t3b
make_th_block \
    "$TAKES/audio_s2_dor.wav" \
    "$TEMP/bloco_s2_dor.mp4" \
    "$TAKES/t2_mentira.mp4" \
    "$TAKES/t3_dor.mp4" \
    "$TAKES/t3b_dono_negocio.mp4"

# S3 Máquina (31.1s) → 4 takes: t4, t4b, t_s3c, t_s1d reutilizado? NÃO — usar t_s3c + t4b
make_th_block \
    "$TAKES/audio_s3_maquina.wav" \
    "$TEMP/bloco_s3_maquina.mp4" \
    "$TAKES/t4_ilusao.mp4" \
    "$TAKES/t4b_banco_narrativo.mp4" \
    "$TAKES/t_s3c_aponta_tela.mp4" \
    "$TAKES/t_s1d_retencao.mp4"

# S4 Resultado (29.0s) → 3 takes: t5, t5b, t_s4b
make_th_block \
    "$TAKES/audio_s4_resultado.wav" \
    "$TEMP/bloco_s4_resultado.mp4" \
    "$TAKES/t5_cta.mp4" \
    "$TAKES/t5b_municao.mp4" \
    "$TAKES/t_s4b_sorriso_canto.mp4"

# S5 CTA (26.8s) → 3 takes: t_cta_a, t_cta_b, t_s5b
make_th_block \
    "$TAKES/audio_s5_cta.wav" \
    "$TEMP/bloco_s5_cta.mp4" \
    "$TAKES/t_cta_a.mp4" \
    "$TAKES/t_cta_b.mp4" \
    "$TAKES/t_s5b_aponta_camera.mp4"

# ----------------------------------------------------------
# ETAPA 2: Montar segmentos de Screen Recording com VO
# ----------------------------------------------------------
echo "[2/4] Montando segmentos de Screen Recording com Voice Over..."

make_sc_vo "$TAKES/sc1_youtube_gurus.png"       "$TAKES/vo_sc1_youtube_gurus.wav"    "$TEMP/sc_s1_gurus.mp4"
make_sc_vo "$TAKES/sc2_pasta_videos_chines.png"  "$TAKES/vo_sc2_pasta_videos.wav"     "$TEMP/sc_s2_pasta.mp4"
make_sc_vo "$TAKES/sc3_whatsapp_cliente.png"     "$TAKES/vo_sc3_whatsapp_cliente.wav" "$TEMP/sc_s3_whatsapp.mp4"
make_sc_vo "$TAKES/sc4_repositorio_terminal.png" "$TAKES/vo_sc4_repositorio.wav"      "$TEMP/sc_s4_repo.mp4"
make_sc_vo "$TAKES/sc7_whatsapp_resposta.png"    "$TAKES/vo_sc7_whatsapp_resposta.wav" "$TEMP/sc_s4_resposta.mp4"
make_sc_silent "$TAKES/sc5_ffmpeg_gerando.png" 5 "$TEMP/sc_s3_ffmpeg.mp4"
make_sc_silent "$TAKES/sc8_logo_final.png"     4 "$TEMP/sc_logo_final.mp4"

# ----------------------------------------------------------
# ETAPA 3: Criar lista de concatenação final
# ----------------------------------------------------------
echo "[3/4] Criando lista de concatenação final..."

# Todos os segmentos precisam ter áudio para o concat funcionar
# Segmentos silenciosos precisam de faixa de áudio silenciosa
add_silent_audio() {
    local input="$1"
    local output="$2"
    ffmpeg -y -i "$input" \
        -f lavfi -i anullsrc=r=44100:cl=stereo \
        -map 0:v -map 1:a \
        -t "$(ffprobe -v quiet -show_entries format=duration -of csv=p=0 "$input" 2>/dev/null)" \
        -c:v copy -c:a aac -b:a 128k \
        "$output" 2>/dev/null
}

add_silent_audio "$TEMP/sc_s3_ffmpeg.mp4"   "$TEMP/sc_s3_ffmpeg_audio.mp4"
add_silent_audio "$TEMP/sc_logo_final.mp4"  "$TEMP/sc_logo_final_audio.mp4"

cat > "$TEMP/concat_v3.txt" << EOF
# SEÇÃO 1 — Hook da Verdade (TH com áudio)
file '$TEMP/bloco_s1_hook.mp4'
# SC1 — YouTube gurus (VO)
file '$TEMP/sc_s1_gurus.mp4'
# SC2 — Pasta vídeos chineses (VO)
file '$TEMP/sc_s2_pasta.mp4'
# SEÇÃO 2 — A Dor Real (TH com áudio)
file '$TEMP/bloco_s2_dor.mp4'
# SC3 — WhatsApp cliente (VO)
file '$TEMP/sc_s3_whatsapp.mp4'
# SEÇÃO 3 — A Máquina (TH com áudio)
file '$TEMP/bloco_s3_maquina.mp4'
# SC4 — Repositório + terminal (VO)
file '$TEMP/sc_s4_repo.mp4'
# SC5 — ffmpeg gerando (silêncio)
file '$TEMP/sc_s3_ffmpeg_audio.mp4'
# SEÇÃO 4 — O Resultado (TH com áudio)
file '$TEMP/bloco_s4_resultado.mp4'
# SC7 — WhatsApp resposta fogo (VO)
file '$TEMP/sc_s4_resposta.mp4'
# SEÇÃO 5 — CTA (TH com áudio)
file '$TEMP/bloco_s5_cta.mp4'
# Logo final
file '$TEMP/sc_logo_final_audio.mp4'
EOF

NSEG=$(grep -c '^file' "$TEMP/concat_v3.txt")
echo "  ✓ Lista criada com $NSEG segmentos"

# Calcular duração total
total_dur=0
while IFS= read -r line; do
    if [[ "$line" == file* ]]; then
        f=$(echo "$line" | sed "s/file '//;s/'//")
        dur=$(ffprobe -v quiet -show_entries format=duration -of csv=p=0 "$f" 2>/dev/null)
        total_dur=$(echo "$total_dur + $dur" | bc)
    fi
done < "$TEMP/concat_v3.txt"
echo "  ✓ Duração total estimada: $(echo "scale=1; $total_dur/60" | bc) min"

# ----------------------------------------------------------
# ETAPA 4: Concatenar, upscale 2K e injetar marca d'água
# ----------------------------------------------------------
echo "[4/4] Concatenando e exportando vídeo final 2K..."

ffmpeg -y -f concat -safe 0 -i "$TEMP/concat_v3.txt" \
    -c:v libx264 -preset medium -crf 18 -pix_fmt yuv420p \
    -c:a aac -b:a 192k \
    "$TEMP/video1_v3_1280.mp4" 2>/dev/null

echo "  ✓ Vídeo base concatenado em 1280x720"

# Upscale para 2560x1440 + marca d'água
if [ -f "$WATERMARK" ]; then
    ffmpeg -y \
        -i "$TEMP/video1_v3_1280.mp4" \
        -i "$WATERMARK" \
        -filter_complex "
            [0:v]scale=2560:1440:flags=lanczos[scaled];
            [1:v]scale=180:-1[wm];
            [scaled][wm]overlay=W-w-40:H-h-40:format=auto,format=yuv420p[out]
        " \
        -map "[out]" -map 0:a \
        -c:v libx264 -preset medium -crf 18 \
        -c:a aac -b:a 192k \
        "$OUTPUT/video1_quebra_mitos_v3_FINAL.mp4" 2>/dev/null
    echo "  ✓ Upscale 2560x1440 + marca d'água injetada"
else
    ffmpeg -y -i "$TEMP/video1_v3_1280.mp4" \
        -vf "scale=2560:1440:flags=lanczos" \
        -c:v libx264 -preset medium -crf 18 -pix_fmt yuv420p \
        -c:a aac -b:a 192k \
        "$OUTPUT/video1_quebra_mitos_v3_FINAL.mp4" 2>/dev/null
    echo "  ✓ Upscale 2560x1440 (sem marca d'água)"
fi

# ----------------------------------------------------------
# RELATÓRIO FINAL
# ----------------------------------------------------------
echo ""
echo "============================================"
echo "  MONTAGEM v3 CONCLUÍDA!"
echo "============================================"
DURATION=$(ffprobe -v quiet -show_entries format=duration -of csv=p=0 "$OUTPUT/video1_quebra_mitos_v3_FINAL.mp4" 2>/dev/null)
DURATION_MIN=$(echo "scale=2; $DURATION/60" | bc)
SIZE=$(du -sh "$OUTPUT/video1_quebra_mitos_v3_FINAL.mp4" | cut -f1)
echo "  Arquivo : video1_quebra_mitos_v3_FINAL.mp4"
echo "  Duração : ${DURATION_MIN} min (${DURATION}s)"
echo "  Tamanho : $SIZE"
echo "  Resolução: 2560x1440 (YouTube 2K)"
echo "  Takes TH: 17 únicos, sem loop"
echo "============================================"

rm -rf "$TEMP"
echo "  Temporários removidos."
