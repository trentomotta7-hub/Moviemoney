#!/bin/bash
# Montagem do Vídeo CEO Beto — Movie Money
# Abordagem psicológica: "As pessoas mentem que é fácil vender no TikTok Shop"
# Sessão 15 — 04/08/2026

set -e

BASE="/home/ubuntu/Moviemoney/skill-movie-money/criativos/video_beto_ceo"
TEMP="$BASE/temp_montagem"
OUT="$BASE/video_beto_ceo_v1_FINAL.mp4"
LOGO="/home/ubuntu/Moviemoney/skill-movie-money/templates/logo_watermark.png"

mkdir -p "$TEMP"

echo "=== PASSO 1: Normalizar takes (loudnorm -16 LUFS, 1280x720, 48kHz) ==="

normalize_take() {
    local input="$1"
    local output="$2"
    local label="$3"
    ffmpeg -y -i "$input" \
        -vf "scale=1280:720:force_original_aspect_ratio=decrease,pad=1280:720:(ow-iw)/2:(oh-ih)/2" \
        -af "loudnorm=I=-16:TP=-1.5:LRA=11,aresample=48000" \
        -c:v libx264 -preset medium -crf 20 -pix_fmt yuv420p \
        -c:a aac -b:a 192k -ar 48000 -ac 2 \
        -video_track_timescale 24000 \
        "$output" 2>/dev/null
    if [ -f "$output" ]; then
        dur=$(ffprobe -v quiet -show_entries format=duration -of csv=p=0 "$output")
        echo "  ✓ $label — ${dur}s"
    else
        echo "  ✗ FALHA: $label"
        return 1
    fi
}

normalize_take "$BASE/beto_ceo_take1_hook.mp4"    "$TEMP/01_take1_hook.mp4"    "Take 1 — Hook"
normalize_take "$BASE/beto_ceo_take2_verdade.mp4" "$TEMP/02_take2_verdade.mp4" "Take 2 — Verdade"
normalize_take "$BASE/beto_ceo_take3_solucao.mp4" "$TEMP/03_take3_solucao.mp4" "Take 3 — Solução"
normalize_take "$BASE/beto_ceo_take4_cta.mp4"     "$TEMP/04_take4_cta.mp4"     "Take 4 — CTA"

echo ""
echo "=== PASSO 2: Concatenar com re-encode completo ==="

cat > "$TEMP/concat_ceo.txt" << EOF
file '01_take1_hook.mp4'
file '02_take2_verdade.mp4'
file '03_take3_solucao.mp4'
file '04_take4_cta.mp4'
EOF

ffmpeg -y -f concat -safe 0 -i "$TEMP/concat_ceo.txt" \
    -c:v libx264 -preset medium -crf 20 -pix_fmt yuv420p \
    -c:a aac -b:a 192k -ar 48000 -ac 2 \
    -r 24 \
    -movflags +faststart \
    "$TEMP/video_sem_marca.mp4" 2>/dev/null

dur=$(ffprobe -v quiet -show_entries format=duration -of csv=p=0 "$TEMP/video_sem_marca.mp4")
echo "  ✓ Vídeo concatenado — ${dur}s ($(echo "scale=1; $dur/60" | bc) min)"

echo ""
echo "=== PASSO 3: Aplicar marca d'água ==="

# Verificar se logo existe
if [ -f "$LOGO" ]; then
    ffmpeg -y -i "$TEMP/video_sem_marca.mp4" -i "$LOGO" \
        -filter_complex "[1:v]scale=200:-1,format=rgba,colorchannelmixer=aa=0.7[logo];[0:v][logo]overlay=W-w-20:H-h-20" \
        -c:v libx264 -preset medium -crf 20 -pix_fmt yuv420p \
        -c:a copy \
        "$OUT" 2>/dev/null
    echo "  ✓ Marca d'água aplicada"
else
    # Sem logo: adicionar texto watermark
    ffmpeg -y -i "$TEMP/video_sem_marca.mp4" \
        -vf "drawtext=text='MOVIE MONEY':fontsize=18:fontcolor=white@0.6:x=W-tw-15:y=H-th-15:font=Arial:shadowcolor=black@0.8:shadowx=1:shadowy=1" \
        -c:v libx264 -preset medium -crf 20 -pix_fmt yuv420p \
        -c:a copy \
        "$OUT" 2>/dev/null
    echo "  ✓ Watermark texto aplicado (logo não encontrado)"
fi

echo ""
echo "=== RESULTADO FINAL ==="
ffprobe -v quiet -show_entries format=duration,size,bit_rate -of default "$OUT"
ls -lh "$OUT"

echo ""
echo "=== Verificação de áudio ==="
dur=$(ffprobe -v quiet -show_entries format=duration -of csv=p=0 "$OUT")
for pos in 2 12 22 30 35; do
    if (( $(echo "$pos < $dur" | bc -l) )); then
        vol=$(ffmpeg -i "$OUT" -ss $pos -t 3 -af volumedetect -f null /dev/null 2>&1 | grep "mean_volume" | awk '{print $5}')
        echo "  t=${pos}s: mean_volume=${vol}dB"
    fi
done

echo ""
echo "=== CONCLUÍDO: $OUT ==="
