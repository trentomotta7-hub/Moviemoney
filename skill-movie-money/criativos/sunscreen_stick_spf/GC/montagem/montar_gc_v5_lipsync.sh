#!/bin/bash
# Script de montagem: GC Sunscreen Stick SPF 50+ — v5 LIP SYNC REAL
# Sessão 16 — 05/08/2026
# MÉTODO: takes com generate_audio=True + texto exato do roteiro = lip sync nativo

set -e

TAKES_DIR="/home/ubuntu/Moviemoney/skill-movie-money/criativos/sunscreen_stick_spf/GC/takes"
MONTAGEM_DIR="/home/ubuntu/Moviemoney/skill-movie-money/criativos/sunscreen_stick_spf/GC/montagem"

echo "=== FASE 1: Normalizar takes para 720x1280, 30fps (MANTENDO áudio nativo) ==="

for take in take1_hook take2_problema take3_solucao take4_cta; do
  echo "Normalizando $take..."
  ffmpeg -i "$TAKES_DIR/${take}.mp4" \
    -vf "scale=720:1280:force_original_aspect_ratio=decrease,pad=720:1280:(ow-iw)/2:(oh-ih)/2" \
    -r 30 -c:v libx264 -preset fast -crf 22 \
    -c:a aac -b:a 128k \
    -video_track_timescale 24000 \
    "$MONTAGEM_DIR/${take}_norm.mp4" -y 2>&1 | tail -1
done

echo ""
echo "=== FASE 2: Verificar drift em cada take normalizado ==="

for take in take1_hook take2_problema take3_solucao take4_cta; do
  V_DUR=$(ffprobe -v quiet -show_entries stream=duration -of csv=p=0 "$MONTAGEM_DIR/${take}_norm.mp4" | head -1)
  A_DUR=$(ffprobe -v quiet -show_entries stream=duration -of csv=p=0 "$MONTAGEM_DIR/${take}_norm.mp4" | tail -1)
  STATUS=$(python3 -c "drift=abs(float('${V_DUR}')-float('${A_DUR}')); print(f'drift={drift:.3f}s => ' + ('APROVADO' if drift < 0.1 else 'REPROVADO'))")
  echo "$take: v=${V_DUR}s a=${A_DUR}s | $STATUS"
done

echo ""
echo "=== FASE 3: Concatenar takes (vídeo + áudio nativo juntos) ==="

cat > "$MONTAGEM_DIR/concat_v5.txt" << EOF
file 'take1_hook_norm.mp4'
file 'take2_problema_norm.mp4'
file 'take3_solucao_norm.mp4'
file 'take4_cta_norm.mp4'
EOF

ffmpeg -f concat -safe 0 -i "$MONTAGEM_DIR/concat_v5.txt" \
  -c:v libx264 -preset fast -crf 21 \
  -c:a aac -b:a 128k \
  -pix_fmt yuv420p \
  -video_track_timescale 24000 \
  "$MONTAGEM_DIR/video_concat_v5.mp4" -y 2>&1 | tail -2

VIDEO_DUR=$(ffprobe -v quiet -show_entries format=duration -of csv=p=0 "$MONTAGEM_DIR/video_concat_v5.mp4")
echo "Vídeo concatenado: ${VIDEO_DUR}s"

echo ""
echo "=== FASE 4: Normalizar áudio (-16 LUFS) ==="

ffmpeg -i "$MONTAGEM_DIR/video_concat_v5.mp4" \
  -af "loudnorm=I=-16:TP=-1.5:LRA=11" \
  -c:v copy \
  "$MONTAGEM_DIR/video_normalizado_v5.mp4" -y 2>&1 | tail -2

echo ""
echo "=== FASE 5: Marca d'água + overlay de preço no take 4 (a partir de ~24s) ==="

# Total: 5+9+10+9 = 33s. Take 4 começa em ~24s (5+9+10=24s)
ffmpeg -i "$MONTAGEM_DIR/video_normalizado_v5.mp4" \
  -vf "drawtext=text='MOVIE MONEY':x=w-tw-20:y=h-th-20:fontsize=18:fontcolor=white:alpha=0.5,drawtext=text='R34,90 | SPF 50+':x=(w-tw)/2:y=h-th-80:fontsize=30:fontcolor=white:alpha=0.95:enable='gte(t,24)'" \
  -c:a copy \
  "$MONTAGEM_DIR/sunscreen_stick_marina_GC_v5_FINAL.mp4" -y 2>&1 | tail -2

echo ""
echo "=== PROTOCOLO FORENSE AUTOMÁTICO ==="

# Drift final
V_DUR=$(ffprobe -v quiet -show_entries stream=duration -of csv=p=0 "$MONTAGEM_DIR/sunscreen_stick_marina_GC_v5_FINAL.mp4" | head -1)
A_DUR=$(ffprobe -v quiet -show_entries stream=duration -of csv=p=0 "$MONTAGEM_DIR/sunscreen_stick_marina_GC_v5_FINAL.mp4" | tail -1)
python3 -c "drift=abs(float('${V_DUR}')-float('${A_DUR}')); print(f'Drift final: {drift:.3f}s => ' + ('APROVADO' if drift < 0.1 else 'REPROVADO'))"

# Cauda morta
echo "Verificando cauda morta..."
LAST_SILENCE=$(ffmpeg -i "$MONTAGEM_DIR/sunscreen_stick_marina_GC_v5_FINAL.mp4" \
  -af silencedetect=noise=-35dB:d=0.3 -f null - 2>&1 | grep silence_end | tail -1)
TOTAL_DUR=$(ffprobe -v quiet -show_entries format=duration -of csv=p=0 "$MONTAGEM_DIR/sunscreen_stick_marina_GC_v5_FINAL.mp4")
if [ -z "$LAST_SILENCE" ]; then
  echo "Cauda morta: APROVADO (sem silêncio > 0.3s)"
else
  LAST_END=$(echo "$LAST_SILENCE" | grep -oP 'silence_end: \K[0-9.]+')
  python3 -c "
total=${TOTAL_DUR}
last_end=${LAST_END}
tail=total-last_end
print(f'Último silêncio termina em {last_end:.2f}s | Total: {total:.2f}s | Cauda: {tail:.2f}s')
print('Cauda morta: APROVADO' if tail < 0.5 else f'Cauda morta: REPROVADO — cortar em {last_end:.1f}s')
"
fi

echo ""
echo "=== CONCLUÍDO ==="
ls -lh "$MONTAGEM_DIR/sunscreen_stick_marina_GC_v5_FINAL.mp4"
ffprobe -v quiet -show_entries format=duration,size -of csv=p=0 "$MONTAGEM_DIR/sunscreen_stick_marina_GC_v5_FINAL.mp4"
