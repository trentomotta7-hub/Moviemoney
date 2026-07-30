#!/bin/bash
# montar_video.sh — Pipeline de montagem Movie Money
# Uso: ./montar_video.sh <pasta_takes> <output_final.mp4>
# Exemplo: ./montar_video.sh /tmp/takes/ /tmp/criativo_final.mp4
#
# O que faz:
#   1. Concatena todos os takes .mp4 da pasta em ordem alfabética
#   2. Faz upscale para 1080x1920 (TikTok premium — favorecido pelo algoritmo)
#   3. Gera transcrição com word timestamps via Whisper
#   4. Gera legendas ASS karaokê com highlight amarelo palavra a palavra
#   5. Renderiza vídeo final com legendas queimadas

set -e

TAKES_DIR="${1:?Informe a pasta com os takes}"
OUTPUT="${2:?Informe o arquivo de saída}"
WORKDIR="$(dirname "$OUTPUT")"
BASENAME="$(basename "$OUTPUT" .mp4)"

echo "=== Movie Money — Pipeline de Montagem ==="
echo "Takes: $TAKES_DIR"
echo "Output: $OUTPUT"
echo ""

# ── PASSO 1: Gerar lista de concatenação ──────────────────────────────────────
CONCAT_LIST="$WORKDIR/${BASENAME}_concat.txt"
ls "$TAKES_DIR"/*.mp4 | sort | while read f; do
    echo "file '$f'"
done > "$CONCAT_LIST"
echo "[1/5] Lista de takes gerada: $(wc -l < "$CONCAT_LIST") takes"

# ── PASSO 2: Concatenar takes ─────────────────────────────────────────────────
RAW_MP4="$WORKDIR/${BASENAME}_raw.mp4"
ffmpeg -y -f concat -safe 0 -i "$CONCAT_LIST" \
    -c:v libx264 -c:a aac \
    -loglevel error \
    "$RAW_MP4"
echo "[2/5] Takes concatenados: $RAW_MP4"

# ── PASSO 3: Upscale para 1080x1920 (TikTok premium) ─────────────────────────
UPSCALED_MP4="$WORKDIR/${BASENAME}_1080p.mp4"
ffmpeg -y -i "$RAW_MP4" \
    -vf "scale=1080:1920:force_original_aspect_ratio=decrease,pad=1080:1920:(ow-iw)/2:(oh-ih)/2:black" \
    -c:v libx264 -preset slow -crf 18 \
    -c:a aac -b:a 192k \
    -r 30 \
    -loglevel error \
    "$UPSCALED_MP4"
echo "[3/5] Upscale 1080p concluído: $UPSCALED_MP4"

# ── PASSO 4: Transcrição com word timestamps ──────────────────────────────────
TRANSCRIPT_JSON="$WORKDIR/${BASENAME}_words.json"
python3 /home/ubuntu/skills/movie-money/scripts/transcrever_palavras.py \
    "$UPSCALED_MP4" "$TRANSCRIPT_JSON"
echo "[4/5] Transcrição com word timestamps: $TRANSCRIPT_JSON"

# ── PASSO 5: Gerar ASS karaokê e renderizar ───────────────────────────────────
ASS_FILE="$WORKDIR/${BASENAME}.ass"
python3 /home/ubuntu/skills/movie-money/scripts/gerar_karaoke_preciso.py \
    "$TRANSCRIPT_JSON" "$ASS_FILE"

ffmpeg -y -i "$UPSCALED_MP4" \
    -vf "ass=$ASS_FILE" \
    -c:v libx264 -preset slow -crf 18 \
    -c:a copy \
    -loglevel error \
    "$OUTPUT"
echo "[5/5] Vídeo final com legendas karaokê: $OUTPUT"

# ── Limpeza de intermediários ─────────────────────────────────────────────────
rm -f "$CONCAT_LIST" "$RAW_MP4" "$UPSCALED_MP4"
echo ""
echo "=== Concluído! ==="
ffprobe -v quiet -show_entries format=duration,size,bit_rate \
    -show_entries stream=width,height,r_frame_rate,codec_name \
    -of default=noprint_wrappers=1 "$OUTPUT" 2>/dev/null | grep -E "(width|height|r_frame_rate|codec_name|duration|size)"
