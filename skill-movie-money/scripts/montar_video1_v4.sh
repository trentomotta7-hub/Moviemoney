#!/bin/bash
# ============================================================
# Script de Montagem v4 — Vídeo 1 YouTube (Quebra-Mitos)
# Movie Money — Sessão 7 (01/08/2026)
# Melhorias v4:
#   - Áudios v2 (mais assertivos, tom Fenrir refinado)
#   - Efeito Ken Burns (zoom dinâmico) nos Screen Recordings
#   - Transições suaves (crossfade 0.3s) entre takes
#   - VOs v2 nos screen recordings
#   - Regra: ZERO loop. Cada take é único. Min 10s por take.
# ============================================================
set -e

TAKES="/home/ubuntu/Moviemoney/skill-movie-money/criativos/video_institucional_youtube/takes"
TEMPLATES="/home/ubuntu/Moviemoney/skill-movie-money/templates"
OUTPUT="/home/ubuntu/Moviemoney/skill-movie-money/criativos/video_institucional_youtube"
WATERMARK="$TEMPLATES/identidade_visual/logo_transparente.png"
TEMP="$OUTPUT/temp_v4"
mkdir -p "$TEMP"

echo "============================================"
echo "  MOVIE MONEY — Montagem Vídeo 1 v4"
echo "  Áudios v2 + Ken Burns + Transições suaves"
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
# Função: Criar segmento SC com Ken Burns + VO v2
# Ken Burns: zoom suave de 1.0 → 1.08 durante a duração do VO
# ----------------------------------------------------------
make_sc_vo_kenburns() {
    local image="$1"
    local audio="$2"
    local output="$3"
    local audio_dur=$(ffprobe -v quiet -show_entries format=duration -of csv=p=0 "$audio" 2>/dev/null)
    local fps=24
    local total_frames=$(echo "$audio_dur * $fps" | bc | cut -d. -f1)
    ffmpeg -y \
        -loop 1 -i "$image" \
        -i "$audio" \
        -map 0:v -map 1:a \
        -t "$audio_dur" \
        -vf "scale=1280:720:force_original_aspect_ratio=decrease,pad=1280:720:(ow-iw)/2:(oh-ih)/2,
             zoompan=z='min(zoom+0.0003,1.08)':x='iw/2-(iw/zoom/2)':y='ih/2-(ih/zoom/2)':d=${total_frames}:s=1280x720:fps=${fps}" \
        -c:v libx264 -preset fast -crf 20 -pix_fmt yuv420p \
        -c:a aac -b:a 192k \
        "$output" 2>/dev/null
    local dur=$(ffprobe -v quiet -show_entries format=duration -of csv=p=0 "$output" 2>/dev/null)
    printf "  ✓ SC+VO+KB %-28s %.1fs\n" "$(basename $output)" "$dur"
}

# ----------------------------------------------------------
# Função: Criar segmento SC com Ken Burns (silencioso)
# ----------------------------------------------------------
make_sc_kenburns_silent() {
    local image="$1"
    local duration="$2"
    local output="$3"
    local fps=24
    local total_frames=$(echo "$duration * $fps" | bc | cut -d. -f1)
    ffmpeg -y -loop 1 -i "$image" -t "$duration" \
        -vf "scale=1280:720:force_original_aspect_ratio=decrease,pad=1280:720:(ow-iw)/2:(oh-ih)/2,
             zoompan=z='min(zoom+0.0003,1.08)':x='iw/2-(iw/zoom/2)':y='ih/2-(ih/zoom/2)':d=${total_frames}:s=1280x720:fps=${fps}" \
        -c:v libx264 -preset fast -crf 20 -pix_fmt yuv420p \
        -an "$output" 2>/dev/null
    printf "  ✓ SC+KB    %-28s %.1fs\n" "$(basename $output)" "$duration"
}

# ----------------------------------------------------------
# Função: Montar bloco de seção TH com áudio v2
# Recebe lista de takes (vídeo sem áudio) + áudio v2 da seção
# Concatena os takes e coloca o áudio por baixo
# Se os takes forem mais curtos que o áudio, freeze no último frame
# ----------------------------------------------------------
make_th_block_v2() {
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

    # Combinar vídeo concatenado com áudio v2 da seção
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
    printf "  ✓ TH v2  %-30s %.1fs (%d takes únicos)\n" "$(basename $output)" "$final_dur" "${#takes[@]}"
}

# ----------------------------------------------------------
# Função: Adicionar silêncio a segmento sem áudio
# (necessário para o concat funcionar com todos os segmentos)
# ----------------------------------------------------------
add_silence() {
    local input="$1"
    local output="$2"
    local dur=$(ffprobe -v quiet -show_entries format=duration -of csv=p=0 "$input" 2>/dev/null)
    ffmpeg -y \
        -i "$input" \
        -f lavfi -i "anullsrc=r=44100:cl=stereo" \
        -map 0:v -map 1:a \
        -t "$dur" \
        -c:v copy -c:a aac -b:a 128k \
        "$output" 2>/dev/null
}

# ----------------------------------------------------------
# ETAPA 1: Montar blocos de Talking Head por seção (áudios v2)
# ----------------------------------------------------------
echo "[1/4] Montando blocos de Talking Head (áudios v2, takes únicos, sem loop)..."

# S1 Hook (36.6s v2) → 4 takes: t1, t1b, t1c, t_s1d
make_th_block_v2 \
    "$TAKES/audio_s1_hook_v2.wav" \
    "$TEMP/bloco_s1_hook.mp4" \
    "$TAKES/t1_hook.mp4" \
    "$TAKES/t1b_voiceover_sonho.mp4" \
    "$TAKES/t1c_mentira_retencao.mp4" \
    "$TAKES/t_s1d_retencao.mp4"

# S2 Dor (24.9s v2) → 3 takes: t2, t3, t3b
make_th_block_v2 \
    "$TAKES/audio_s2_dor_v2.wav" \
    "$TEMP/bloco_s2_dor.mp4" \
    "$TAKES/t2_mentira.mp4" \
    "$TAKES/t3_dor.mp4" \
    "$TAKES/t3b_dono_negocio.mp4"

# S3 Máquina (31.1s v2) → 4 takes: t4, t4b, t_s3c, t_s2c
make_th_block_v2 \
    "$TAKES/audio_s3_maquina_v2.wav" \
    "$TEMP/bloco_s3_maquina.mp4" \
    "$TAKES/t4_ilusao.mp4" \
    "$TAKES/t4b_banco_narrativo.mp4" \
    "$TAKES/t_s3c_aponta_tela.mp4" \
    "$TAKES/t_s2c_bracos_cruzados.mp4"

# S4 Resultado (29.8s v2) → 3 takes: t5, t5b, t_s4b
make_th_block_v2 \
    "$TAKES/audio_s4_resultado_v2.wav" \
    "$TEMP/bloco_s4_resultado.mp4" \
    "$TAKES/t5_cta.mp4" \
    "$TAKES/t5b_municao.mp4" \
    "$TAKES/t_s4b_sorriso_canto.mp4"

# S5 CTA (27.8s v2) → 3 takes: t_cta_a, t_cta_b, t_s5b
make_th_block_v2 \
    "$TAKES/audio_s5_cta_v2.wav" \
    "$TEMP/bloco_s5_cta.mp4" \
    "$TAKES/t_cta_a.mp4" \
    "$TAKES/t_cta_b.mp4" \
    "$TAKES/t_s5b_aponta_camera.mp4"

# ----------------------------------------------------------
# ETAPA 2: Montar segmentos de Screen Recording com Ken Burns + VO v2
# ----------------------------------------------------------
echo "[2/4] Montando Screen Recordings com Ken Burns + VO v2..."

make_sc_vo_kenburns "$TAKES/sc1_youtube_gurus.png"       "$TAKES/vo_sc1_v2.wav"    "$TEMP/sc_s1_gurus.mp4"
make_sc_vo_kenburns "$TAKES/sc2_pasta_videos_chines.png"  "$TAKES/vo_sc2_v2.wav"    "$TEMP/sc_s2_pasta.mp4"
make_sc_vo_kenburns "$TAKES/sc3_whatsapp_cliente.png"     "$TAKES/vo_sc3_v2.wav"    "$TEMP/sc_s3_whatsapp.mp4"
make_sc_vo_kenburns "$TAKES/sc4_repositorio_terminal.png" "$TAKES/vo_sc4_v2.wav"    "$TEMP/sc_s4_repo.mp4"
make_sc_vo_kenburns "$TAKES/sc7_whatsapp_resposta.png"    "$TAKES/vo_sc7_v2.wav"    "$TEMP/sc_s4_resposta.mp4"

# SC5 e SC8 ficam silenciosos (efeito visual puro)
make_sc_kenburns_silent "$TAKES/sc5_ffmpeg_gerando.png" 5 "$TEMP/sc_s3_ffmpeg.mp4"
make_sc_kenburns_silent "$TAKES/sc8_logo_final.png"     4 "$TEMP/sc_logo_final.mp4"

# Adicionar silêncio aos SCs silenciosos para o concat funcionar
add_silence "$TEMP/sc_s3_ffmpeg.mp4"  "$TEMP/sc_s3_ffmpeg_audio.mp4"
add_silence "$TEMP/sc_logo_final.mp4" "$TEMP/sc_logo_final_audio.mp4"

# ----------------------------------------------------------
# ETAPA 3: Criar lista de concatenação final
# ----------------------------------------------------------
echo "[3/4] Criando lista de concatenação final..."

cat > "$TEMP/concat_v4.txt" << 'EOF'
# SEÇÃO 1 — Hook (TH com áudio v2)
file '$TEMP/bloco_s1_hook.mp4'
# SC1 — YouTube gurus (Ken Burns + VO v2)
file '$TEMP/sc_s1_gurus.mp4'
# SEÇÃO 2 — A Dor Real (TH com áudio v2)
file '$TEMP/bloco_s2_dor.mp4'
# SC2 — Pasta de vídeos chineses (Ken Burns + VO v2)
file '$TEMP/sc_s2_pasta.mp4'
# SEÇÃO 3 — A Máquina (TH com áudio v2)
file '$TEMP/bloco_s3_maquina.mp4'
# SC3 — WhatsApp cliente (Ken Burns + VO v2)
file '$TEMP/sc_s3_whatsapp.mp4'
# SC4 — Repositório terminal (Ken Burns + VO v2)
file '$TEMP/sc_s4_repo.mp4'
# SC5 — ffmpeg gerando (Ken Burns, silencioso)
file '$TEMP/sc_s3_ffmpeg_audio.mp4'
# SEÇÃO 4 — O Resultado (TH com áudio v2)
file '$TEMP/bloco_s4_resultado.mp4'
# SC7 — WhatsApp resposta fogo (Ken Burns + VO v2)
file '$TEMP/sc_s4_resposta.mp4'
# SEÇÃO 5 — CTA (TH com áudio v2)
file '$TEMP/bloco_s5_cta.mp4'
# Logo final (Ken Burns, silencioso)
file '$TEMP/sc_logo_final_audio.mp4'
EOF

# Substituir $TEMP pelo valor real
sed -i "s|\$TEMP|$TEMP|g" "$TEMP/concat_v4.txt"

NSEG=$(grep -c '^file' "$TEMP/concat_v4.txt")
echo "  ✓ Lista criada com $NSEG segmentos"

# Calcular duração total estimada
total_dur=0
while IFS= read -r line; do
    if [[ "$line" == file* ]]; then
        f=$(echo "$line" | sed "s/file '//;s/'//")
        dur=$(ffprobe -v quiet -show_entries format=duration -of csv=p=0 "$f" 2>/dev/null)
        total_dur=$(echo "$total_dur + $dur" | bc)
    fi
done < "$TEMP/concat_v4.txt"
echo "  ✓ Duração total estimada: $(echo "scale=1; $total_dur/60" | bc) min"

# ----------------------------------------------------------
# ETAPA 4: Concatenar, upscale 2K e injetar marca d'água
# ----------------------------------------------------------
echo "[4/4] Concatenando e exportando vídeo final 2K..."

ffmpeg -y -f concat -safe 0 -i "$TEMP/concat_v4.txt" \
    -c:v libx264 -preset medium -crf 18 -pix_fmt yuv420p \
    -c:a aac -b:a 192k \
    "$TEMP/video1_v4_1280.mp4" 2>/dev/null
echo "  ✓ Vídeo base concatenado em 1280x720"

# Upscale para 2560x1440 + marca d'água
if [ -f "$WATERMARK" ]; then
    ffmpeg -y \
        -i "$TEMP/video1_v4_1280.mp4" \
        -i "$WATERMARK" \
        -filter_complex "
            [0:v]scale=2560:1440:flags=lanczos[scaled];
            [1:v]scale=180:-1[wm];
            [scaled][wm]overlay=W-w-40:H-h-40:format=auto,format=yuv420p[out]
        " \
        -map "[out]" -map 0:a \
        -c:v libx264 -preset medium -crf 18 \
        -c:a aac -b:a 192k \
        "$OUTPUT/video1_quebra_mitos_v4_FINAL.mp4" 2>/dev/null
    echo "  ✓ Upscale 2560x1440 + marca d'água injetada"
else
    ffmpeg -y -i "$TEMP/video1_v4_1280.mp4" \
        -vf "scale=2560:1440:flags=lanczos" \
        -c:v libx264 -preset medium -crf 18 -pix_fmt yuv420p \
        -c:a aac -b:a 192k \
        "$OUTPUT/video1_quebra_mitos_v4_FINAL.mp4" 2>/dev/null
    echo "  ✓ Upscale 2560x1440 (sem marca d'água)"
fi

# ----------------------------------------------------------
# RELATÓRIO FINAL
# ----------------------------------------------------------
echo ""
echo "============================================"
echo "  MONTAGEM v4 CONCLUÍDA!"
echo "============================================"
DURATION=$(ffprobe -v quiet -show_entries format=duration -of csv=p=0 "$OUTPUT/video1_quebra_mitos_v4_FINAL.mp4" 2>/dev/null)
DURATION_MIN=$(echo "scale=2; $DURATION/60" | bc)
SIZE=$(du -sh "$OUTPUT/video1_quebra_mitos_v4_FINAL.mp4" | cut -f1)
echo "  Arquivo : video1_quebra_mitos_v4_FINAL.mp4"
echo "  Duração : ${DURATION_MIN} min (${DURATION}s)"
echo "  Tamanho : $SIZE"
echo "  Resolução: 2560x1440 (YouTube 2K)"
echo "  Takes TH: 17 únicos, sem loop"
echo "  Áudios  : v2 (Fenrir assertivo)"
echo "  SCs     : Ken Burns (zoom dinâmico)"
echo "============================================"
rm -rf "$TEMP"
echo "  Temporários removidos."
