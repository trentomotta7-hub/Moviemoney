#!/bin/bash
# Script de montagem: GC Sunscreen Stick SPF 50+ — v2 (lip sync real)
# Sessão 16 — 05/08/2026
# CORREÇÃO: takes gerados com generate_audio=True — áudio nativo = lip sync real

set -e

TAKES_DIR="/home/ubuntu/Moviemoney/skill-movie-money/criativos/sunscreen_stick_spf/GC/takes"
MONTAGEM_DIR="/home/ubuntu/Moviemoney/skill-movie-money/criativos/sunscreen_stick_spf/GC/montagem"

echo "=== FASE 1: Normalizar takes v2 para 720x1280, 30fps (MANTENDO áudio nativo) ==="

for take in gc_v2_take1_hook gc_v2_take2_problema gc_v2_take3_solucao gc_v2_take4_cta; do
  echo "Normalizando $take..."
  ffmpeg -i "$TAKES_DIR/${take}.mp4" \
    -vf "scale=720:1280:force_original_aspect_ratio=decrease,pad=720:1280:(ow-iw)/2:(oh-ih)/2" \
    -r 30 -c:v libx264 -preset fast -crf 23 \
    -c:a aac -b:a 128k \
    -video_track_timescale 24000 \
    "$MONTAGEM_DIR/${take}_norm.mp4" -y 2>&1 | tail -1
done

echo ""
echo "=== FASE 2: Verificar drift em cada take normalizado ==="

for take in gc_v2_take1_hook gc_v2_take2_problema gc_v2_take3_solucao gc_v2_take4_cta; do
  V_DUR=$(ffprobe -v quiet -show_entries stream=duration -of csv=p=0 "$MONTAGEM_DIR/${take}_norm.mp4" | head -1)
  A_DUR=$(ffprobe -v quiet -show_entries stream=duration -of csv=p=0 "$MONTAGEM_DIR/${take}_norm.mp4" | tail -1)
  DRIFT=$(python3 -c "print(abs(float('${V_DUR}') - float('${A_DUR}')))")
  STATUS=$(python3 -c "print('APROVADO' if abs(float('${V_DUR}') - float('${A_DUR}')) < 0.1 else 'REPROVADO')")
  echo "$take: v=${V_DUR}s a=${A_DUR}s drift=${DRIFT}s => $STATUS"
done

echo ""
echo "=== FASE 3: Concatenar takes v2 (vídeo + áudio nativo juntos) ==="

cat > "$MONTAGEM_DIR/concat_gc_v2.txt" << EOF
file 'gc_v2_take1_hook_norm.mp4'
file 'gc_v2_take2_problema_norm.mp4'
file 'gc_v2_take3_solucao_norm.mp4'
file 'gc_v2_take4_cta_norm.mp4'
EOF

ffmpeg -f concat -safe 0 -i "$MONTAGEM_DIR/concat_gc_v2.txt" \
  -c:v libx264 -preset fast -crf 22 \
  -c:a aac -b:a 128k \
  -pix_fmt yuv420p \
  -video_track_timescale 24000 \
  "$MONTAGEM_DIR/video_com_audio_v2.mp4" -y 2>&1 | tail -2

echo "Concatenação concluída."

echo ""
echo "=== FASE 4: Normalizar áudio (-16 LUFS) ==="

ffmpeg -i "$MONTAGEM_DIR/video_com_audio_v2.mp4" \
  -af "loudnorm=I=-16:TP=-1.5:LRA=11" \
  -c:v copy \
  "$MONTAGEM_DIR/video_normalizado_v2.mp4" -y 2>&1 | tail -2

echo ""
echo "=== FASE 5: Marca d'água + overlay de preço ==="

# Total: 5+9+10+8 = 32s. CTA começa em ~24s (5+9+10=24s)
ffmpeg -i "$MONTAGEM_DIR/video_normalizado_v2.mp4" \
  -vf "drawtext=text='MOVIE MONEY':x=w-tw-20:y=h-th-20:fontsize=18:fontcolor=white:alpha=0.5,drawtext=text='R34,90 | SPF 50+':x=(w-tw)/2:y=h-th-80:fontsize=30:fontcolor=white:alpha=0.95:enable='gte(t,24)'" \
  -c:a copy \
  "$MONTAGEM_DIR/sunscreen_stick_marina_GC_v2.mp4" -y 2>&1 | tail -2

echo ""
echo "=== PROTOCOLO FORENSE — VERIFICAÇÃO AUTOMÁTICA ==="

# Passo 1: Drift
V_DUR=$(ffprobe -v quiet -show_entries stream=duration -of csv=p=0 "$MONTAGEM_DIR/sunscreen_stick_marina_GC_v2.mp4" | head -1)
A_DUR=$(ffprobe -v quiet -show_entries stream=duration -of csv=p=0 "$MONTAGEM_DIR/sunscreen_stick_marina_GC_v2.mp4" | tail -1)
echo "Drift: v=${V_DUR}s a=${A_DUR}s"
python3 -c "drift=abs(float('${V_DUR}')-float('${A_DUR}')); print(f'Drift: {drift:.3f}s => ' + ('APROVADO' if drift < 0.1 else 'REPROVADO'))"

# Passo 2: Cauda morta
echo "Verificando cauda morta..."
ffmpeg -i "$MONTAGEM_DIR/sunscreen_stick_marina_GC_v2.mp4" -af silencedetect=noise=-35dB:d=0.3 -f null - 2>&1 | grep silence_start | tail -3

echo ""
echo "=== CONCLUÍDO ==="
ls -lh "$MONTAGEM_DIR/sunscreen_stick_marina_GC_v2.mp4"
ffprobe -v quiet -show_entries format=duration,size -of csv=p=0 "$MONTAGEM_DIR/sunscreen_stick_marina_GC_v2.mp4"
