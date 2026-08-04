#!/bin/bash
# === MONTAGEM VÍDEO CEO BETO v2 ===
# Correções: keyframe único, áudio separado com voz natural, crossfades, watermark
# Takes: 4 x 8s = 32s de vídeo | Narração: 76s
# Solução: loop dos takes para cobrir 76s de narração (9.5 loops de 8s)
# Melhor abordagem: usar os 4 takes em sequência com crossfade, depois repetir a sequência

set -e

DIR="/home/ubuntu/Moviemoney/skill-movie-money/criativos/video_beto_ceo"
TEMP="$DIR/temp_v2"
mkdir -p "$TEMP"

echo "=== MONTAGEM VÍDEO CEO BETO v2 ==="

# 1. Extrair vídeo sem áudio de cada take e normalizar
echo "[1/6] Extraindo vídeo sem áudio dos takes..."
for i in 1 2 3 4; do
  case $i in
    1) TAKE="v2_take1_hook" ;;
    2) TAKE="v2_take2_verdade" ;;
    3) TAKE="v2_take3_solucao" ;;
    4) TAKE="v2_take4_cta" ;;
  esac
  ffmpeg -y -i "$DIR/$TAKE.mp4" -an -c:v libx264 -preset medium -crf 18 -vf "scale=1280:720,fps=30" "$TEMP/take${i}_silent.mp4" 2>/dev/null
  echo "  ✓ Take $i processado"
done

# 2. Concatenar takes com crossfade (xfade transition)
echo "[2/6] Concatenando takes com crossfade..."
# Take 1 (8s) -> crossfade 0.5s -> Take 2 (8s) -> crossfade 0.5s -> Take 3 (8s) -> crossfade 0.5s -> Take 4 (8s)
# Total com crossfade: 8 + 7.5 + 7.5 + 7.5 = 30.5s por sequência
# Precisamos de 76s, então precisamos de ~2.5 sequências

# Primeira sequência: 4 takes com crossfade
ffmpeg -y \
  -i "$TEMP/take1_silent.mp4" \
  -i "$TEMP/take2_silent.mp4" \
  -i "$TEMP/take3_silent.mp4" \
  -i "$TEMP/take4_silent.mp4" \
  -filter_complex "
    [0:v][1:v]xfade=transition=fade:duration=0.5:offset=7.5[v01];
    [v01][2:v]xfade=transition=fade:duration=0.5:offset=15[v02];
    [v02][3:v]xfade=transition=fade:duration=0.5:offset=22.5[v03]
  " -map "[v03]" -c:v libx264 -preset medium -crf 18 "$TEMP/seq1.mp4" 2>/dev/null
echo "  ✓ Sequência 1 (30s) criada"

# Segunda sequência: 3 takes (take1, take2, take3) com crossfade
ffmpeg -y \
  -i "$TEMP/take1_silent.mp4" \
  -i "$TEMP/take2_silent.mp4" \
  -i "$TEMP/take3_silent.mp4" \
  -filter_complex "
    [0:v][1:v]xfade=transition=fade:duration=0.5:offset=7.5[v01];
    [v01][2:v]xfade=transition=fade:duration=0.5:offset=15[v02]
  " -map "[v02]" -c:v libx264 -preset medium -crf 18 "$TEMP/seq2.mp4" 2>/dev/null
echo "  ✓ Sequência 2 (22.5s) criada"

# Terceira sequência: 3 takes (take4, take1, take2) com crossfade
ffmpeg -y \
  -i "$TEMP/take4_silent.mp4" \
  -i "$TEMP/take1_silent.mp4" \
  -i "$TEMP/take2_silent.mp4" \
  -filter_complex "
    [0:v][1:v]xfade=transition=fade:duration=0.5:offset=7.5[v01];
    [v01][2:v]xfade=transition=fade:duration=0.5:offset=15[v02]
  " -map "[v02]" -c:v libx264 -preset medium -crf 18 "$TEMP/seq3.mp4" 2>/dev/null
echo "  ✓ Sequência 3 (22.5s) criada"

# 3. Concatenar sequências com crossfade para cobrir 76s
echo "[3/6] Concatenando sequências..."
# seq1 (30s) -> crossfade -> seq2 (22.5s) -> crossfade -> seq3 (22.5s) = ~74s
# Precisamos de mais 2s, então vamos estender o último take
ffmpeg -y \
  -i "$TEMP/seq1.mp4" \
  -i "$TEMP/seq2.mp4" \
  -i "$TEMP/seq3.mp4" \
  -filter_complex "
    [0:v][1:v]xfade=transition=fade:duration=0.5:offset=29.5[v01];
    [v01][2:v]xfade=transition=fade:duration=0.5:offset=51.5[v02]
  " -map "[v02]" -c:v libx264 -preset medium -crf 18 "$TEMP/video_full.mp4" 2>/dev/null
echo "  ✓ Vídeo completo montado"

# 4. Verificar duração do vídeo
VIDEO_DUR=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$TEMP/video_full.mp4")
AUDIO_DUR=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$DIR/beto_ceo_v2_voz.wav")
echo "  Vídeo: ${VIDEO_DUR}s | Áudio: ${AUDIO_DUR}s"

# 5. Ajustar vídeo para cobrir toda a narração (loop ou estender)
echo "[4/6] Ajustando duração do vídeo para cobrir a narração..."
# Se vídeo < áudio, precisamos estender. Se vídeo > áudio, cortamos.
# Usar -stream_loop para repetir o vídeo se necessário
ffmpeg -y \
  -stream_loop -1 -i "$TEMP/video_full.mp4" \
  -i "$DIR/beto_ceo_v2_voz.wav" \
  -filter_complex "
    [0:v]scale=1280:720,fps=30[v];
    [1:a]loudnorm=I=-16:TP=-1.5:LRA=11[a]
  " -map "[v]" -map "[a]" \
  -c:v libx264 -preset medium -crf 18 \
  -c:a aac -b:a 192k \
  -shortest \
  "$TEMP/video_com_audio.mp4" 2>/dev/null
echo "  ✓ Áudio sincronizado"

# 6. Adicionar watermark "MOVIE MONEY"
echo "[5/6] Adicionando watermark..."
ffmpeg -y \
  -i "$TEMP/video_com_audio.mp4" \
  -vf "
    drawtext=text='MOVIE MONEY':fontcolor=white@0.3:fontsize=24:x=w-tw-20:y=h-th-20:fontfile=/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf
  " -c:v libx264 -preset medium -crf 18 -c:a aac -b:a 192k \
  "$DIR/video_beto_ceo_v2_FINAL.mp4" 2>/dev/null
echo "  ✓ Watermark adicionada"

# Verificar resultado final
FINAL_DUR=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$DIR/video_beto_ceo_v2_FINAL.mp4")
FINAL_SIZE=$(du -h "$DIR/video_beto_ceo_v2_FINAL.mp4" | cut -f1)
echo ""
echo "=== RESULTADO FINAL ==="
echo "Arquivo: $DIR/video_beto_ceo_v2_FINAL.mp4"
echo "Duração: ${FINAL_DUR}s"
echo "Tamanho: $FINAL_SIZE"
echo "Resolução: 1280x720"
echo "Áudio: Voz natural (Algieba) com loudnorm -16 LUFS"
echo ""
echo "=== MONTAGEM CONCLUÍDA ==="
