#!/bin/bash
# Montagem Final do Vídeo 2 — "A Máquina por Dentro" v10
# Estrutura: Modo 50/50 (Alternando TH e SCs)
# Crossfade 0.3s entre takes TH
# Marca d'água: logo transparente no canto inferior direito

set -e

BASE="/home/ubuntu/Moviemoney/skill-movie-money/criativos/video_institucional_youtube"
TEMP="$BASE/temp_v10"
TAKES="$BASE/takes_v10"
SCS="$BASE/temp_v2_montagem"
MARKER="$BASE/templates/identidade_visual/logo_transparente.png"

mkdir -p "$TEMP/norm"

echo "=== PASSO 1: Normalizar takes TH (loudnorm -16 LUFS, 48kHz stereo) ==="

for f in "$TAKES"/v10_*.mp4; do
    name=$(basename "$f" .mp4)
    echo "  Normalizando: $name"
    ffmpeg -y -i "$f" \
        -vf "scale=1280:720:flags=lanczos" \
        -af "loudnorm=I=-16:LRA=11:TP=-1.0,aformat=sample_fmts=s16:channel_layouts=stereo,aresample=48000" \
        -c:v libx264 -preset fast -crf 23 \
        -c:a aac -b:a 128k -ar 48000 \
        -r 24 \
        "$TEMP/norm/${name}.mp4" 2>/dev/null
done

echo "=== PASSO 2: Preparar SCs (cortar ao tamanho do VO) ==="

# Copiar SCs finalizados existentes (já têm Ken Burns + VO)
for sc in sc1_final sc2_final sc3_final sc4_final sc5_final sc6_final sc7_final sc8_final sc9_logo; do
    cp "$SCS/${sc}.mp4" "$TEMP/${sc}.mp4"
done

echo "=== PASSO 3: Aplicar marca d'água nos SCs ==="

for f in "$TEMP"/sc*.mp4; do
    name=$(basename "$f" .mp4)
    ffmpeg -y -i "$f" \
        -i "$MARKER" \
        -filter_complex "[1:v]scale=iw*0.15:-1[logo];[0:v][logo]overlay=W-w-20:H-h-20:shortest=1" \
        -c:v libx264 -preset fast -crf 23 \
        -c:a copy \
        -r 24 \
        "$TEMP/marked_${name}.mp4" 2>/dev/null
done

echo "=== PASSO 4: Aplicar marca d'água nos takes TH ==="

for f in "$TEMP/norm"/v10_*.mp4; do
    name=$(basename "$f" .mp4)
    ffmpeg -y -i "$f" \
        -i "$MARKER" \
        -filter_complex "[1:v]scale=iw*0.15:-1[logo];[0:v][logo]overlay=W-w-20:H-h-20:shortest=1" \
        -c:v libx264 -preset fast -crf 23 \
        -c:a copy \
        -r 24 \
        "$TEMP/marked_${name}.mp4" 2>/dev/null
done

echo "=== PASSO 5: Montar sequência final (Modo 50/50) ==="

# Sequência do vídeo conforme roteiro:
# SEÇÃO 1 — Hook da Prova Lógica
# TH-1a -> SC-1 -> TH-1b -> TH-1c -> TH-1d
# SEÇÃO 2 — Arquitetura do Repositório
# SC-2 -> SC-3 -> TH-2a -> TH-2b
# SEÇÃO 3 — Banco Narrativo
# SC-4 -> SC-5 -> SC-6
# SEÇÃO 4 — Lip Sync e Safe Zone
# TH-3a -> SC-7 -> SC-8 -> TH-3b
# SEÇÃO 5 — CTA
# TH-4a -> TH-4b -> TH-4c -> SC-9 (logo)

cat > "$TEMP/concat_v10.txt" << 'EOF'
file 'marked_v10_t1a_hook_matematico.mp4'
file 'marked_sc1_final.mp4'
file 'marked_v10_t1b_algoritmo_pune.mp4'
file 'marked_v10_t1c_caixa_preta.mp4'
file 'marked_v10_t1d_maquina_faz.mp4'
file 'marked_sc2_final.mp4'
file 'marked_sc3_final.mp4'
file 'marked_v10_t2a_elenco_nunca_atrasa.mp4'
file 'marked_v10_t2b_voce_gerencia.mp4'
file 'marked_sc4_final.mp4'
file 'marked_sc5_final.mp4'
file 'marked_sc6_final.mp4'
file 'marked_v10_t3a_cereja_bolo.mp4'
file 'marked_sc7_final.mp4'
file 'marked_sc8_final.mp4'
file 'marked_v10_t3b_engenharia_conversao.mp4'
file 'marked_v10_t4a_voce_viu_maquina.mp4'
file 'marked_v10_t4b_boa_noticia.mp4'
file 'marked_v10_t4c_proximo_video.mp4'
file 'marked_sc9_logo.mp4'
EOF

echo "=== PASSO 6: Concatenar tudo ==="

ffmpeg -y -f concat -safe 0 -i "$TEMP/concat_v10.txt" \
    -c:v libx264 -preset fast -crf 20 \
    -c:a aac -b:a 192k -ar 48000 \
    -movflags +faststart \
    "$TEMP/video2_maquina_por_dentro_v10_FINAL.mp4" 2>/dev/null

echo ""
echo "=== VÍDEO FINAL GERADO ==="
echo "Arquivo: $TEMP/video2_maquina_por_dentro_v10_FINAL.mp4"
ffprobe -v quiet -show_entries format=duration,bit_rate -show_entries stream=width,height,codec_name -of default "$TEMP/video2_maquina_por_dentro_v10_FINAL.mp4"
echo ""
echo "=== CONCLUÍDO ==="
