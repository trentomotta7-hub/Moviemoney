#!/usr/bin/env bash
# ============================================================
# MONTAGEM — Vídeo 2: "A Máquina por Dentro"
# Movie Money Production Pipeline v2.0
# Sessão 12 — 02/08/2026
# ============================================================
# Padrões técnicos (skill: moviemoney-production):
#   - Crossfade 0.3s entre takes TH
#   - Ken Burns (zoom 1.0 → 1.08) em todos os SCs
#   - Safe Zone: legendas a 320px da borda inferior
#   - Resolução final: 1280x720 (sem upscale 2K nesta sessão)
#   - Áudio: 48kHz stereo
# ============================================================

set -e

BASE="/home/ubuntu/Moviemoney/skill-movie-money/criativos/video_institucional_youtube"
TAKES_V2="$BASE/takes_v2"
TAKES="$BASE/takes"
SCREENS="$BASE/screens_v2"
LOGO="/home/ubuntu/Moviemoney/skill-movie-money/templates/identidade_visual/logo_transparente.png"
TEMP="$BASE/temp_v2_montagem"
OUTPUT="$BASE"

mkdir -p "$TEMP"

echo "============================================"
echo "  MOVIE MONEY — MONTAGEM VÍDEO 2"
echo "  'A Máquina por Dentro'"
echo "============================================"
echo ""

# ----------------------------------------------------------
# FUNÇÃO: Converter SC (PNG + VO) em vídeo com Ken Burns
# ----------------------------------------------------------
convert_sc_kenburns() {
    local img="$1"
    local vo="$2"
    local output="$3"
    local dur="$4"

    # Calcular duração baseada no VO se disponível
    if [ -f "$vo" ]; then
        local vo_dur
        vo_dur=$(ffprobe -v quiet -show_entries format=duration -of csv=p=0 "$vo" 2>/dev/null)
        # Adicionar 0.5s de margem
        dur=$(echo "scale=1; $vo_dur + 0.5" | bc)
    fi

    local frames
    frames=$(echo "scale=0; $dur * 25 / 1" | bc)

    # Ken Burns: zoom 1.0 → 1.08 com pan suave
    ffmpeg -y \
        -loop 1 -i "$img" \
        -vf "scale=4000:-1,zoompan=z='min(zoom+0.0005,1.08)':d=${frames}:x='iw/2-(iw/zoom/2)':y='ih/2-(ih/zoom/2)':s=1280x720,fps=25" \
        -t "$dur" \
        -c:v libx264 -preset fast -crf 20 -pix_fmt yuv420p \
        -an "$output" 2>/dev/null
    echo "  ✓ SC visual: $(basename $output) (${dur}s)"
}

# ----------------------------------------------------------
# FUNÇÃO: Combinar SC visual + VO em vídeo com áudio
# ----------------------------------------------------------
combine_sc_with_vo() {
    local visual="$1"
    local vo="$2"
    local output="$3"

    if [ -f "$vo" ]; then
        ffmpeg -y \
            -i "$visual" \
            -i "$vo" \
            -c:v copy \
            -c:a aac -b:a 128k -ar 48000 -ac 2 \
            -shortest \
            "$output" 2>/dev/null
        echo "  ✓ SC com VO: $(basename $output)"
    else
        # SC sem VO (silencioso)
        ffmpeg -y \
            -i "$visual" \
            -f lavfi -i anullsrc=r=48000:cl=stereo \
            -c:v copy \
            -c:a aac -b:a 128k \
            -shortest \
            "$output" 2>/dev/null
        echo "  ✓ SC silencioso: $(basename $output)"
    fi
}

# ----------------------------------------------------------
# FUNÇÃO: Normalizar take TH para formato padrão
# ----------------------------------------------------------
normalize_th() {
    local input="$1"
    local output="$2"

    ffmpeg -y -i "$input" \
        -vf "scale=1280:720:force_original_aspect_ratio=decrease,pad=1280:720:(ow-iw)/2:(oh-ih)/2" \
        -c:v libx264 -preset fast -crf 20 -pix_fmt yuv420p \
        -c:a aac -b:a 128k -ar 48000 -ac 2 \
        "$output" 2>/dev/null
    echo "  ✓ TH normalizado: $(basename $output)"
}

# ----------------------------------------------------------
# ETAPA 1: Gerar SCs com Ken Burns + VO
# ----------------------------------------------------------
echo "[1/5] Gerando Screen Recordings com Ken Burns..."

# SC-1: Vídeo genérico TikTok (~12s com VO)
convert_sc_kenburns "$SCREENS/v2_sc1_video_generico_tiktok.png" "$TAKES/vo_sc1_v2.wav" "$TEMP/sc1_visual.mp4" 12
combine_sc_with_vo "$TEMP/sc1_visual.mp4" "$TAKES/vo_sc1_v2.wav" "$TEMP/sc1_final.mp4"

# SC-2: VS Code repositório (~14s com VO)
convert_sc_kenburns "$SCREENS/v2_sc2_vscode_repositorio.png" "$TAKES/vo_sc2_v2.wav" "$TEMP/sc2_visual.mp4" 14
combine_sc_with_vo "$TEMP/sc2_visual.mp4" "$TAKES/vo_sc2_v2.wav" "$TEMP/sc2_final.mp4"

# SC-3: Grid 5 personagens (~14s com VO)
convert_sc_kenburns "$SCREENS/v2_sc3_grid_personagens.png" "$TAKES/vo_sc3_v2.wav" "$TEMP/sc3_visual.mp4" 14
combine_sc_with_vo "$TEMP/sc3_visual.mp4" "$TAKES/vo_sc3_v2.wav" "$TEMP/sc3_final.mp4"

# SC-4: banco_narrativo.md (~13s com VO)
convert_sc_kenburns "$SCREENS/v2_sc4_banco_narrativo.png" "$TAKES/vo_sc4_v2.wav" "$TEMP/sc4_visual.mp4" 13
combine_sc_with_vo "$TEMP/sc4_visual.mp4" "$TAKES/vo_sc4_v2.wav" "$TEMP/sc4_final.mp4"

# SC-5: Lista 70 dores (~18s com VO)
convert_sc_kenburns "$SCREENS/v2_sc5_lista_70_dores.png" "$TAKES/vo_sc5_v2.wav" "$TEMP/sc5_visual.mp4" 18
combine_sc_with_vo "$TEMP/sc5_visual.mp4" "$TAKES/vo_sc5_v2.wav" "$TEMP/sc5_final.mp4"

# SC-6: Terminal gerando vídeo (~22s com VO)
convert_sc_kenburns "$SCREENS/v2_sc6_terminal_gerando_video.png" "$TAKES/vo_sc6_v2.wav" "$TEMP/sc6_visual.mp4" 22
combine_sc_with_vo "$TEMP/sc6_visual.mp4" "$TAKES/vo_sc6_v2.wav" "$TEMP/sc6_final.mp4"

# SC-7: Comparação lip sync (~4s com VO)
convert_sc_kenburns "$SCREENS/v2_sc7_comparacao_lipsync.png" "$TAKES/vo_sc7_v2.wav" "$TEMP/sc7_visual.mp4" 5
combine_sc_with_vo "$TEMP/sc7_visual.mp4" "$TAKES/vo_sc7_v2.wav" "$TEMP/sc7_final.mp4"

# SC-8: Legendas Safe Zone (~25s com VO)
convert_sc_kenburns "$SCREENS/v2_sc8_legendas_safe_zone.png" "$TAKES/vo_sc8_v2.wav" "$TEMP/sc8_visual.mp4" 25
combine_sc_with_vo "$TEMP/sc8_visual.mp4" "$TAKES/vo_sc8_v2.wav" "$TEMP/sc8_final.mp4"

# SC-9: Logo final (5s, estático com fade)
ffmpeg -y \
    -loop 1 -i "$SCREENS/v2_sc9_logo_final.png" \
    -vf "scale=1280:720:force_original_aspect_ratio=decrease,pad=1280:720:(ow-iw)/2:(oh-ih)/2,fade=t=in:st=0:d=0.5,fade=t=out:st=4:d=0.5" \
    -t 5 \
    -c:v libx264 -preset fast -crf 20 -pix_fmt yuv420p \
    -f lavfi -i anullsrc=r=48000:cl=stereo \
    -c:a aac -b:a 128k \
    -shortest \
    "$TEMP/sc9_logo.mp4" 2>/dev/null
echo "  ✓ SC-9 logo: sc9_logo.mp4 (5s)"

echo ""

# ----------------------------------------------------------
# ETAPA 2: Normalizar takes TH
# ----------------------------------------------------------
echo "[2/5] Normalizando takes de Talking Head..."

normalize_th "$TAKES_V2/v2_t1a_hook_matematico.mp4"    "$TEMP/t1a_norm.mp4"
normalize_th "$TAKES_V2/v2_t1b_algoritmo_pune.mp4"     "$TEMP/t1b_norm.mp4"
normalize_th "$TAKES_V2/v2_t1c_caixa_preta.mp4"        "$TEMP/t1c_norm.mp4"
normalize_th "$TAKES_V2/v2_t1d_maquina_faz.mp4"        "$TEMP/t1d_norm.mp4"
normalize_th "$TAKES_V2/v2_t2a_elenco_nunca_atrasa.mp4" "$TEMP/t2a_norm.mp4"
normalize_th "$TAKES_V2/v2_t2b_voce_gerencia.mp4"      "$TEMP/t2b_norm.mp4"
normalize_th "$TAKES_V2/v2_t3a_cereja_bolo.mp4"        "$TEMP/t3a_norm.mp4"
normalize_th "$TAKES_V2/v2_t3b_engenharia_conversao.mp4" "$TEMP/t3b_norm.mp4"
normalize_th "$TAKES_V2/v2_t4a_voce_viu_maquina.mp4"   "$TEMP/t4a_norm.mp4"
normalize_th "$TAKES_V2/v2_t4b_boa_noticia.mp4"        "$TEMP/t4b_norm.mp4"
normalize_th "$TAKES_V2/v2_t4c_proximo_video.mp4"      "$TEMP/t4c_norm.mp4"

echo ""

# ----------------------------------------------------------
# ETAPA 3: Criar lista de concatenação (ordem do roteiro)
# ----------------------------------------------------------
echo "[3/5] Criando lista de concatenação (ordem do roteiro)..."

cat > "$TEMP/concat_v2.txt" << EOF
# ============================================================
# VÍDEO 2: "A Máquina por Dentro" — Lista de Concatenação
# Estrutura: 50% Talking Head / 50% Screen Recording
# ============================================================

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

TOTAL_SEGS=$(grep -c '^file' "$TEMP/concat_v2.txt")
echo "  ✓ Lista criada com $TOTAL_SEGS segmentos"
echo ""

# ----------------------------------------------------------
# ETAPA 4: Concatenar todos os segmentos
# ----------------------------------------------------------
echo "[4/5] Concatenando vídeo final..."

ffmpeg -y \
    -f concat -safe 0 \
    -i "$TEMP/concat_v2.txt" \
    -c:v libx264 -preset medium -crf 18 -pix_fmt yuv420p \
    -c:a aac -b:a 192k -ar 48000 -ac 2 \
    "$TEMP/video2_sem_marca.mp4" 2>/dev/null

echo "  ✓ Vídeo base concatenado"
echo ""

# ----------------------------------------------------------
# ETAPA 5: Adicionar marca d'água (logo) se disponível
# ----------------------------------------------------------
echo "[5/5] Finalizando vídeo..."

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
    echo "  ⚠ Logo não encontrada — exportando sem marca d'água"
fi

# ----------------------------------------------------------
# RELATÓRIO FINAL
# ----------------------------------------------------------
echo ""
echo "============================================"
echo "  MONTAGEM CONCLUÍDA!"
echo "============================================"

DURATION=$(ffprobe -v quiet -show_entries format=duration -of csv=p=0 "$OUTPUT/video2_maquina_por_dentro_v1_FINAL.mp4" 2>/dev/null)
DURATION_MIN=$(echo "scale=2; $DURATION/60" | bc)
SIZE=$(du -sh "$OUTPUT/video2_maquina_por_dentro_v1_FINAL.mp4" | cut -f1)

echo "  Arquivo: video2_maquina_por_dentro_v1_FINAL.mp4"
echo "  Duração: ${DURATION_MIN} minutos (${DURATION}s)"
echo "  Tamanho: $SIZE"
echo "  Resolução: 1280x720"
echo "  Segmentos: $TOTAL_SEGS"
echo "============================================"

# Limpar temporários
rm -rf "$TEMP"
echo "  Temporários removidos."
echo ""
echo "✅ Vídeo 2 pronto para revisão!"
