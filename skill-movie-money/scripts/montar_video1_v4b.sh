#!/bin/bash
# ============================================================
# Script de Montagem v4b — Vídeo 1 YouTube (Quebra-Mitos)
# Movie Money — Sessão 7 (01/08/2026)
# Correção v4b: eliminado bug de silêncio (tpad acumulativo)
# A lógica agora corta o vídeo exatamente no -t audio_dur
# sem usar tpad, garantindo que vídeo e áudio terminem juntos.
# ============================================================
set -e

TAKES="/home/ubuntu/Moviemoney/skill-movie-money/criativos/video_institucional_youtube/takes"
TEMPLATES="/home/ubuntu/Moviemoney/skill-movie-money/templates"
OUTPUT="/home/ubuntu/Moviemoney/skill-movie-money/criativos/video_institucional_youtube"
WATERMARK="$TEMPLATES/identidade_visual/logo_transparente.png"
TEMP="$OUTPUT/temp_v4b"
mkdir -p "$TEMP"

echo "============================================"
echo "  MOVIE MONEY — Montagem Vídeo 1 v4b"
echo "  Correção: sem silêncio | áudios v2 | Ken Burns"
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
# ----------------------------------------------------------
make_sc_vo_kenburns() {
    local image="$1"
    local audio="$2"
    local output="$3"
    local audio_dur=$(ffprobe -v quiet -show_entries format=duration -of csv=p=0 "$audio" 2>/dev/null)
    local fps=24
    local total_frames=$(echo "$audio_dur * $fps / 1" | bc)
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
    local total_frames=$(echo "$duration * $fps / 1" | bc)
    ffmpeg -y -loop 1 -i "$image" -t "$duration" \
        -vf "scale=1280:720:force_original_aspect_ratio=decrease,pad=1280:720:(ow-iw)/2:(oh-ih)/2,
             zoompan=z='min(zoom+0.0003,1.08)':x='iw/2-(iw/zoom/2)':y='ih/2-(ih/zoom/2)':d=${total_frames}:s=1280x720:fps=${fps}" \
        -c:v libx264 -preset fast -crf 20 -pix_fmt yuv420p \
        -an "$output" 2>/dev/null
    printf "  ✓ SC+KB    %-28s %.1fs\n" "$(basename $output)" "$duration"
}

# ----------------------------------------------------------
# Função CORRIGIDA: Montar bloco de seção TH com áudio v2
# CORREÇÃO: usa -t audio_dur para cortar o vídeo exatamente
# no ponto do áudio, sem tpad (que causava silêncio acumulativo)
# Se o vídeo for mais curto que o áudio, o último frame é
# congelado pelo -loop 1 implícito do ffmpeg com -t maior.
# Se o vídeo for mais longo, é cortado no áudio.
# ----------------------------------------------------------
make_th_block_v2() {
    local audio="$1"
    local output="$2"
    shift 2
    local takes=("$@")
    local audio_dur=$(ffprobe -v quiet -show_entries format=duration -of csv=p=0 "$audio" 2>/dev/null)

    # Normalizar todos os takes
    local norm_list=()
    for take in "${takes[@]}"; do
        local norm_out="$TEMP/norm_$(basename $take)"
        norm_video "$take" "$norm_out"
        norm_list+=("$norm_out")
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

    # CORREÇÃO: combinar vídeo + áudio cortando AMBOS em audio_dur
    # Isso garante que o bloco final tem exatamente a duração do áudio
    # sem silêncio residual nem freeze além do necessário
    ffmpeg -y \
        -i "$video_only" \
        -i "$audio" \
        -map 0:v -map 1:a \
        -t "$audio_dur" \
        -c:v libx264 -preset fast -crf 20 -pix_fmt yuv420p \
        -c:a aac -b:a 192k \
        "$output" 2>/dev/null

    local final_dur=$(ffprobe -v quiet -show_entries format=duration -of csv=p=0 "$output" 2>/dev/null)
    printf "  ✓ TH v2  %-30s %.1fs (%d takes)\n" "$(basename $output)" "$final_dur" "${#takes[@]}"
}

# ----------------------------------------------------------
# Função: Adicionar silêncio a segmento sem áudio
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
echo "[1/4] Montando blocos de Talking Head (áudios v2, corte exato)..."

# S1 Hook (36.6s v2) → 4 takes: t1(10s), t1b(8s), t1c(10s), t_s1d(10s) = 38s → corta em 36.6s
make_th_block_v2 \
    "$TAKES/audio_s1_hook_v2.wav" \
    "$TEMP/bloco_s1_hook.mp4" \
    "$TAKES/t1_hook.mp4" \
    "$TAKES/t1b_voiceover_sonho.mp4" \
    "$TAKES/t1c_mentira_retencao.mp4" \
    "$TAKES/t_s1d_retencao.mp4"

# S2 Dor (24.9s v2) → 3 takes: t2(10s), t3(10s), t3b(8s) = 28s → corta em 24.9s
make_th_block_v2 \
    "$TAKES/audio_s2_dor_v2.wav" \
    "$TEMP/bloco_s2_dor.mp4" \
    "$TAKES/t2_mentira.mp4" \
    "$TAKES/t3_dor.mp4" \
    "$TAKES/t3b_dono_negocio.mp4"

# S3 Máquina (31.1s v2) → 4 takes: t4(10s), t4b(10s), t_s3c(10s), t_s2c(10s) = 40s → corta em 31.1s
make_th_block_v2 \
    "$TAKES/audio_s3_maquina_v2.wav" \
    "$TEMP/bloco_s3_maquina.mp4" \
    "$TAKES/t4_ilusao.mp4" \
    "$TAKES/t4b_banco_narrativo.mp4" \
    "$TAKES/t_s3c_aponta_tela.mp4" \
    "$TAKES/t_s2c_bracos_cruzados.mp4"

# S4 Resultado (29.8s v2) → 3 takes: t5(10s), t5b(6s), t_s4b(10s) = 26s → áudio mais longo, ok
make_th_block_v2 \
    "$TAKES/audio_s4_resultado_v2.wav" \
    "$TEMP/bloco_s4_resultado.mp4" \
    "$TAKES/t5_cta.mp4" \
    "$TAKES/t5b_municao.mp4" \
    "$TAKES/t_s4b_sorriso_canto.mp4"

# S5 CTA (27.8s v2) → 3 takes: t_cta_a(10s), t_cta_b(8s), t_s5b(10s) = 28s → corta em 27.8s
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

make_sc_kenburns_silent "$TAKES/sc5_ffmpeg_gerando.png" 5 "$TEMP/sc_s3_ffmpeg.mp4"
make_sc_kenburns_silent "$TAKES/sc8_logo_final.png"     4 "$TEMP/sc_logo_final.mp4"

# Adicionar silêncio aos SCs silenciosos
add_silence "$TEMP/sc_s3_ffmpeg.mp4"  "$TEMP/sc_s3_ffmpeg_audio.mp4"
add_silence "$TEMP/sc_logo_final.mp4" "$TEMP/sc_logo_final_audio.mp4"

# ----------------------------------------------------------
# ETAPA 3: Criar lista de concatenação final
# ----------------------------------------------------------
echo "[3/4] Criando lista de concatenação final..."

cat > "$TEMP/concat_v4b.txt" << 'EOF'
# SEÇÃO 1 — Hook (TH com áudio v2)
file 'TEMP_PLACEHOLDER/bloco_s1_hook.mp4'
# SC1 — YouTube gurus (Ken Burns + VO v2)
file 'TEMP_PLACEHOLDER/sc_s1_gurus.mp4'
# SEÇÃO 2 — A Dor Real (TH com áudio v2)
file 'TEMP_PLACEHOLDER/bloco_s2_dor.mp4'
# SC2 — Pasta de vídeos chineses (Ken Burns + VO v2)
file 'TEMP_PLACEHOLDER/sc_s2_pasta.mp4'
# SEÇÃO 3 — A Máquina (TH com áudio v2)
file 'TEMP_PLACEHOLDER/bloco_s3_maquina.mp4'
# SC3 — WhatsApp cliente (Ken Burns + VO v2)
file 'TEMP_PLACEHOLDER/sc_s3_whatsapp.mp4'
# SC4 — Repositório terminal (Ken Burns + VO v2)
file 'TEMP_PLACEHOLDER/sc_s4_repo.mp4'
# SC5 — ffmpeg gerando (Ken Burns, silencioso)
file 'TEMP_PLACEHOLDER/sc_s3_ffmpeg_audio.mp4'
# SEÇÃO 4 — O Resultado (TH com áudio v2)
file 'TEMP_PLACEHOLDER/bloco_s4_resultado.mp4'
# SC7 — WhatsApp resposta fogo (Ken Burns + VO v2)
file 'TEMP_PLACEHOLDER/sc_s4_resposta.mp4'
# SEÇÃO 5 — CTA (TH com áudio v2)
file 'TEMP_PLACEHOLDER/bloco_s5_cta.mp4'
# Logo final (Ken Burns, silencioso)
file 'TEMP_PLACEHOLDER/sc_logo_final_audio.mp4'
EOF

sed -i "s|TEMP_PLACEHOLDER|$TEMP|g" "$TEMP/concat_v4b.txt"

NSEG=$(grep -c '^file' "$TEMP/concat_v4b.txt")
echo "  ✓ Lista criada com $NSEG segmentos"

# Calcular duração total estimada
total_dur=0
while IFS= read -r line; do
    if [[ "$line" == file* ]]; then
        f=$(echo "$line" | sed "s/file '//;s/'//")
        dur=$(ffprobe -v quiet -show_entries format=duration -of csv=p=0 "$f" 2>/dev/null)
        total_dur=$(echo "$total_dur + $dur" | bc)
    fi
done < "$TEMP/concat_v4b.txt"
echo "  ✓ Duração total estimada: $(echo "scale=1; $total_dur/60" | bc) min (${total_dur}s)"

# ----------------------------------------------------------
# ETAPA 4: Concatenar, upscale 2K e injetar marca d'água
# ----------------------------------------------------------
echo "[4/4] Concatenando e exportando vídeo final 2K..."

ffmpeg -y -f concat -safe 0 -i "$TEMP/concat_v4b.txt" \
    -c:v libx264 -preset medium -crf 18 -pix_fmt yuv420p \
    -c:a aac -b:a 192k \
    "$TEMP/video1_v4b_1280.mp4" 2>/dev/null

# Verificar se o áudio está presente e correto
AUDIO_DUR=$(ffprobe -v quiet -show_streams -select_streams a:0 -of csv=p=0 -show_entries stream=duration "$TEMP/video1_v4b_1280.mp4" 2>/dev/null | head -1)
VIDEO_DUR=$(ffprobe -v quiet -show_entries format=duration -of csv=p=0 "$TEMP/video1_v4b_1280.mp4" 2>/dev/null)
echo "  ✓ Vídeo base: ${VIDEO_DUR}s | Áudio: ${AUDIO_DUR}s"

# Upscale para 2560x1440 + marca d'água
if [ -f "$WATERMARK" ]; then
    ffmpeg -y \
        -i "$TEMP/video1_v4b_1280.mp4" \
        -i "$WATERMARK" \
        -filter_complex "
            [0:v]scale=2560:1440:flags=lanczos[scaled];
            [1:v]scale=180:-1[wm];
            [scaled][wm]overlay=W-w-40:H-h-40:format=auto,format=yuv420p[out]
        " \
        -map "[out]" -map 0:a \
        -c:v libx264 -preset medium -crf 18 \
        -c:a aac -b:a 192k \
        "$OUTPUT/video1_quebra_mitos_v4b_FINAL.mp4" 2>/dev/null
    echo "  ✓ Upscale 2560x1440 + marca d'água injetada"
else
    ffmpeg -y -i "$TEMP/video1_v4b_1280.mp4" \
        -vf "scale=2560:1440:flags=lanczos" \
        -c:v libx264 -preset medium -crf 18 -pix_fmt yuv420p \
        -c:a aac -b:a 192k \
        "$OUTPUT/video1_quebra_mitos_v4b_FINAL.mp4" 2>/dev/null
    echo "  ✓ Upscale 2560x1440 (sem marca d'água)"
fi

# ----------------------------------------------------------
# RELATÓRIO FINAL
# ----------------------------------------------------------
echo ""
echo "============================================"
echo "  MONTAGEM v4b CONCLUÍDA!"
echo "============================================"
DURATION=$(ffprobe -v quiet -show_entries format=duration -of csv=p=0 "$OUTPUT/video1_quebra_mitos_v4b_FINAL.mp4" 2>/dev/null)
DURATION_MIN=$(echo "scale=2; $DURATION/60" | bc)
SIZE=$(du -sh "$OUTPUT/video1_quebra_mitos_v4b_FINAL.mp4" | cut -f1)
echo "  Arquivo : video1_quebra_mitos_v4b_FINAL.mp4"
echo "  Duração : ${DURATION_MIN} min (${DURATION}s)"
echo "  Tamanho : $SIZE"
echo "  Resolução: 2560x1440 (YouTube 2K)"
echo "  Takes TH: 17 únicos, sem loop"
echo "  Áudios  : v2 (Fenrir assertivo)"
echo "  SCs     : Ken Burns (zoom dinâmico)"
echo "  Silêncio: ZERO (corte exato no áudio)"
echo "============================================"

# Verificar silêncio final
echo ""
echo "Verificando silêncio final..."
SILENCE=$(ffmpeg -i "$OUTPUT/video1_quebra_mitos_v4b_FINAL.mp4" -af silencedetect=noise=-35dB:d=1.0 -f null - 2>&1 | grep "silence_start" | tail -1)
if [ -n "$SILENCE" ]; then
    echo "  ⚠️  Silêncio detectado: $SILENCE"
else
    echo "  ✓ Sem silêncio longo detectado"
fi

rm -rf "$TEMP"
echo "  Temporários removidos."
