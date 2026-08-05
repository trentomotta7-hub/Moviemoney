#!/bin/bash
# Script de montagem: GC Sunscreen Stick SPF 50+ — v3 (voice-over, sem lip sync falso)
# Sessão 16 — 05/08/2026
# ABORDAGEM: Takes sem fala + voice-over Sulafat em cima = sem lip sync falso

set -e

TAKES_DIR="/home/ubuntu/Moviemoney/skill-movie-money/criativos/sunscreen_stick_spf/GC/takes"
AUDIO_DIR="/home/ubuntu/Moviemoney/skill-movie-money/criativos/sunscreen_stick_spf/GC/audio"
MONTAGEM_DIR="/home/ubuntu/Moviemoney/skill-movie-money/criativos/sunscreen_stick_spf/GC/montagem"

echo "=== FASE 1: Normalizar takes v3 para 720x1280, 30fps (sem áudio) ==="

for take in gc_v3_take1_hook gc_v3_take2_problema gc_v3_take3_solucao gc_v3_take4_cta; do
  echo "Normalizando $take..."
  ffmpeg -i "$TAKES_DIR/${take}.mp4" \
    -vf "scale=720:1280:force_original_aspect_ratio=decrease,pad=720:1280:(ow-iw)/2:(oh-ih)/2" \
    -r 30 -c:v libx264 -preset fast -crf 23 \
    -an \
    "$MONTAGEM_DIR/${take}_norm.mp4" -y 2>&1 | tail -1
done

echo ""
echo "=== FASE 2: Concatenar takes v3 ==="

cat > "$MONTAGEM_DIR/concat_gc_v3.txt" << EOF
file 'gc_v3_take1_hook_norm.mp4'
file 'gc_v3_take2_problema_norm.mp4'
file 'gc_v3_take3_solucao_norm.mp4'
file 'gc_v3_take4_cta_norm.mp4'
EOF

ffmpeg -f concat -safe 0 -i "$MONTAGEM_DIR/concat_gc_v3.txt" \
  -c:v libx264 -preset fast -crf 22 \
  -pix_fmt yuv420p \
  -video_track_timescale 24000 \
  "$MONTAGEM_DIR/video_sem_audio_v3.mp4" -y 2>&1 | tail -2

VIDEO_DUR=$(ffprobe -v quiet -show_entries format=duration -of csv=p=0 "$MONTAGEM_DIR/video_sem_audio_v3.mp4")
echo "Vídeo concatenado: ${VIDEO_DUR}s"

echo ""
echo "=== FASE 3: Adicionar voice-over Sulafat (38.5s) ==="

ffmpeg -i "$MONTAGEM_DIR/video_sem_audio_v3.mp4" \
  -i "$AUDIO_DIR/marina_gc_38s.wav" \
  -map 0:v -map 1:a \
  -c:v copy -c:a aac -b:a 128k \
  -shortest \
  "$MONTAGEM_DIR/video_com_vo_v3.mp4" -y 2>&1 | tail -2

echo ""
echo "=== FASE 4: Normalizar áudio (-16 LUFS) ==="

ffmpeg -i "$MONTAGEM_DIR/video_com_vo_v3.mp4" \
  -af "loudnorm=I=-16:TP=-1.5:LRA=11" \
  -c:v copy \
  "$MONTAGEM_DIR/video_normalizado_v3.mp4" -y 2>&1 | tail -2

echo ""
echo "=== FASE 5: Marca d'água + overlay de preço ==="

# Total: 5+9+10+8 = 32s. CTA começa em ~24s
ffmpeg -i "$MONTAGEM_DIR/video_normalizado_v3.mp4" \
  -vf "drawtext=text='MOVIE MONEY':x=w-tw-20:y=h-th-20:fontsize=18:fontcolor=white:alpha=0.5,drawtext=text='R34,90 | SPF 50+':x=(w-tw)/2:y=h-th-80:fontsize=30:fontcolor=white:alpha=0.95:enable='gte(t,24)'" \
  -c:a copy \
  "$MONTAGEM_DIR/sunscreen_stick_marina_GC_v3.mp4" -y 2>&1 | tail -2

echo ""
echo "=== PROTOCOLO FORENSE AUTOMÁTICO ==="

# Drift
V_DUR=$(ffprobe -v quiet -show_entries stream=duration -of csv=p=0 "$MONTAGEM_DIR/sunscreen_stick_marina_GC_v3.mp4" | head -1)
A_DUR=$(ffprobe -v quiet -show_entries stream=duration -of csv=p=0 "$MONTAGEM_DIR/sunscreen_stick_marina_GC_v3.mp4" | tail -1)
python3 -c "drift=abs(float('${V_DUR}')-float('${A_DUR}')); print(f'Drift: {drift:.3f}s => ' + ('APROVADO' if drift < 0.1 else 'REPROVADO'))"

# Cauda morta
echo "Verificando cauda morta..."
SILENCE=$(ffmpeg -i "$MONTAGEM_DIR/sunscreen_stick_marina_GC_v3.mp4" -af silencedetect=noise=-35dB:d=0.3 -f null - 2>&1 | grep silence_start | tail -1)
if [ -z "$SILENCE" ]; then
  echo "Cauda morta: APROVADO (sem silêncio > 0.3s)"
else
  echo "Cauda morta detectada: $SILENCE — VERIFICAR"
fi

echo ""
echo "=== CONCLUÍDO ==="
ls -lh "$MONTAGEM_DIR/sunscreen_stick_marina_GC_v3.mp4"
ffprobe -v quiet -show_entries format=duration,size -of csv=p=0 "$MONTAGEM_DIR/sunscreen_stick_marina_GC_v3.mp4"
