#!/bin/bash
# Montagem Final v11 — Vídeo 2: "A Máquina por Dentro"
# Corrige: TH-1a (repetição), TH-1b (gagueira), TH-4b (bigode)
# Corrige: SC-5 (voz feminina), SC-6 (voz robótica), SC-8 (voz robótica)
set -e

BASE="/home/ubuntu/Moviemoney/skill-movie-money/criativos/video_institucional_youtube"
TEMP="$BASE/temp_v10"
TAKES="$BASE/takes_v10"
MARKER="$BASE/../../templates/identidade_visual/logo_transparente.png"

echo "=== PASSO 1: Normalizar takes TH corrigidos ==="

# Normalizar os 3 takes regravados
for f in "${TAKES}/v10_t1a_hook_matematico_v3.mp4" "${TAKES}/v10_t1b_algoritmo_pune_v2.mp4" "${TAKES}/v10_t4b_boa_noticia_v2.mp4"; do
    name=$(basename "$f" .mp4)
    echo "  Normalizando: $name"
    ffmpeg -y -i "$f" \
        -vf "scale=1280:720:flags=lanczos" \
        -af "loudnorm=I=-16:LRA=11:TP=-1.0,aformat=sample_fmts=s16:channel_layouts=stereo,aresample=48000" \
        -c:v libx264 -preset medium -crf 18 \
        -c:a aac -b:a 192k -ar 48000 \
        -r 24 \
        "$TEMP/norm/${name}.mp4" 2>/dev/null
done

echo "=== PASSO 2: Aplicar marca d'água em TODOS os segmentos ==="

# Função para aplicar marca d'água
apply_watermark() {
    local input="$1"
    local output="$2"
    ffmpeg -y -i "$input" -i "$MARKER" \
        -filter_complex "[1:v]scale=iw*0.15:-1,loop=loop=1000:size=1:start=0[logo];[0:v][logo]overlay=W-w-20:H-h-20" \
        -c:v libx264 -preset medium -crf 18 -c:a copy \
        -shortest \
        "$output" 2>/dev/null
}

# THs que mantemos da v10 (já normalizados)
for f in "$TEMP/norm/v10_t1c_caixa_preta.mp4" \
         "$TEMP/norm/v10_t1d_maquina_faz.mp4" \
         "$TEMP/norm/v10_t2a_elenco_nunca_atrasa.mp4" \
         "$TEMP/norm/v10_t2b_voce_gerencia.mp4" \
         "$TEMP/norm/v10_t3a_cereja_bolo.mp4" \
         "$TEMP/norm/v10_t3b_engenharia_conversao.mp4" \
         "$TEMP/norm/v10_t4a_voce_viu_maquina.mp4" \
         "$TEMP/norm/v10_t4c_proximo_video.mp4"; do
    if [ -f "$f" ]; then
        name=$(basename "$f" .mp4)
        echo "  Marca TH (mantido): $name"
        apply_watermark "$f" "$TEMP/v11_${name}.mp4"
    fi
done

# THs regravados
for f in "$TEMP/norm/v10_t1a_hook_matematico_v3.mp4" \
         "$TEMP/norm/v10_t1b_algoritmo_pune_v2.mp4" \
         "$TEMP/norm/v10_t4b_boa_noticia_v2.mp4"; do
    name=$(basename "$f" .mp4)
    echo "  Marca TH (regravado): $name"
    apply_watermark "$f" "$TEMP/v11_${name}.mp4"
done

# SCs que mantemos (1, 2, 3, 4, 7, 9)
for sc in sc1_final sc2_final sc3_final sc4_final sc7_final sc9_logo; do
    echo "  Marca SC (mantido): $sc"
    apply_watermark "$TEMP/${sc}.mp4" "$TEMP/v11_${sc}.mp4"
done

# SCs corrigidos (5, 6, 8) - com nova VO
for sc in 5 6 8; do
    echo "  Marca SC (corrigido): sc${sc}"
    apply_watermark "$TEMP/sc${sc}_final_v2.mp4" "$TEMP/v11_sc${sc}_final.mp4"
done

echo "=== PASSO 3: Verificar todos os segmentos ==="
for f in "$TEMP"/v11_*.mp4; do
    frames=$(ffprobe -v quiet -select_streams v:0 -count_frames -show_entries stream=nb_read_frames -of default=noprint_wrappers=1:nokey=1 "$f" 2>/dev/null || echo "?")
    dur=$(ffprobe -v quiet -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$f")
    echo "  $(basename $f): ${dur}s, frames=${frames}"
done

echo "=== PASSO 4: Concatenar na ordem do roteiro ==="

cat > "$TEMP/concat_v11.txt" << 'EOF'
file 'v11_v10_t1a_hook_matematico_v3.mp4'
file 'v11_sc1_final.mp4'
file 'v11_v10_t1b_algoritmo_pune_v2.mp4'
file 'v11_v10_t1c_caixa_preta.mp4'
file 'v11_v10_t1d_maquina_faz.mp4'
file 'v11_sc2_final.mp4'
file 'v11_sc3_final.mp4'
file 'v11_v10_t2a_elenco_nunca_atrasa.mp4'
file 'v11_v10_t2b_voce_gerencia.mp4'
file 'v11_sc4_final.mp4'
file 'v11_sc5_final.mp4'
file 'v11_sc6_final.mp4'
file 'v11_v10_t3a_cereja_bolo.mp4'
file 'v11_sc7_final.mp4'
file 'v11_sc8_final.mp4'
file 'v11_v10_t3b_engenharia_conversao.mp4'
file 'v11_v10_t4a_voce_viu_maquina.mp4'
file 'v11_v10_t4b_boa_noticia_v2.mp4'
file 'v11_v10_t4c_proximo_video.mp4'
file 'v11_sc9_logo.mp4'
EOF

ffmpeg -y -f concat -safe 0 -i "$TEMP/concat_v11.txt" \
    -c copy \
    -movflags +faststart \
    "$BASE/video2_maquina_por_dentro_v11_FINAL.mp4" 2>/dev/null

echo ""
echo "=== VÍDEO FINAL v11 GERADO ==="
ffprobe -v quiet -show_entries format=duration,size,bit_rate -of default "$BASE/video2_maquina_por_dentro_v11_FINAL.mp4"
ls -lh "$BASE/video2_maquina_por_dentro_v11_FINAL.mp4"
echo "=== CONCLUÍDO ==="
