#!/usr/bin/env bash
# Extrai o áudio de cada take do Beto e concatena em uma trilha master contínua.
# Esta trilha será usada como o único áudio do vídeo final.

set -e
BASE="/home/ubuntu/Moviemoney/skill-movie-money/criativos/video_institucional_youtube"
TAKES="$BASE/takes_v2"
OUT="$BASE/audio_master"
mkdir -p "$OUT"

echo "Extraindo áudio de cada take do Beto..."

extract() {
    local src="$1" dst="$2"
    ffmpeg -y -i "$src" -vn -ar 48000 -ac 2 -acodec pcm_s16le "$dst" 2>/dev/null
    local dur; dur=$(ffprobe -v quiet -show_entries format=duration -of csv=p=0 "$dst" 2>/dev/null)
    printf "  ✓ %-40s  %.2fs\n" "$(basename $dst)" "$dur"
}

extract "$TAKES/v2_t1a_hook_matematico.mp4"      "$OUT/a_t1a.wav"
extract "$TAKES/v2_t1b_algoritmo_pune.mp4"       "$OUT/a_t1b.wav"
extract "$TAKES/v2_t1c_caixa_preta.mp4"          "$OUT/a_t1c.wav"
extract "$TAKES/v2_t1d_maquina_faz.mp4"          "$OUT/a_t1d.wav"
extract "$TAKES/v2_t2a_elenco_nunca_atrasa.mp4"  "$OUT/a_t2a.wav"
extract "$TAKES/v2_t2b_voce_gerencia.mp4"        "$OUT/a_t2b.wav"
extract "$TAKES/v2_t3a_cereja_bolo.mp4"          "$OUT/a_t3a.wav"
extract "$TAKES/v2_t3b_engenharia_conversao.mp4" "$OUT/a_t3b.wav"
extract "$TAKES/v2_t4a_voce_viu_maquina.mp4"     "$OUT/a_t4a.wav"
extract "$TAKES/v2_t4b_boa_noticia.mp4"          "$OUT/a_t4b.wav"
extract "$TAKES/v2_t4c_proximo_video.mp4"        "$OUT/a_t4c.wav"

echo ""
echo "Concatenando trilha master..."

# Lista de concatenação de áudio
cat > "$OUT/concat_audio.txt" << EOF
file '$OUT/a_t1a.wav'
file '$OUT/a_t1b.wav'
file '$OUT/a_t1c.wav'
file '$OUT/a_t1d.wav'
file '$OUT/a_t2a.wav'
file '$OUT/a_t2b.wav'
file '$OUT/a_t3a.wav'
file '$OUT/a_t3b.wav'
file '$OUT/a_t4a.wav'
file '$OUT/a_t4b.wav'
file '$OUT/a_t4c.wav'
EOF

ffmpeg -y -f concat -safe 0 -i "$OUT/concat_audio.txt" \
    -ar 48000 -ac 2 -acodec pcm_s16le \
    "$OUT/beto_audio_master.wav" 2>/dev/null

DUR=$(ffprobe -v quiet -show_entries format=duration -of csv=p=0 "$OUT/beto_audio_master.wav" 2>/dev/null)
echo "  ✓ beto_audio_master.wav  — duração total: ${DUR}s"
echo "✅ Trilha master pronta."
