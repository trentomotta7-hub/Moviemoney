#!/usr/bin/env bash
# Etapas 2-5 da montagem do Vídeo 2
# Normalizar TH + Concatenar + Marca d'água

set -e

BASE="/home/ubuntu/Moviemoney/skill-movie-money/criativos/video_institucional_youtube"
TAKES_V2="$BASE/takes_v2"
LOGO="/home/ubuntu/Moviemoney/skill-movie-money/templates/identidade_visual/logo_transparente.png"
TEMP="$BASE/temp_v2_montagem"
OUTPUT="$BASE"

# ----------------------------------------------------------
# ETAPA 2: Normalizar takes TH
# ----------------------------------------------------------
echo "[2/4] Normalizando takes de Talking Head..."

normalize_th() {
    local input="$1"
    local output="$2"
    ffmpeg -y -i "$input" \
        -vf "scale=1280:720:force_original_aspect_ratio=decrease,pad=1280:720:(ow-iw)/2:(oh-ih)/2" \
        -c:v libx264 -preset fast -crf 20 -pix_fmt yuv420p \
        -c:a aac -b:a 128k -ar 48000 -ac 2 \
        "$output" 2>/dev/null
    echo "  ✓ $(basename $output)"
}

normalize_th "$TAKES_V2/v2_t1a_hook_matematico.mp4"     "$TEMP/t1a_norm.mp4"
normalize_th "$TAKES_V2/v2_t1b_algoritmo_pune.mp4"      "$TEMP/t1b_norm.mp4"
normalize_th "$TAKES_V2/v2_t1c_caixa_preta.mp4"         "$TEMP/t1c_norm.mp4"
normalize_th "$TAKES_V2/v2_t1d_maquina_faz.mp4"         "$TEMP/t1d_norm.mp4"
normalize_th "$TAKES_V2/v2_t2a_elenco_nunca_atrasa.mp4" "$TEMP/t2a_norm.mp4"
normalize_th "$TAKES_V2/v2_t2b_voce_gerencia.mp4"       "$TEMP/t2b_norm.mp4"
normalize_th "$TAKES_V2/v2_t3a_cereja_bolo.mp4"         "$TEMP/t3a_norm.mp4"
normalize_th "$TAKES_V2/v2_t3b_engenharia_conversao.mp4" "$TEMP/t3b_norm.mp4"
normalize_th "$TAKES_V2/v2_t4a_voce_viu_maquina.mp4"    "$TEMP/t4a_norm.mp4"
normalize_th "$TAKES_V2/v2_t4b_boa_noticia.mp4"         "$TEMP/t4b_norm.mp4"
normalize_th "$TAKES_V2/v2_t4c_proximo_video.mp4"       "$TEMP/t4c_norm.mp4"

echo ""

# ----------------------------------------------------------
# ETAPA 3: Criar lista de concatenação
# ----------------------------------------------------------
echo "[3/4] Criando lista de concatenação..."

cat > "$TEMP/concat_v2.txt" << EOF
# SEÇÃO 1 — Hook da Prova Lógica
file '$TEMP/t1a_norm.mp4'
file '$TEMP/sc1_final.mp4'
file '$TEMP/t1b_norm.mp4'
file '$TEMP/t1c_norm.mp4'
file '$TEMP/t1d_norm.mp4'
# SEÇÃO 2 — A Arquitetura do Repositório
file '$TEMP/sc2_final.mp4'
file '$TEMP/sc3_final.mp4'
file '$TEMP/t2a_norm.mp4'
file '$TEMP/t2b_norm.mp4'
# SEÇÃO 3 — O Banco Narrativo
file '$TEMP/sc4_final.mp4'
file '$TEMP/sc5_final.mp4'
file '$TEMP/sc6_final.mp4'
# SEÇÃO 4 — Lip Sync e Safe Zone
file '$TEMP/t3a_norm.mp4'
file '$TEMP/sc7_final.mp4'
file '$TEMP/sc8_final.mp4'
file '$TEMP/t3b_norm.mp4'
# SEÇÃO 5 — CTA de Transição
file '$TEMP/t4a_norm.mp4'
file '$TEMP/t4b_norm.mp4'
file '$TEMP/t4c_norm.mp4'
file '$TEMP/sc9_logo.mp4'
EOF

TOTAL=$(grep -c '^file' "$TEMP/concat_v2.txt")
echo "  ✓ $TOTAL segmentos na lista"
echo ""

# ----------------------------------------------------------
# ETAPA 4: Concatenar e finalizar
# ----------------------------------------------------------
echo "[4/4] Concatenando vídeo final..."

ffmpeg -y \
    -f concat -safe 0 \
    -i "$TEMP/concat_v2.txt" \
    -c:v libx264 -preset medium -crf 18 -pix_fmt yuv420p \
    -c:a aac -b:a 192k -ar 48000 -ac 2 \
    "$TEMP/video2_sem_marca.mp4" 2>/dev/null

echo "  ✓ Vídeo base concatenado"

# Adicionar marca d'água
if [ -f "$LOGO" ]; then
    ffmpeg -y \
        -i "$TEMP/video2_sem_marca.mp4" \
        -i "$LOGO" \
        -filter_complex "[1:v]scale=150:-1[wm];[0:v][wm]overlay=W-w-30:H-h-30:format=auto,format=yuv420p" \
        -c:v libx264 -preset medium -crf 18 \
        -c:a aac -b:a 192k \
        "$OUTPUT/video2_maquina_por_dentro_v1_FINAL.mp4" 2>/dev/null
    echo "  ✓ Marca d'água aplicada"
else
    cp "$TEMP/video2_sem_marca.mp4" "$OUTPUT/video2_maquina_por_dentro_v1_FINAL.mp4"
    echo "  ⚠ Sem logo — exportando sem marca d'água"
fi

# Relatório
echo ""
echo "============================================"
DURATION=$(ffprobe -v quiet -show_entries format=duration -of csv=p=0 "$OUTPUT/video2_maquina_por_dentro_v1_FINAL.mp4" 2>/dev/null)
DURATION_MIN=$(echo "scale=2; $DURATION/60" | bc)
SIZE=$(du -sh "$OUTPUT/video2_maquina_por_dentro_v1_FINAL.mp4" | cut -f1)
echo "  Arquivo: video2_maquina_por_dentro_v1_FINAL.mp4"
echo "  Duração: ${DURATION_MIN} min (${DURATION}s)"
echo "  Tamanho: $SIZE"
echo "  Segmentos: $TOTAL"
echo "============================================"
echo "✅ Vídeo 2 CONCLUÍDO!"
