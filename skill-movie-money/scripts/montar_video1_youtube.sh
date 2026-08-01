#!/bin/bash
# ============================================================
# Script de Montagem — Vídeo 1 YouTube (Quebra-Mitos)
# Movie Money — Sessão 6 (01/08/2026)
# ============================================================
# Fluxo:
# 1. Converte imagens SC em vídeos de 4s (com zoom suave)
# 2. Upscale todos os takes TH para 2560x1440
# 3. Concatena na ordem do roteiro
# 4. Injeta marca d'água
# 5. Exporta video1_quebra_mitos_FINAL.mp4
# ============================================================

set -e

TAKES="/home/ubuntu/Moviemoney/skill-movie-money/criativos/video_institucional_youtube/takes"
TEMPLATES="/home/ubuntu/Moviemoney/skill-movie-money/templates"
OUTPUT="/home/ubuntu/Moviemoney/skill-movie-money/criativos/video_institucional_youtube"
WATERMARK="$TEMPLATES/identidade_visual/logo_transparente.png"
TEMP="$OUTPUT/temp_montagem"

mkdir -p "$TEMP"

echo "============================================"
echo "  MOVIE MONEY — Montagem Vídeo 1 YouTube"
echo "============================================"

# ----------------------------------------------------------
# ETAPA 1: Converter imagens SC em vídeos de 4s com zoom
# ----------------------------------------------------------
echo "[1/5] Convertendo screen recordings em vídeos..."

convert_sc_to_video() {
    local input="$1"
    local output="$2"
    local duration="${3:-4}"
    # Ken Burns suave: zoom in de 1.0 para 1.05
    ffmpeg -y -loop 1 -i "$input" \
        -vf "scale=2560:1440:force_original_aspect_ratio=decrease,pad=2560:1440:(ow-iw)/2:(oh-ih)/2,zoompan=z='min(zoom+0.0005,1.05)':d=${duration}*25:s=2560x1440:fps=25" \
        -t "$duration" -c:v libx264 -preset fast -crf 18 -pix_fmt yuv420p \
        -an "$output" 2>/dev/null
    echo "  ✓ $(basename $output)"
}

convert_sc_to_video "$TAKES/sc1_youtube_gurus.png"     "$TEMP/sc1_youtube_gurus.mp4"     5
convert_sc_to_video "$TAKES/sc2_pasta_videos_chines.png" "$TEMP/sc2_pasta_videos_chines.mp4" 4
convert_sc_to_video "$TAKES/sc3_whatsapp_cliente.png"  "$TEMP/sc3_whatsapp_cliente.mp4"  5
convert_sc_to_video "$TAKES/sc4_repositorio_terminal.png" "$TEMP/sc4_repositorio_terminal.mp4" 6
convert_sc_to_video "$TAKES/sc5_ffmpeg_gerando.png"    "$TEMP/sc5_ffmpeg_gerando.mp4"    5
convert_sc_to_video "$TAKES/sc7_whatsapp_resposta.png" "$TEMP/sc7_whatsapp_resposta.mp4" 4
convert_sc_to_video "$TAKES/sc8_logo_final.png"        "$TEMP/sc8_logo_final.mp4"        4

# ----------------------------------------------------------
# ETAPA 2: Upscale takes TH para 2560x1440 (com áudio)
# ----------------------------------------------------------
echo "[2/5] Upscalando takes de Talking Head para 2560x1440..."

upscale_th() {
    local input="$1"
    local output="$2"
    ffmpeg -y -i "$input" \
        -vf "scale=2560:1440:force_original_aspect_ratio=decrease,pad=2560:1440:(ow-iw)/2:(oh-ih)/2" \
        -c:v libx264 -preset fast -crf 18 -pix_fmt yuv420p \
        -c:a aac -b:a 192k "$output" 2>/dev/null
    echo "  ✓ $(basename $output)"
}

upscale_th "$TAKES/t1_hook.mp4"            "$TEMP/t1_hook_2k.mp4"
upscale_th "$TAKES/t1b_voiceover_sonho.mp4" "$TEMP/t1b_voiceover_2k.mp4"
upscale_th "$TAKES/t1c_mentira_retencao.mp4" "$TEMP/t1c_mentira_2k.mp4"
upscale_th "$TAKES/t2_mentira.mp4"          "$TEMP/t2_mentira_2k.mp4"
upscale_th "$TAKES/t3_dor.mp4"              "$TEMP/t3_dor_2k.mp4"
upscale_th "$TAKES/t3b_dono_negocio.mp4"    "$TEMP/t3b_dono_2k.mp4"
upscale_th "$TAKES/t4_ilusao.mp4"           "$TEMP/t4_ilusao_2k.mp4"
upscale_th "$TAKES/t4b_banco_narrativo.mp4" "$TEMP/t4b_banco_2k.mp4"
upscale_th "$TAKES/t5_cta.mp4"              "$TEMP/t5_cta_2k.mp4"
upscale_th "$TAKES/t5b_municao.mp4"         "$TEMP/t5b_municao_2k.mp4"
upscale_th "$TAKES/t_cta_a.mp4"             "$TEMP/t_cta_a_2k.mp4"
upscale_th "$TAKES/t_cta_b.mp4"             "$TEMP/t_cta_b_2k.mp4"

# ----------------------------------------------------------
# ETAPA 3: Criar lista de concatenação na ordem do roteiro
# ----------------------------------------------------------
echo "[3/5] Criando lista de concatenação..."

cat > "$TEMP/concat_list.txt" << EOF
# SEÇÃO 1 — Hook da Verdade
file '$TEMP/t1_hook_2k.mp4'
file '$TEMP/sc1_youtube_gurus.mp4'
file '$TEMP/t1b_voiceover_2k.mp4'
file '$TEMP/t1c_mentira_2k.mp4'
# SEÇÃO 2 — A Dor Real
file '$TEMP/sc2_pasta_videos_chines.mp4'
file '$TEMP/t2_mentira_2k.mp4'
file '$TEMP/t3_dor_2k.mp4'
file '$TEMP/t3b_dono_2k.mp4'
# SEÇÃO 3 — A Máquina Entra em Ação
file '$TEMP/sc3_whatsapp_cliente.mp4'
file '$TEMP/t4_ilusao_2k.mp4'
file '$TEMP/sc4_repositorio_terminal.mp4'
file '$TEMP/t4b_banco_2k.mp4'
file '$TEMP/sc5_ffmpeg_gerando.mp4'
# SEÇÃO 4 — Resultado e Contraste
file '$TEMP/t5_cta_2k.mp4'
file '$TEMP/sc7_whatsapp_resposta.mp4'
file '$TEMP/t5b_municao_2k.mp4'
# SEÇÃO 5 — CTA de Transição
file '$TEMP/t_cta_a_2k.mp4'
file '$TEMP/t_cta_b_2k.mp4'
file '$TEMP/sc8_logo_final.mp4'
EOF

echo "  ✓ Lista criada com $(grep -c '^file' $TEMP/concat_list.txt) segmentos"

# ----------------------------------------------------------
# ETAPA 4: Concatenar todos os segmentos
# ----------------------------------------------------------
echo "[4/5] Concatenando vídeo final..."

ffmpeg -y -f concat -safe 0 -i "$TEMP/concat_list.txt" \
    -c:v libx264 -preset medium -crf 18 -pix_fmt yuv420p \
    -c:a aac -b:a 192k \
    "$TEMP/video1_sem_watermark.mp4" 2>/dev/null

echo "  ✓ Vídeo base concatenado"

# ----------------------------------------------------------
# ETAPA 5: Injetar marca d'água
# ----------------------------------------------------------
echo "[5/5] Injetando marca d'água..."

# Verifica se a marca d'água existe
if [ -f "$WATERMARK" ]; then
    ffmpeg -y \
        -i "$TEMP/video1_sem_watermark.mp4" \
        -i "$WATERMARK" \
        -filter_complex "[1:v]scale=180:-1[wm];[0:v][wm]overlay=W-w-40:H-h-40:format=auto,format=yuv420p" \
        -c:v libx264 -preset medium -crf 18 \
        -c:a aac -b:a 192k \
        "$OUTPUT/video1_quebra_mitos_FINAL.mp4" 2>/dev/null
    echo "  ✓ Marca d'água injetada"
else
    echo "  ⚠ Marca d'água não encontrada, exportando sem ela..."
    cp "$TEMP/video1_sem_watermark.mp4" "$OUTPUT/video1_quebra_mitos_FINAL.mp4"
fi

# ----------------------------------------------------------
# RELATÓRIO FINAL
# ----------------------------------------------------------
echo ""
echo "============================================"
echo "  MONTAGEM CONCLUÍDA!"
echo "============================================"
DURATION=$(ffprobe -v quiet -show_entries format=duration -of csv=p=0 "$OUTPUT/video1_quebra_mitos_FINAL.mp4" 2>/dev/null)
DURATION_MIN=$(echo "scale=1; $DURATION/60" | bc)
SIZE=$(du -sh "$OUTPUT/video1_quebra_mitos_FINAL.mp4" | cut -f1)
echo "  Arquivo: video1_quebra_mitos_FINAL.mp4"
echo "  Duração: ${DURATION_MIN} minutos"
echo "  Tamanho: $SIZE"
echo "  Resolução: 2560x1440 (YouTube 2K)"
echo "============================================"

# Limpar temporários
rm -rf "$TEMP"
echo "  Temporários removidos."
