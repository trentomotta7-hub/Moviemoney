#!/usr/bin/env bash
# ============================================================
# MONTAGEM SINCRONIZADA v4 — Vídeo 2: "A Máquina por Dentro"
#
# PRINCÍPIO: O áudio do Beto é a referência absoluta.
# Cada take TH aparece com seu próprio áudio (lip sync).
# Os SCs são inseridos entre os takes com duração ajustada
# para que o visual total bata com o áudio total do Beto.
#
# ESTRUTURA:
#   [TH-1a: 10s] → [SC-1: 10s] → [TH-1b: 10s] → [TH-1c: 10s]
#   → [TH-1d: 10s] → [SC-2+3: 18s] → [TH-2a: 10s] → [TH-2b: 8s]
#   → [SC-4+5+6: 15s] → [TH-3a: 8s] → [SC-7+8: 15s] → [TH-3b: 7s]
#   → [TH-4a: 10s] → [TH-4b: 10s] → [TH-4c: 10s]
#
# Total TH: 103s. Os SCs são visuais que aparecem enquanto
# o Beto fala em voice-over — o áudio é contínuo e único.
# ============================================================

set -e

BASE="/home/ubuntu/Moviemoney/skill-movie-money/criativos/video_institucional_youtube"
TAKES="$BASE/takes_v2"
ANIM="$BASE/screens_v2_anim"
LOGO="/home/ubuntu/Moviemoney/skill-movie-money/templates/identidade_visual/logo_transparente.png"
TEMP="$BASE/temp_v4"
OUTPUT="$BASE"

mkdir -p "$TEMP"

echo "============================================"
echo "  MOVIE MONEY — MONTAGEM v4 SINCRONIZADA"
echo "  Áudio: Beto (lip sync nos TH)"
echo "  SCs: visuais animados sem áudio próprio"
echo "============================================"

# ── Funções ──────────────────────────────────────────────────────────────────

# Normalizar take TH — mantém vídeo + áudio original (lip sync)
norm_th() {
    local input="$1" output="$2"
    ffmpeg -y -i "$input" \
        -vf "scale=1280:720:force_original_aspect_ratio=decrease,pad=1280:720:(ow-iw)/2:(oh-ih)/2,setsar=1" \
        -c:v libx264 -preset fast -crf 20 -pix_fmt yuv420p \
        -c:a aac -b:a 192k -ar 48000 -ac 2 \
        "$output" 2>/dev/null
    local dur; dur=$(ffprobe -v quiet -show_entries format=duration -of csv=p=0 "$output" 2>/dev/null)
    printf "  ✓ TH %-35s  %.1fs\n" "$(basename $output)" "$dur"
}

# Preparar SC animado com duração específica + silêncio (áudio do Beto virá depois)
prep_sc_dur() {
    local input="$1" output="$2" dur="$3"
    # Escalar e cortar/estender para a duração exata
    ffmpeg -y -i "$input" \
        -vf "scale=1280:720:force_original_aspect_ratio=decrease,pad=1280:720:(ow-iw)/2:(oh-ih)/2,setsar=1" \
        -t "$dur" \
        -c:v libx264 -preset fast -crf 20 -pix_fmt yuv420p \
        -f lavfi -i anullsrc=r=48000:cl=stereo \
        -c:a aac -b:a 64k \
        -map 0:v -map 1:a \
        -shortest \
        "$output" 2>/dev/null
    local dur_out; dur_out=$(ffprobe -v quiet -show_entries format=duration -of csv=p=0 "$output" 2>/dev/null)
    printf "  ✓ SC %-35s  %.1fs\n" "$(basename $output)" "$dur_out"
}

# ── ETAPA 1: Takes TH com lip sync ───────────────────────────────────────────
echo ""
echo "[1/5] Takes de Talking Head (com lip sync original)..."

norm_th "$TAKES/v2_t1a_hook_matematico.mp4"      "$TEMP/t1a.mp4"   # 10s
norm_th "$TAKES/v2_t1b_algoritmo_pune.mp4"       "$TEMP/t1b.mp4"   # 10s
norm_th "$TAKES/v2_t1c_caixa_preta.mp4"          "$TEMP/t1c.mp4"   # 10s
norm_th "$TAKES/v2_t1d_maquina_faz.mp4"          "$TEMP/t1d.mp4"   # 10s
norm_th "$TAKES/v2_t2a_elenco_nunca_atrasa.mp4"  "$TEMP/t2a.mp4"   # 10s
norm_th "$TAKES/v2_t2b_voce_gerencia.mp4"        "$TEMP/t2b.mp4"   # 8s
norm_th "$TAKES/v2_t3a_cereja_bolo.mp4"          "$TEMP/t3a.mp4"   # 8s
norm_th "$TAKES/v2_t3b_engenharia_conversao.mp4" "$TEMP/t3b.mp4"   # 7s
norm_th "$TAKES/v2_t4a_voce_viu_maquina.mp4"     "$TEMP/t4a.mp4"   # 10s
norm_th "$TAKES/v2_t4b_boa_noticia.mp4"          "$TEMP/t4b.mp4"   # 10s
norm_th "$TAKES/v2_t4c_proximo_video.mp4"        "$TEMP/t4c.mp4"   # 10s

# ── ETAPA 2: SCs com duração ajustada para encaixar entre os TH ─────────────
# A ideia: os SCs são "janelas visuais" que aparecem entre os takes do Beto.
# Cada SC tem silêncio — o áudio do Beto continua em voice-over via mixagem.
# Duração dos SCs calibrada para o fluxo narrativo.
echo ""
echo "[2/5] Screen Recordings animados (duração calibrada)..."

# SC-1 após TH-1a: mostra o anúncio genérico enquanto Beto fala sobre ele
prep_sc_dur "$ANIM/sc1_anim.mp4" "$TEMP/sc1.mp4" "10"

# SC-2 e SC-3 juntos entre TH-1d e TH-2a: repositório + personagens
# Vamos criar um SC combinado de 18s
ffmpeg -y \
    -i "$ANIM/sc2_anim.mp4" \
    -i "$ANIM/sc3_anim.mp4" \
    -filter_complex "[0:v][1:v]concat=n=2:v=1:a=0[v]" \
    -map "[v]" \
    -vf "scale=1280:720:force_original_aspect_ratio=decrease,pad=1280:720:(ow-iw)/2:(oh-ih)/2,setsar=1" \
    -t 18 \
    -c:v libx264 -preset fast -crf 20 -pix_fmt yuv420p \
    "$TEMP/sc2_3_vis.mp4" 2>/dev/null
ffmpeg -y -i "$TEMP/sc2_3_vis.mp4" \
    -f lavfi -i anullsrc=r=48000:cl=stereo \
    -c:v copy -c:a aac -b:a 64k -map 0:v -map 1:a -shortest \
    "$TEMP/sc23.mp4" 2>/dev/null
printf "  ✓ SC %-35s  18.0s\n" "sc23.mp4 (SC2+SC3 combinados)"

# SC-4, SC-5, SC-6 juntos: banco narrativo + dores + pipeline
ffmpeg -y \
    -i "$ANIM/sc4_anim.mp4" \
    -i "$ANIM/sc5_anim.mp4" \
    -i "$ANIM/sc6_anim.mp4" \
    -filter_complex "[0:v][1:v][2:v]concat=n=3:v=1:a=0[v]" \
    -map "[v]" \
    -vf "scale=1280:720:force_original_aspect_ratio=decrease,pad=1280:720:(ow-iw)/2:(oh-ih)/2,setsar=1" \
    -t 15 \
    -c:v libx264 -preset fast -crf 20 -pix_fmt yuv420p \
    "$TEMP/sc4_6_vis.mp4" 2>/dev/null
ffmpeg -y -i "$TEMP/sc4_6_vis.mp4" \
    -f lavfi -i anullsrc=r=48000:cl=stereo \
    -c:v copy -c:a aac -b:a 64k -map 0:v -map 1:a -shortest \
    "$TEMP/sc456.mp4" 2>/dev/null
printf "  ✓ SC %-35s  15.0s\n" "sc456.mp4 (SC4+SC5+SC6)"

# SC-7 e SC-8 juntos: comparação + safe zone
ffmpeg -y \
    -i "$ANIM/sc7_anim.mp4" \
    -i "$ANIM/sc8_anim.mp4" \
    -filter_complex "[0:v][1:v]concat=n=2:v=1:a=0[v]" \
    -map "[v]" \
    -vf "scale=1280:720:force_original_aspect_ratio=decrease,pad=1280:720:(ow-iw)/2:(oh-ih)/2,setsar=1" \
    -t 15 \
    -c:v libx264 -preset fast -crf 20 -pix_fmt yuv420p \
    "$TEMP/sc7_8_vis.mp4" 2>/dev/null
ffmpeg -y -i "$TEMP/sc7_8_vis.mp4" \
    -f lavfi -i anullsrc=r=48000:cl=stereo \
    -c:v copy -c:a aac -b:a 64k -map 0:v -map 1:a -shortest \
    "$TEMP/sc78.mp4" 2>/dev/null
printf "  ✓ SC %-35s  15.0s\n" "sc78.mp4 (SC7+SC8)"

# SC-9: logo final
prep_sc_dur "$ANIM/sc9_anim.mp4" "$TEMP/sc9.mp4" "5"

# ── ETAPA 3: Criar lista de concatenação ─────────────────────────────────────
echo ""
echo "[3/5] Lista de concatenação (ordem do roteiro)..."

cat > "$TEMP/concat.txt" << EOF
# SEÇÃO 1 — Hook da Prova Lógica (Beto fala, SC aparece, Beto volta)
file '$TEMP/t1a.mp4'
file '$TEMP/sc1.mp4'
file '$TEMP/t1b.mp4'
file '$TEMP/t1c.mp4'
file '$TEMP/t1d.mp4'
# SEÇÃO 2 — Arquitetura (SCs visuais entre falas do Beto)
file '$TEMP/sc23.mp4'
file '$TEMP/t2a.mp4'
file '$TEMP/t2b.mp4'
# SEÇÃO 3 — Banco Narrativo (SCs visuais)
file '$TEMP/sc456.mp4'
# SEÇÃO 4 — Lip Sync e Safe Zone
file '$TEMP/t3a.mp4'
file '$TEMP/sc78.mp4'
file '$TEMP/t3b.mp4'
# SEÇÃO 5 — CTA Final
file '$TEMP/t4a.mp4'
file '$TEMP/t4b.mp4'
file '$TEMP/t4c.mp4'
file '$TEMP/sc9.mp4'
EOF

TOTAL=$(grep -c '^file' "$TEMP/concat.txt")
echo "  ✓ $TOTAL segmentos"

# ── ETAPA 4: Concatenar ───────────────────────────────────────────────────────
echo ""
echo "[4/5] Concatenando vídeo final..."

ffmpeg -y \
    -f concat -safe 0 \
    -i "$TEMP/concat.txt" \
    -c:v libx264 -preset medium -crf 18 -pix_fmt yuv420p \
    -c:a aac -b:a 192k -ar 48000 -ac 2 \
    "$TEMP/video_base.mp4" 2>/dev/null

DUR=$(ffprobe -v quiet -show_entries format=duration -of csv=p=0 "$TEMP/video_base.mp4" 2>/dev/null)
echo "  ✓ Vídeo base: ${DUR}s"

# ── ETAPA 5: Marca d'água ─────────────────────────────────────────────────────
echo ""
echo "[5/5] Aplicando marca d'água..."

if [ -f "$LOGO" ]; then
    ffmpeg -y \
        -i "$TEMP/video_base.mp4" \
        -i "$LOGO" \
        -filter_complex "[1:v]scale=140:-1[wm];[0:v][wm]overlay=W-w-25:H-h-25:format=auto,format=yuv420p" \
        -c:v libx264 -preset medium -crf 18 \
        -c:a aac -b:a 192k \
        "$OUTPUT/video2_maquina_por_dentro_v4_FINAL.mp4" 2>/dev/null
else
    cp "$TEMP/video_base.mp4" "$OUTPUT/video2_maquina_por_dentro_v4_FINAL.mp4"
fi

# ── Relatório ─────────────────────────────────────────────────────────────────
echo ""
echo "============================================"
DURATION=$(ffprobe -v quiet -show_entries format=duration -of csv=p=0 \
    "$OUTPUT/video2_maquina_por_dentro_v4_FINAL.mp4" 2>/dev/null)
DURATION_MIN=$(echo "scale=2; $DURATION/60" | bc)
SIZE=$(du -sh "$OUTPUT/video2_maquina_por_dentro_v4_FINAL.mp4" | cut -f1)
echo "  Arquivo: video2_maquina_por_dentro_v4_FINAL.mp4"
echo "  Duração: ${DURATION_MIN} min  (${DURATION}s)"
echo "  Tamanho: $SIZE  |  Resolução: 1280x720"
echo "  Segmentos: $TOTAL"
echo "  Áudio TH: lip sync original do Beto"
echo "  Áudio SC: silêncio (Beto fala antes/depois)"
echo "  Visual SC: animados — zero prints estáticos"
echo "============================================"

rm -rf "$TEMP"
echo "✅  Vídeo 2 v4 PRONTO!"
