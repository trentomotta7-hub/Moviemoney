#!/bin/bash
# Script de montagem: POV Sunscreen Stick SPF 50+ — v1
# Sessão 16 — 05/08/2026

set -e

TAKES_DIR="/home/ubuntu/Moviemoney/skill-movie-money/criativos/sunscreen_stick_spf/POV/takes"
AUDIO_DIR="/home/ubuntu/Moviemoney/skill-movie-money/criativos/sunscreen_stick_spf/POV/audio"
MONTAGEM_DIR="/home/ubuntu/Moviemoney/skill-movie-money/criativos/sunscreen_stick_spf/POV/montagem"

echo "=== FASE 1: Normalizar takes para resolução e codec consistentes ==="

# Normalizar todos os takes para 720x1280, 30fps, aac
for take in beat1_hook_raw beat2_problema_raw beat3_causa_raw beat4_solucao_raw beat5_cta_raw; do
  echo "Normalizando $take..."
  ffmpeg -i "$TAKES_DIR/${take}.mp4" \
    -vf "scale=720:1280:force_original_aspect_ratio=decrease,pad=720:1280:(ow-iw)/2:(oh-ih)/2" \
    -r 30 -c:v libx264 -preset fast -crf 23 \
    -an \
    "$MONTAGEM_DIR/${take}_norm.mp4" -y 2>&1 | tail -1
done

echo ""
echo "=== FASE 2: Criar lista de concatenação ==="

cat > "$MONTAGEM_DIR/concat_list.txt" << EOF
file 'beat1_hook_raw_norm.mp4'
file 'beat2_problema_raw_norm.mp4'
file 'beat3_causa_raw_norm.mp4'
file 'beat4_solucao_raw_norm.mp4'
file 'beat5_cta_raw_norm.mp4'
EOF

echo "Lista criada."

echo ""
echo "=== FASE 3: Concatenar vídeos ==="

ffmpeg -f concat -safe 0 -i "$MONTAGEM_DIR/concat_list.txt" \
  -c:v libx264 -preset fast -crf 22 \
  -pix_fmt yuv420p \
  -video_track_timescale 24000 \
  "$MONTAGEM_DIR/video_sem_audio.mp4" -y 2>&1 | tail -2

echo "Concatenação concluída."

echo ""
echo "=== FASE 4: Adicionar áudio da Marina ==="

# Duração do vídeo concatenado
VIDEO_DUR=$(ffprobe -v quiet -show_entries format=duration -of csv=p=0 "$MONTAGEM_DIR/video_sem_audio.mp4")
echo "Duração do vídeo: ${VIDEO_DUR}s"

# Usar áudio 1.8x (34.5s) e cortar para a duração do vídeo
ffmpeg -i "$MONTAGEM_DIR/video_sem_audio.mp4" \
  -i "$AUDIO_DIR/marina_voz_1_8x.wav" \
  -map 0:v -map 1:a \
  -c:v copy -c:a aac -b:a 128k \
  -shortest \
  "$MONTAGEM_DIR/video_com_audio.mp4" -y 2>&1 | tail -2

echo "Áudio adicionado."

echo ""
echo "=== FASE 5: Normalizar áudio (-16 LUFS) ==="

ffmpeg -i "$MONTAGEM_DIR/video_com_audio.mp4" \
  -af "loudnorm=I=-16:TP=-1.5:LRA=11" \
  -c:v copy \
  "$MONTAGEM_DIR/video_normalizado.mp4" -y 2>&1 | tail -2

echo "Normalização concluída."

echo ""
echo "=== FASE 6: Adicionar marca d'água e overlay de preço ==="

ffmpeg -i "$MONTAGEM_DIR/video_normalizado.mp4" \
  -vf "drawtext=text='MOVIE MONEY':x=w-tw-20:y=h-th-20:fontsize=18:fontcolor=white:alpha=0.6:font='DejaVu Sans',\
       drawtext=text='R\$34,90 | SPF 50+':x=(w-tw)/2:y=h-th-80:fontsize=28:fontcolor=white:fontweight=bold:alpha=0.9:font='DejaVu Sans':enable='gte(t,26)'" \
  -c:a copy \
  "$MONTAGEM_DIR/sunscreen_stick_spf_pov_v1_FINAL.mp4" -y 2>&1 | tail -2

echo ""
echo "=== CONCLUÍDO ==="
ffprobe -v quiet -show_entries format=duration,size -of csv=p=0 "$MONTAGEM_DIR/sunscreen_stick_spf_pov_v1_FINAL.mp4"
echo "Arquivo: $MONTAGEM_DIR/sunscreen_stick_spf_pov_v1_FINAL.mp4"
