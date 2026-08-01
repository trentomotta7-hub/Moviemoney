#!/bin/bash
# ============================================================
# Script de Montagem v4c — Vídeo 1 YouTube (Quebra-Mitos)
# Movie Money — Sessão 7 (01/08/2026)
#
# ARQUITETURA CORRETA:
# - Takes de TH têm áudio de lip sync embutido (nativo do modelo)
# - Cada take é normalizado e concatenado com seu áudio original
# - SCs recebem Ken Burns + VO v2 (narração de tela)
# - NÃO substitui o áudio dos takes por áudios externos
# - Resultado: vídeo limpo com lip sync real + Ken Burns nos SCs
#
# Duração estimada: ~160s (2min40s) de TH + ~58s de SCs = ~218s (3min38s)
# ============================================================
set -e

BASE="/home/ubuntu/Moviemoney/skill-movie-money/criativos/video_institucional_youtube"
TAKES="$BASE/takes"
TEMPLATES="/home/ubuntu/Moviemoney/skill-movie-money/templates"
OUTPUT="$BASE"
WATERMARK="$TEMPLATES/identidade_visual/logo_transparente.png"
TEMP="$BASE/temp_v4c"
mkdir -p "$TEMP"

echo "============================================"
echo "  MOVIE MONEY — Montagem Vídeo 1 v4c"
echo "  Lip sync nativo | Ken Burns nos SCs | Limpo"
echo "============================================"

# ----------------------------------------------------------
# Função: Normalizar take para 1280x720 MANTENDO áudio original
# ----------------------------------------------------------
norm_take() {
    local input="$1"
    local output="$2"
    ffmpeg -y -i "$input" \
        -vf "scale=1280:720:force_original_aspect_ratio=decrease,pad=1280:720:(ow-iw)/2:(oh-ih)/2" \
        -c:v libx264 -preset fast -crf 20 -pix_fmt yuv420p \
        -c:a aac -b:a 192k \
        "$output" 2>/dev/null
}

# ----------------------------------------------------------
# Função: Criar segmento SC com Ken Burns + VO v2
# ----------------------------------------------------------
make_sc_vo_kenburns() {
    local image="$1"
    local audio="$2"
    local output="$3"
    local audio_dur
    audio_dur=$(ffprobe -v quiet -show_entries format=duration -of csv=p=0 "$audio" 2>/dev/null)
    local fps=24
    local total_frames
    total_frames=$(echo "$audio_dur * $fps / 1" | bc)
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
    local dur
    dur=$(ffprobe -v quiet -show_entries format=duration -of csv=p=0 "$output" 2>/dev/null)
    printf "  ✓ SC+VO+KB %-30s %.1fs\n" "$(basename "$output")" "$dur"
}

# ----------------------------------------------------------
# Função: Criar segmento SC com Ken Burns + silêncio
# ----------------------------------------------------------
make_sc_kenburns_silent() {
    local image="$1"
    local duration="$2"
    local output="$3"
    local fps=24
    local total_frames
    total_frames=$(echo "$duration * $fps / 1" | bc)
    ffmpeg -y -loop 1 -i "$image" -t "$duration" \
        -vf "scale=1280:720:force_original_aspect_ratio=decrease,pad=1280:720:(ow-iw)/2:(oh-ih)/2,
             zoompan=z='min(zoom+0.0003,1.08)':x='iw/2-(iw/zoom/2)':y='ih/2-(ih/zoom/2)':d=${total_frames}:s=1280x720:fps=${fps}" \
        -c:v libx264 -preset fast -crf 20 -pix_fmt yuv420p \
        -f lavfi -i "anullsrc=r=44100:cl=stereo" \
        -map 0:v -map 2:a \
        -t "$duration" \
        -c:a aac -b:a 128k \
        "$output" 2>/dev/null
    printf "  ✓ SC+KB    %-30s %.1fs\n" "$(basename "$output")" "$duration"
}

# ----------------------------------------------------------
# ETAPA 1: Normalizar todos os takes de TH (mantendo áudio nativo)
# ----------------------------------------------------------
echo "[1/4] Normalizando takes de Talking Head (áudio lip sync nativo)..."

TAKE_LIST=(
    "t1_hook.mp4"
    "t1b_voiceover_sonho.mp4"
    "t1c_mentira_retencao.mp4"
    "t_s1d_retencao.mp4"
    "t2_mentira.mp4"
    "t3_dor.mp4"
    "t3b_dono_negocio.mp4"
    "t4_ilusao.mp4"
    "t4b_banco_narrativo.mp4"
    "t_s3c_aponta_tela.mp4"
    "t_s2c_bracos_cruzados.mp4"
    "t5_cta.mp4"
    "t5b_municao.mp4"
    "t_s4b_sorriso_canto.mp4"
    "t_cta_a.mp4"
    "t_cta_b.mp4"
    "t_s5b_aponta_camera.mp4"
)

for take in "${TAKE_LIST[@]}"; do
    norm_take "$TAKES/$take" "$TEMP/norm_$take"
    dur=$(ffprobe -v quiet -show_entries format=duration -of csv=p=0 "$TEMP/norm_$take" 2>/dev/null)
    printf "  ✓ norm %-35s %.1fs\n" "$take" "$dur"
done

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

# ----------------------------------------------------------
# ETAPA 3: Criar lista de concatenação final
# Ordem narrativa: S1 Hook → SC1 → S2 Dor → SC2 → S3 Máquina → SC3 → SC4 → SC5 → S4 Resultado → SC7 → S5 CTA → Logo
# ----------------------------------------------------------
echo "[3/4] Criando lista de concatenação final..."

cat > "$TEMP/concat_v4c.txt" << EOF
# S1 Hook — 4 takes (lip sync nativo)
file '$TEMP/norm_t1_hook.mp4'
file '$TEMP/norm_t1b_voiceover_sonho.mp4'
file '$TEMP/norm_t1c_mentira_retencao.mp4'
file '$TEMP/norm_t_s1d_retencao.mp4'
# SC1 — YouTube gurus (Ken Burns + VO v2)
file '$TEMP/sc_s1_gurus.mp4'
# S2 Dor — 3 takes
file '$TEMP/norm_t2_mentira.mp4'
file '$TEMP/norm_t3_dor.mp4'
file '$TEMP/norm_t3b_dono_negocio.mp4'
# SC2 — Pasta vídeos chineses (Ken Burns + VO v2)
file '$TEMP/sc_s2_pasta.mp4'
# S3 Máquina — 4 takes
file '$TEMP/norm_t4_ilusao.mp4'
file '$TEMP/norm_t4b_banco_narrativo.mp4'
file '$TEMP/norm_t_s3c_aponta_tela.mp4'
file '$TEMP/norm_t_s2c_bracos_cruzados.mp4'
# SC3 — WhatsApp cliente (Ken Burns + VO v2)
file '$TEMP/sc_s3_whatsapp.mp4'
# SC4 — Repositório terminal (Ken Burns + VO v2)
file '$TEMP/sc_s4_repo.mp4'
# SC5 — ffmpeg gerando (Ken Burns, silencioso)
file '$TEMP/sc_s3_ffmpeg.mp4'
# S4 Resultado — 3 takes
file '$TEMP/norm_t5_cta.mp4'
file '$TEMP/norm_t5b_municao.mp4'
file '$TEMP/norm_t_s4b_sorriso_canto.mp4'
# SC7 — WhatsApp resposta (Ken Burns + VO v2)
file '$TEMP/sc_s4_resposta.mp4'
# S5 CTA — 3 takes
file '$TEMP/norm_t_cta_a.mp4'
file '$TEMP/norm_t_cta_b.mp4'
file '$TEMP/norm_t_s5b_aponta_camera.mp4'
# Logo final (Ken Burns, silencioso)
file '$TEMP/sc_logo_final.mp4'
EOF

NSEG=$(grep -c '^file' "$TEMP/concat_v4c.txt")
echo "  ✓ Lista criada com $NSEG segmentos"

# Calcular duração total estimada
total_dur=0
while IFS= read -r line; do
    if [[ "$line" == file* ]]; then
        f=$(echo "$line" | sed "s/file '//;s/'//")
        dur=$(ffprobe -v quiet -show_entries format=duration -of csv=p=0 "$f" 2>/dev/null)
        total_dur=$(echo "$total_dur + $dur" | bc)
    fi
done < "$TEMP/concat_v4c.txt"
echo "  ✓ Duração total estimada: $(echo "scale=1; $total_dur/60" | bc) min (${total_dur}s)"

# ----------------------------------------------------------
# ETAPA 4: Concatenar, upscale 2K e injetar marca d'água
# ----------------------------------------------------------
echo "[4/4] Concatenando e exportando vídeo final 2K..."

ffmpeg -y -f concat -safe 0 -i "$TEMP/concat_v4c.txt" \
    -c:v libx264 -preset medium -crf 18 -pix_fmt yuv420p \
    -c:a aac -b:a 192k \
    "$TEMP/video1_v4c_1280.mp4" 2>/dev/null

VIDEO_DUR=$(ffprobe -v quiet -show_entries format=duration -of csv=p=0 "$TEMP/video1_v4c_1280.mp4" 2>/dev/null)
echo "  ✓ Vídeo base 1280x720: ${VIDEO_DUR}s"

# Upscale para 2560x1440 + marca d'água
if [ -f "$WATERMARK" ]; then
    ffmpeg -y \
        -i "$TEMP/video1_v4c_1280.mp4" \
        -i "$WATERMARK" \
        -filter_complex "
            [0:v]scale=2560:1440:flags=lanczos[scaled];
            [1:v]scale=180:-1[wm];
            [scaled][wm]overlay=W-w-40:H-h-40:format=auto,format=yuv420p[out]
        " \
        -map "[out]" -map 0:a \
        -c:v libx264 -preset medium -crf 18 \
        -c:a aac -b:a 192k \
        "$OUTPUT/video1_quebra_mitos_v4c_FINAL.mp4" 2>/dev/null
    echo "  ✓ Upscale 2560x1440 + marca d'água injetada"
else
    ffmpeg -y -i "$TEMP/video1_v4c_1280.mp4" \
        -vf "scale=2560:1440:flags=lanczos" \
        -c:v libx264 -preset medium -crf 18 -pix_fmt yuv420p \
        -c:a aac -b:a 192k \
        "$OUTPUT/video1_quebra_mitos_v4c_FINAL.mp4" 2>/dev/null
    echo "  ✓ Upscale 2560x1440 (sem marca d'água)"
fi

# ----------------------------------------------------------
# RELATÓRIO FINAL
# ----------------------------------------------------------
echo ""
echo "============================================"
echo "  MONTAGEM v4c CONCLUÍDA!"
echo "============================================"
DURATION=$(ffprobe -v quiet -show_entries format=duration -of csv=p=0 "$OUTPUT/video1_quebra_mitos_v4c_FINAL.mp4" 2>/dev/null)
DURATION_MIN=$(echo "scale=2; $DURATION/60" | bc)
SIZE=$(du -sh "$OUTPUT/video1_quebra_mitos_v4c_FINAL.mp4" | cut -f1)
echo "  Arquivo  : video1_quebra_mitos_v4c_FINAL.mp4"
echo "  Duração  : ${DURATION_MIN} min (${DURATION}s)"
echo "  Tamanho  : $SIZE"
echo "  Resolução: 2560x1440 (YouTube 2K)"
echo "  Takes TH : 17 únicos, lip sync nativo"
echo "  SCs      : Ken Burns (zoom dinâmico)"
echo "  VO SCs   : v2 (Fenrir assertivo)"
echo "============================================"

# Verificar silêncio final
echo ""
echo "Verificando silêncio final..."
SILENCE=$(ffmpeg -i "$OUTPUT/video1_quebra_mitos_v4c_FINAL.mp4" -af silencedetect=noise=-35dB:d=2.0 -f null - 2>&1 | grep "silence_start" | tail -1)
if [ -n "$SILENCE" ]; then
    echo "  ⚠️  Silêncio longo detectado: $SILENCE"
else
    echo "  ✓ Sem silêncio longo detectado"
fi

rm -rf "$TEMP"
echo "  Temporários removidos."
