#!/usr/bin/env bash
# ============================================================
# MONTAGEM LIMPA — Vídeo 2: "A Máquina por Dentro" (v2)
# Arquitetura de áudio CORRETA:
#   - Takes TH (Beto): usam APENAS o áudio original embutido
#   - Screen Recordings: usam APENAS o VO correspondente
#   - ZERO sobreposição de vozes
# ============================================================

set -e

BASE="/home/ubuntu/Moviemoney/skill-movie-money/criativos/video_institucional_youtube"
TAKES_V2="$BASE/takes_v2"
VOS="$BASE/takes_v2_vos"
SCREENS="$BASE/screens_v2"
LOGO="/home/ubuntu/Moviemoney/skill-movie-money/templates/identidade_visual/logo_transparente.png"
TEMP="$BASE/temp_v2_limpo"
OUTPUT="$BASE"

mkdir -p "$TEMP"

echo "============================================"
echo "  MOVIE MONEY — MONTAGEM VÍDEO 2 (v2 LIMPO)"
echo "  Arquitetura: 1 voz por segmento"
echo "============================================"

# ----------------------------------------------------------
# FUNÇÃO: Normalizar take TH — mantém apenas o áudio original
# ----------------------------------------------------------
norm_th() {
    local input="$1"
    local output="$2"
    ffmpeg -y -i "$input" \
        -vf "scale=1280:720:force_original_aspect_ratio=decrease,pad=1280:720:(ow-iw)/2:(oh-ih)/2,setsar=1" \
        -c:v libx264 -preset fast -crf 20 -pix_fmt yuv420p \
        -c:a aac -b:a 128k -ar 48000 -ac 2 \
        "$output" 2>/dev/null
    local dur
    dur=$(ffprobe -v quiet -show_entries format=duration -of csv=p=0 "$output" 2>/dev/null)
    printf "  ✓ TH %-40s  %.1fs\n" "$(basename $output)" "$dur"
}

# ----------------------------------------------------------
# FUNÇÃO: Gerar SC com Ken Burns + VO como ÚNICO áudio
# ----------------------------------------------------------
sc_com_vo() {
    local img="$1"
    local vo="$2"
    local output="$3"

    # Duração = duração do VO + 0.3s de margem
    local vo_dur
    vo_dur=$(ffprobe -v quiet -show_entries format=duration -of csv=p=0 "$vo" 2>/dev/null)
    local dur
    dur=$(echo "scale=2; $vo_dur + 0.3" | bc)
    local frames
    frames=$(echo "scale=0; $dur * 25 / 1" | bc)

    # Passo 1: gerar visual com Ken Burns
    ffmpeg -y \
        -loop 1 -i "$img" \
        -vf "scale=4000:-1,zoompan=z='min(zoom+0.0005,1.08)':d=${frames}:x='iw/2-(iw/zoom/2)':y='ih/2-(ih/zoom/2)':s=1280x720,fps=25,setsar=1" \
        -t "$dur" \
        -c:v libx264 -preset fast -crf 20 -pix_fmt yuv420p \
        -an "$TEMP/$(basename $output .mp4)_vis.mp4" 2>/dev/null

    # Passo 2: combinar visual + VO (apenas o VO, sem outro áudio)
    ffmpeg -y \
        -i "$TEMP/$(basename $output .mp4)_vis.mp4" \
        -i "$vo" \
        -c:v copy \
        -c:a aac -b:a 128k -ar 48000 -ac 2 \
        -shortest \
        "$output" 2>/dev/null

    local dur_final
    dur_final=$(ffprobe -v quiet -show_entries format=duration -of csv=p=0 "$output" 2>/dev/null)
    printf "  ✓ SC %-40s  %.1fs\n" "$(basename $output)" "$dur_final"
}

# ----------------------------------------------------------
# FUNÇÃO: SC estático com fade (logo final — sem áudio)
# ----------------------------------------------------------
sc_logo() {
    local img="$1"
    local output="$2"
    ffmpeg -y \
        -loop 1 -i "$img" \
        -vf "scale=1280:720:force_original_aspect_ratio=decrease,pad=1280:720:(ow-iw)/2:(oh-ih)/2,fade=t=in:st=0:d=0.8,fade=t=out:st=4.2:d=0.8,setsar=1" \
        -t 5 \
        -c:v libx264 -preset fast -crf 20 -pix_fmt yuv420p \
        "$TEMP/sc9_vis.mp4" 2>/dev/null
    ffmpeg -y \
        -i "$TEMP/sc9_vis.mp4" \
        -f lavfi -i anullsrc=r=48000:cl=stereo \
        -c:v copy -c:a aac -b:a 64k -shortest \
        "$output" 2>/dev/null
    printf "  ✓ SC %-40s  5.0s\n" "$(basename $output)"
}

# ──────────────────────────────────────────────────────────
# ETAPA 1 — Takes de Talking Head (Beto)
# Áudio: original do take (lip sync gravado)
# ──────────────────────────────────────────────────────────
echo ""
echo "[1/4] Normalizando takes de Talking Head (Beto)..."
norm_th "$TAKES_V2/v2_t1a_hook_matematico.mp4"      "$TEMP/t1a.mp4"
norm_th "$TAKES_V2/v2_t1b_algoritmo_pune.mp4"       "$TEMP/t1b.mp4"
norm_th "$TAKES_V2/v2_t1c_caixa_preta.mp4"          "$TEMP/t1c.mp4"
norm_th "$TAKES_V2/v2_t1d_maquina_faz.mp4"          "$TEMP/t1d.mp4"
norm_th "$TAKES_V2/v2_t2a_elenco_nunca_atrasa.mp4"  "$TEMP/t2a.mp4"
norm_th "$TAKES_V2/v2_t2b_voce_gerencia.mp4"        "$TEMP/t2b.mp4"
norm_th "$TAKES_V2/v2_t3a_cereja_bolo.mp4"          "$TEMP/t3a.mp4"
norm_th "$TAKES_V2/v2_t3b_engenharia_conversao.mp4" "$TEMP/t3b.mp4"
norm_th "$TAKES_V2/v2_t4a_voce_viu_maquina.mp4"     "$TEMP/t4a.mp4"
norm_th "$TAKES_V2/v2_t4b_boa_noticia.mp4"          "$TEMP/t4b.mp4"
norm_th "$TAKES_V2/v2_t4c_proximo_video.mp4"        "$TEMP/t4c.mp4"

# ──────────────────────────────────────────────────────────
# ETAPA 2 — Screen Recordings
# Áudio: APENAS o VO correspondente (sem voz do Beto)
# ──────────────────────────────────────────────────────────
echo ""
echo "[2/4] Gerando Screen Recordings (Ken Burns + VO exclusivo)..."
sc_com_vo "$SCREENS/v2_sc1_video_generico_tiktok.png"   "$VOS/vo_sc1.wav"  "$TEMP/sc1.mp4"
sc_com_vo "$SCREENS/v2_sc2_vscode_repositorio.png"      "$VOS/vo_sc2.wav"  "$TEMP/sc2.mp4"
sc_com_vo "$SCREENS/v2_sc3_grid_personagens.png"        "$VOS/vo_sc3.wav"  "$TEMP/sc3.mp4"
sc_com_vo "$SCREENS/v2_sc4_banco_narrativo.png"         "$VOS/vo_sc4.wav"  "$TEMP/sc4.mp4"
sc_com_vo "$SCREENS/v2_sc5_lista_70_dores.png"          "$VOS/vo_sc5.wav"  "$TEMP/sc5.mp4"
sc_com_vo "$SCREENS/v2_sc6_terminal_gerando_video.png"  "$VOS/vo_sc6.wav"  "$TEMP/sc6.mp4"
sc_com_vo "$SCREENS/v2_sc7_comparacao_lipsync.png"      "$VOS/vo_sc7.wav"  "$TEMP/sc7.mp4"
sc_com_vo "$SCREENS/v2_sc8_legendas_safe_zone.png"      "$VOS/vo_sc8.wav"  "$TEMP/sc8.mp4"
sc_logo   "$SCREENS/v2_sc9_logo_final.png"                                  "$TEMP/sc9.mp4"

# ──────────────────────────────────────────────────────────
# ETAPA 3 — Concatenação na ordem exata do roteiro
# ──────────────────────────────────────────────────────────
echo ""
echo "[3/4] Criando lista de concatenação (ordem do roteiro)..."

cat > "$TEMP/concat.txt" << EOF
# SEÇÃO 1 — Hook da Prova Lógica
file '$TEMP/t1a.mp4'
file '$TEMP/sc1.mp4'
file '$TEMP/t1b.mp4'
file '$TEMP/t1c.mp4'
file '$TEMP/t1d.mp4'
# SEÇÃO 2 — A Arquitetura do Repositório
file '$TEMP/sc2.mp4'
file '$TEMP/sc3.mp4'
file '$TEMP/t2a.mp4'
file '$TEMP/t2b.mp4'
# SEÇÃO 3 — O Banco Narrativo
file '$TEMP/sc4.mp4'
file '$TEMP/sc5.mp4'
file '$TEMP/sc6.mp4'
# SEÇÃO 4 — Lip Sync e Safe Zone
file '$TEMP/t3a.mp4'
file '$TEMP/sc7.mp4'
file '$TEMP/sc8.mp4'
file '$TEMP/t3b.mp4'
# SEÇÃO 5 — CTA de Transição
file '$TEMP/t4a.mp4'
file '$TEMP/t4b.mp4'
file '$TEMP/t4c.mp4'
file '$TEMP/sc9.mp4'
EOF

TOTAL=$(grep -c '^file' "$TEMP/concat.txt")
echo "  ✓ $TOTAL segmentos na ordem do roteiro"

echo ""
echo "[4/4] Concatenando e finalizando..."

ffmpeg -y \
    -f concat -safe 0 \
    -i "$TEMP/concat.txt" \
    -c:v libx264 -preset medium -crf 18 -pix_fmt yuv420p \
    -c:a aac -b:a 192k -ar 48000 -ac 2 \
    "$TEMP/v2_sem_marca.mp4" 2>/dev/null

echo "  ✓ Vídeo base concatenado"

# Marca d'água
if [ -f "$LOGO" ]; then
    ffmpeg -y \
        -i "$TEMP/v2_sem_marca.mp4" \
        -i "$LOGO" \
        -filter_complex "[1:v]scale=140:-1[wm];[0:v][wm]overlay=W-w-25:H-h-25:format=auto,format=yuv420p" \
        -c:v libx264 -preset medium -crf 18 \
        -c:a aac -b:a 192k \
        "$OUTPUT/video2_maquina_por_dentro_v2_FINAL.mp4" 2>/dev/null
    echo "  ✓ Marca d'água aplicada"
else
    cp "$TEMP/v2_sem_marca.mp4" "$OUTPUT/video2_maquina_por_dentro_v2_FINAL.mp4"
fi

# ──────────────────────────────────────────────────────────
# RELATÓRIO
# ──────────────────────────────────────────────────────────
echo ""
echo "============================================"
DURATION=$(ffprobe -v quiet -show_entries format=duration -of csv=p=0 \
    "$OUTPUT/video2_maquina_por_dentro_v2_FINAL.mp4" 2>/dev/null)
DURATION_MIN=$(echo "scale=2; $DURATION/60" | bc)
SIZE=$(du -sh "$OUTPUT/video2_maquina_por_dentro_v2_FINAL.mp4" | cut -f1)
echo "  Arquivo: video2_maquina_por_dentro_v2_FINAL.mp4"
echo "  Duração: ${DURATION_MIN} min  (${DURATION}s)"
echo "  Tamanho: $SIZE"
echo "  Resolução: 1280x720"
echo "  Segmentos: $TOTAL"
echo "  Áudio: 1 voz por segmento — ZERO sobreposição"
echo "============================================"

rm -rf "$TEMP"
echo "  Temporários removidos."
echo ""
echo "✅  Vídeo 2 v2 PRONTO!"
