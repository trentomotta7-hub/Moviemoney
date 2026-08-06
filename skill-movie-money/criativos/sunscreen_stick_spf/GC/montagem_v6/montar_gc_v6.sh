#!/bin/bash
# GC Sunscreen Stick v6 — áudio nativo + lip sync preservado
set -euo pipefail

ROOT="/home/ubuntu/Moviemoney/skill-movie-money/criativos/sunscreen_stick_spf/GC"
TAKES="$ROOT/takes_v6"
OUT="$ROOT/montagem_v6"
mkdir -p "$OUT/norm"

normalize_take() {
  local input="$1"
  local output="$2"
  local start="$3"
  local duration="$4"
  ffmpeg -hide_banner -loglevel error -ss "$start" -i "$input" -t "$duration" \
    -vf "scale=720:1280:force_original_aspect_ratio=decrease,pad=720:1280:(ow-iw)/2:(oh-ih)/2,fps=30" \
    -af "aresample=async=1:first_pts=0" \
    -c:v libx264 -preset fast -crf 21 -pix_fmt yuv420p \
    -c:a aac -b:a 128k -ar 48000 \
    -video_track_timescale 24000 \
    "$output" -y
}

normalize_take "$TAKES/take1_hook_ptbr_native.mp4" "$OUT/norm/01_hook.mp4" 0.8 5.3
normalize_take "$TAKES/take2_problema_ptbr_native.mp4" "$OUT/norm/02_problema.mp4" 0.0 9.8
normalize_take "$TAKES/take3a_solucao_demo_ptbr_native.mp4" "$OUT/norm/03_solucao_demo.mp4" 0.0 9.9
normalize_take "$TAKES/take3b1_make_ptbr_native.mp4" "$OUT/norm/04_make.mp4" 0.4 2.5
normalize_take "$TAKES/take3b2_portabilidade_ptbr_native.mp4" "$OUT/norm/05_portabilidade.mp4" 0.0 6.5
normalize_take "$TAKES/take4a_oferta_ptbr_native.mp4" "$OUT/norm/06_oferta.mp4" 0.0 8.5
normalize_take "$TAKES/take4b_cta_ptbr_native.mp4" "$OUT/norm/07_cta.mp4" 0.1 6.0

cat > "$OUT/concat_v6.txt" <<'LIST'
file 'norm/01_hook.mp4'
file 'norm/02_problema.mp4'
file 'norm/03_solucao_demo.mp4'
file 'norm/04_make.mp4'
file 'norm/05_portabilidade.mp4'
file 'norm/06_oferta.mp4'
file 'norm/07_cta.mp4'
LIST

ffmpeg -hide_banner -loglevel error -f concat -safe 0 -i "$OUT/concat_v6.txt" \
  -c:v libx264 -preset fast -crf 21 -pix_fmt yuv420p \
  -c:a aac -b:a 128k -ar 48000 -video_track_timescale 24000 \
  "$OUT/video_concat_v6.mp4" -y

# Acelera áudio e vídeo juntos para preservar o lip sync e manter duração comercial.
ffmpeg -hide_banner -loglevel error -i "$OUT/video_concat_v6.mp4" \
  -filter_complex "[0:v]setpts=PTS/1.20[v];[0:a]atempo=1.20[a]" \
  -map "[v]" -map "[a]" \
  -c:v libx264 -preset fast -crf 21 -pix_fmt yuv420p \
  -c:a aac -b:a 128k -ar 48000 -video_track_timescale 24000 \
  "$OUT/video_speed_v6.mp4" -y

# Overlay de oferta começa no bloco final; watermark discreto em todo o vídeo.
ffmpeg -hide_banner -loglevel error -i "$OUT/video_speed_v6.mp4" \
  -vf "drawtext=text='MOVIE MONEY':x=w-tw-20:y=h-th-20:fontsize=18:fontcolor=white:alpha=0.55:font='DejaVu Sans',drawbox=x=105:y=h-175:w=510:h=62:color=black@0.55:t=fill:enable='gte(t,33)',drawtext=text='R\$ 34,90 | SPF 50+':x=(w-tw)/2:y=h-160:fontsize=32:fontcolor=white:alpha=0.98:font='DejaVu Sans':enable='gte(t,33)'" \
  -af "loudnorm=I=-16:TP=-1.5:LRA=11" \
  -c:v libx264 -preset fast -crf 21 -pix_fmt yuv420p \
  -c:a aac -b:a 128k -ar 48000 -video_track_timescale 24000 \
  -shortest "$OUT/sunscreen_stick_marina_GC_v6_FINAL.mp4" -y

ffprobe -v error -show_entries format=duration,size:stream=index,codec_type,codec_name,width,height,duration -of default=noprint_wrappers=1 "$OUT/sunscreen_stick_marina_GC_v6_FINAL.mp4"
