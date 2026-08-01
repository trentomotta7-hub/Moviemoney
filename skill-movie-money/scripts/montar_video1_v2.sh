#!/bin/bash
# ============================================================
# Script de Montagem v2 — Vídeo 1 YouTube (Quebra-Mitos)
# Movie Money — Sessão 6 (01/08/2026)
# ============================================================
# Estratégia:
# - Cada seção tem um áudio longo (audio_sX.wav) com a fala completa
# - O vídeo do Beto (takes TH) é loopado/estendido para cobrir o áudio
# - Screen recordings entram entre as seções com seus VOs
# - Estrutura final: S1_TH | SC1_VO | SC2_VO | S2_TH | SC3_VO | S3_TH | SC4_VO | SC5 | S4_TH | SC7_VO | S5_TH | LOGO
# ============================================================

set -e

TAKES="/home/ubuntu/Moviemoney/skill-movie-money/criativos/video_institucional_youtube/takes"
TEMPLATES="/home/ubuntu/Moviemoney/skill-movie-money/templates"
OUTPUT="/home/ubuntu/Moviemoney/skill-movie-money/criativos/video_institucional_youtube"
WATERMARK="$TEMPLATES/identidade_visual/logo_transparente.png"
TEMP="$OUTPUT/temp_v2"

mkdir -p "$TEMP"

echo "============================================"
echo "  MOVIE MONEY — Montagem Vídeo 1 v2"
echo "============================================"

# ----------------------------------------------------------
# Função: Criar segmento TH (vídeo do Beto loopado com áudio)
# ----------------------------------------------------------
make_th_segment() {
    local video="$1"    # take de vídeo do Beto
    local audio="$2"    # áudio da seção
    local output="$3"
    local audio_dur=$(ffprobe -v quiet -show_entries format=duration -of csv=p=0 "$audio" 2>/dev/null)
    
    # Loop o vídeo para cobrir a duração do áudio, depois corta no tamanho exato
    ffmpeg -y \
        -stream_loop -1 -i "$video" \
        -i "$audio" \
        -map 0:v -map 1:a \
        -t "$audio_dur" \
        -vf "scale=1280:720:force_original_aspect_ratio=decrease,pad=1280:720:(ow-iw)/2:(oh-ih)/2" \
        -c:v libx264 -preset fast -crf 20 -pix_fmt yuv420p \
        -c:a aac -b:a 192k \
        "$output" 2>/dev/null
    
    local dur=$(ffprobe -v quiet -show_entries format=duration -of csv=p=0 "$output" 2>/dev/null)
    printf "  ✓ %-35s %.1fs\n" "$(basename $output)" "$dur"
}

# ----------------------------------------------------------
# Função: Criar segmento SC (imagem com VO)
# ----------------------------------------------------------
make_sc_segment() {
    local image="$1"
    local audio="$2"
    local output="$3"
    local audio_dur=$(ffprobe -v quiet -show_entries format=duration -of csv=p=0 "$audio" 2>/dev/null)
    
    ffmpeg -y \
        -loop 1 -i "$image" \
        -i "$audio" \
        -map 0:v -map 1:a \
        -t "$audio_dur" \
        -vf "scale=1280:720:force_original_aspect_ratio=decrease,pad=1280:720:(ow-iw)/2:(oh-ih)/2,zoompan=z='min(zoom+0.0003,1.04)':d=$(echo "$audio_dur * 25" | bc | cut -d. -f1):s=1280x720:fps=25" \
        -c:v libx264 -preset fast -crf 20 -pix_fmt yuv420p \
        -c:a aac -b:a 192k \
        "$output" 2>/dev/null
    
    local dur=$(ffprobe -v quiet -show_entries format=duration -of csv=p=0 "$output" 2>/dev/null)
    printf "  ✓ %-35s %.1fs\n" "$(basename $output)" "$dur"
}

# ----------------------------------------------------------
# Função: Criar segmento SC sem VO (imagem estática)
# ----------------------------------------------------------
make_sc_silent() {
    local image="$1"
    local duration="$2"
    local output="$3"
    
    ffmpeg -y \
        -loop 1 -i "$image" \
        -t "$duration" \
        -vf "scale=1280:720:force_original_aspect_ratio=decrease,pad=1280:720:(ow-iw)/2:(oh-ih)/2" \
        -c:v libx264 -preset fast -crf 20 -pix_fmt yuv420p \
        -an \
        "$output" 2>/dev/null
    
    printf "  ✓ %-35s %.1fs\n" "$(basename $output)" "$duration"
}

# ----------------------------------------------------------
# ETAPA 1: Criar segmentos de Talking Head com áudio longo
# ----------------------------------------------------------
echo "[1/4] Criando segmentos de Talking Head com áudio completo..."

make_th_segment "$TAKES/t1_hook.mp4"    "$TAKES/audio_s1_hook.wav"    "$TEMP/seg01_s1_hook_th.mp4"
make_th_segment "$TAKES/t3_dor.mp4"     "$TAKES/audio_s2_dor.wav"     "$TEMP/seg05_s2_dor_th.mp4"
make_th_segment "$TAKES/t4_ilusao.mp4"  "$TAKES/audio_s3_maquina.wav" "$TEMP/seg08_s3_maquina_th.mp4"
make_th_segment "$TAKES/t5_cta.mp4"     "$TAKES/audio_s4_resultado.wav" "$TEMP/seg11_s4_resultado_th.mp4"
make_th_segment "$TAKES/t_cta_a.mp4"   "$TAKES/audio_s5_cta.wav"     "$TEMP/seg14_s5_cta_th.mp4"

# ----------------------------------------------------------
# ETAPA 2: Criar segmentos de Screen Recording com VO
# ----------------------------------------------------------
echo "[2/4] Criando segmentos de Screen Recording com Voice Over..."

make_sc_segment "$TAKES/sc1_youtube_gurus.png"    "$TAKES/vo_sc1_youtube_gurus.wav"  "$TEMP/seg02_sc1_gurus.mp4"
make_sc_segment "$TAKES/sc2_pasta_videos_chines.png" "$TAKES/vo_sc2_pasta_videos.wav" "$TEMP/seg03_sc2_pasta.mp4"
make_sc_segment "$TAKES/sc3_whatsapp_cliente.png" "$TAKES/vo_sc3_whatsapp_cliente.wav" "$TEMP/seg06_sc3_whatsapp.mp4"
make_sc_segment "$TAKES/sc4_repositorio_terminal.png" "$TAKES/vo_sc4_repositorio.wav" "$TEMP/seg09_sc4_repo.mp4"
make_sc_segment "$TAKES/sc7_whatsapp_resposta.png" "$TAKES/vo_sc7_whatsapp_resposta.wav" "$TEMP/seg12_sc7_resposta.mp4"

# SC5 (ffmpeg gerando) — aparece junto com a narração da máquina, sem VO separado
make_sc_silent "$TAKES/sc5_ffmpeg_gerando.png" 5 "$TEMP/seg10_sc5_ffmpeg.mp4"

# Logo final — 4s
make_sc_silent "$TAKES/sc8_logo_final.png" 4 "$TEMP/seg15_logo_final.mp4"

# ----------------------------------------------------------
# ETAPA 3: Criar lista de concatenação na ordem do roteiro
# ----------------------------------------------------------
echo "[3/4] Criando lista de concatenação..."

# Ordem: S1_TH → SC1_VO → SC2_VO → S2_TH → SC3_VO → S3_TH → SC4_VO → SC5 → S4_TH → SC7_VO → S5_TH → LOGO
cat > "$TEMP/concat_v2.txt" << EOF
# SEÇÃO 1 — Hook da Verdade
file '$TEMP/seg01_s1_hook_th.mp4'
# SC — YouTube gurus (VO)
file '$TEMP/seg02_sc1_gurus.mp4'
# SC — Pasta vídeos chineses (VO)
file '$TEMP/seg03_sc2_pasta.mp4'
# SEÇÃO 2 — A Dor Real
file '$TEMP/seg05_s2_dor_th.mp4'
# SC — WhatsApp cliente pedindo (VO)
file '$TEMP/seg06_sc3_whatsapp.mp4'
# SEÇÃO 3 — A Máquina Entra em Ação
file '$TEMP/seg08_s3_maquina_th.mp4'
# SC — Repositório + terminal (VO)
file '$TEMP/seg09_sc4_repo.mp4'
# SC — ffmpeg gerando (silêncio)
file '$TEMP/seg10_sc5_ffmpeg.mp4'
# SEÇÃO 4 — O Resultado e o Contraste
file '$TEMP/seg11_s4_resultado_th.mp4'
# SC — WhatsApp resposta fogo (VO)
file '$TEMP/seg12_sc7_resposta.mp4'
# SEÇÃO 5 — CTA de Transição
file '$TEMP/seg14_s5_cta_th.mp4'
# Logo final
file '$TEMP/seg15_logo_final.mp4'
EOF

NSEG=$(grep -c '^file' "$TEMP/concat_v2.txt")
echo "  ✓ Lista criada com $NSEG segmentos"

# Calcular duração total estimada
total_dur=0
while IFS= read -r line; do
    if [[ "$line" == file* ]]; then
        f=$(echo "$line" | sed "s/file '//;s/'//")
        dur=$(ffprobe -v quiet -show_entries format=duration -of csv=p=0 "$f" 2>/dev/null)
        total_dur=$(echo "$total_dur + $dur" | bc)
    fi
done < "$TEMP/concat_v2.txt"
echo "  ✓ Duração total estimada: $(echo "scale=1; $total_dur/60" | bc) min"

# ----------------------------------------------------------
# ETAPA 4: Concatenar e injetar marca d'água
# ----------------------------------------------------------
echo "[4/4] Concatenando e exportando vídeo final..."

# Concatenar (todos os segmentos já estão em 1280x720 com áudio AAC)
ffmpeg -y -f concat -safe 0 -i "$TEMP/concat_v2.txt" \
    -c:v libx264 -preset medium -crf 18 -pix_fmt yuv420p \
    -c:a aac -b:a 192k \
    "$TEMP/video1_v2_sem_wm.mp4" 2>/dev/null

echo "  ✓ Vídeo base concatenado"

# Upscale para 2560x1440 + marca d'água
if [ -f "$WATERMARK" ]; then
    ffmpeg -y \
        -i "$TEMP/video1_v2_sem_wm.mp4" \
        -i "$WATERMARK" \
        -filter_complex "
            [0:v]scale=2560:1440:force_original_aspect_ratio=decrease,pad=2560:1440:(ow-iw)/2:(oh-ih)/2[scaled];
            [1:v]scale=180:-1[wm];
            [scaled][wm]overlay=W-w-40:H-h-40:format=auto,format=yuv420p[out]
        " \
        -map "[out]" -map 0:a \
        -c:v libx264 -preset medium -crf 18 \
        -c:a aac -b:a 192k \
        "$OUTPUT/video1_quebra_mitos_v2_FINAL.mp4" 2>/dev/null
    echo "  ✓ Upscale 2K + marca d'água injetada"
else
    ffmpeg -y -i "$TEMP/video1_v2_sem_wm.mp4" \
        -vf "scale=2560:1440:force_original_aspect_ratio=decrease,pad=2560:1440:(ow-iw)/2:(oh-ih)/2" \
        -c:v libx264 -preset medium -crf 18 -pix_fmt yuv420p \
        -c:a aac -b:a 192k \
        "$OUTPUT/video1_quebra_mitos_v2_FINAL.mp4" 2>/dev/null
    echo "  ✓ Upscale 2K (sem marca d'água — arquivo não encontrado)"
fi

# ----------------------------------------------------------
# RELATÓRIO FINAL
# ----------------------------------------------------------
echo ""
echo "============================================"
echo "  MONTAGEM v2 CONCLUÍDA!"
echo "============================================"
DURATION=$(ffprobe -v quiet -show_entries format=duration -of csv=p=0 "$OUTPUT/video1_quebra_mitos_v2_FINAL.mp4" 2>/dev/null)
DURATION_MIN=$(echo "scale=1; $DURATION/60" | bc)
SIZE=$(du -sh "$OUTPUT/video1_quebra_mitos_v2_FINAL.mp4" | cut -f1)
echo "  Arquivo: video1_quebra_mitos_v2_FINAL.mp4"
echo "  Duração: ${DURATION_MIN} minutos (${DURATION}s)"
echo "  Tamanho: $SIZE"
echo "  Resolução: 2560x1440 (YouTube 2K)"
echo "============================================"

rm -rf "$TEMP"
echo "  Temporários removidos."
