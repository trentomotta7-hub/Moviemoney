#!/bin/bash
# Script de montagem: GC Sunscreen Stick SPF 50+ — v1
# Sessão 16 — 05/08/2026

set -e

TAKES_DIR="/home/ubuntu/Moviemoney/skill-movie-money/criativos/sunscreen_stick_spf/GC/takes"
AUDIO_DIR="/home/ubuntu/Moviemoney/skill-movie-money/criativos/sunscreen_stick_spf/GC/audio"
MONTAGEM_DIR="/home/ubuntu/Moviemoney/skill-movie-money/criativos/sunscreen_stick_spf/GC/montagem"

echo "=== FASE 1: Normalizar takes para 720x1280, 30fps ==="

for take in gc_take1_hook gc_take2_problema gc_take3_solucao gc_take4_cta; do
  echo "Normalizando $take..."
  ffmpeg -i "$TAKES_DIR/${take}.mp4" \
    -vf "scale=720:1280:force_original_aspect_ratio=decrease,pad=720:1280:(ow-iw)/2:(oh-ih)/2" \
    -r 30 -c:v libx264 -preset fast -crf 23 \
    -an \
    "$MONTAGEM_DIR/${take}_norm.mp4" -y 2>&1 | tail -1
done

echo ""
echo "=== FASE 2: Concatenar com crossfade 0.3s entre takes ==="

# Duração de cada take normalizado
T1=$(ffprobe -v quiet -show_entries format=duration -of csv=p=0 "$MONTAGEM_DIR/gc_take1_hook_norm.mp4")
T2=$(ffprobe -v quiet -show_entries format=duration -of csv=p=0 "$MONTAGEM_DIR/gc_take2_problema_norm.mp4")
T3=$(ffprobe -v quiet -show_entries format=duration -of csv=p=0 "$MONTAGEM_DIR/gc_take3_solucao_norm.mp4")
T4=$(ffprobe -v quiet -show_entries format=duration -of csv=p=0 "$MONTAGEM_DIR/gc_take4_cta_norm.mp4")

echo "Durações: T1=${T1}s T2=${T2}s T3=${T3}s T4=${T4}s"

# Concatenação simples com lista (crossfade via xfade filter é complexo, usar concat direto)
cat > "$MONTAGEM_DIR/concat_gc.txt" << EOF
file 'gc_take1_hook_norm.mp4'
file 'gc_take2_problema_norm.mp4'
file 'gc_take3_solucao_norm.mp4'
file 'gc_take4_cta_norm.mp4'
EOF

ffmpeg -f concat -safe 0 -i "$MONTAGEM_DIR/concat_gc.txt" \
  -c:v libx264 -preset fast -crf 22 \
  -pix_fmt yuv420p \
  -video_track_timescale 24000 \
  "$MONTAGEM_DIR/video_sem_audio.mp4" -y 2>&1 | tail -2

echo "Concatenação concluída."

echo ""
echo "=== FASE 3: Adicionar áudio da Marina (Sulafat, 38.5s) ==="

ffmpeg -i "$MONTAGEM_DIR/video_sem_audio.mp4" \
  -i "$AUDIO_DIR/marina_gc_38s.wav" \
  -map 0:v -map 1:a \
  -c:v copy -c:a aac -b:a 128k \
  -shortest \
  "$MONTAGEM_DIR/video_com_audio.mp4" -y 2>&1 | tail -2

echo ""
echo "=== FASE 4: Normalizar áudio (-16 LUFS) ==="

ffmpeg -i "$MONTAGEM_DIR/video_com_audio.mp4" \
  -af "loudnorm=I=-16:TP=-1.5:LRA=11" \
  -c:v copy \
  "$MONTAGEM_DIR/video_normalizado.mp4" -y 2>&1 | tail -2

echo ""
echo "=== FASE 5: Marca d'água + overlay de preço no take 4 ==="

# Total de vídeo: ~30s. Take 4 começa em ~23s (5+8+10=23s)
ffmpeg -i "$MONTAGEM_DIR/video_normalizado.mp4" \
  -vf "drawtext=text='MOVIE MONEY':x=w-tw-20:y=h-th-20:fontsize=18:fontcolor=white:alpha=0.5,drawtext=text='R34,90 | SPF 50+':x=(w-tw)/2:y=h-th-80:fontsize=30:fontcolor=white:alpha=0.95:enable='gte(t,23)'" \
  -c:a copy \
  "$MONTAGEM_DIR/sunscreen_stick_marina_GC_v1.mp4" -y 2>&1 | tail -2

echo ""
echo "=== CONCLUÍDO ==="
ls -lh "$MONTAGEM_DIR/sunscreen_stick_marina_GC_v1.mp4"
ffprobe -v quiet -show_entries format=duration,size -of csv=p=0 "$MONTAGEM_DIR/sunscreen_stick_marina_GC_v1.mp4"
