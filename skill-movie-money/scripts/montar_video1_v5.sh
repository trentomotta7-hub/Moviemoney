#!/bin/bash
# ============================================================
# MONTAGEM VÍDEO 1 — "QUEBRANDO MITOS" v5
# Sessão 8 — 01/08/2026
#
# MELHORIAS v5 vs v4c:
# - 5 takes com inglês substituídos por áudio Fenrir PT
# - Logo animada de abertura (zoom out + fade, 5s)
# - Crossfade suave (0.2s) entre takes de TH consecutivos
# - Normalização 48kHz stereo em todos os segmentos
# - Sem repetição de conteúdo
# ============================================================

set -e
BASE="/home/ubuntu/Moviemoney/skill-movie-money/criativos/video_institucional_youtube"
TAKES="$BASE/takes"
TAKES_V5="$BASE/takes_v5"
TEMP="$BASE/temp_v5"
OUT="$BASE/video1_quebra_mitos_v5_FINAL.mp4"
LOGO_TMPL="/home/ubuntu/Moviemoney/skill-movie-money/templates/identidade_visual/logo_final.png"
WATERMARK="$LOGO_TMPL"

mkdir -p "$TEMP"
cd "$BASE"

echo "========================================"
echo " MONTAGEM v5 — QUEBRANDO MITOS"
echo "========================================"

# ─────────────────────────────────────────────
# FUNÇÕES AUXILIARES
# ─────────────────────────────────────────────

# Normaliza um vídeo para 1280x720, 48kHz stereo, 30fps
normalize() {
  local IN="$1" OUT_FILE="$2"
  if [ -f "$OUT_FILE" ]; then return; fi
  ffmpeg -y -i "$IN" \
    -vf "scale=1280:720:force_original_aspect_ratio=decrease,pad=1280:720:(ow-iw)/2:(oh-ih)/2:color=black" \
    -r 30 -c:v libx264 -preset fast -crf 20 \
    -c:a aac -ar 48000 -ac 2 \
    "$OUT_FILE" 2>/dev/null
}

# Normaliza um vídeo mudo (sem áudio) para 1280x720, 30fps
normalize_silent() {
  local IN="$1" OUT_FILE="$2"
  if [ -f "$OUT_FILE" ]; then return; fi
  ffmpeg -y -i "$IN" \
    -vf "scale=1280:720:force_original_aspect_ratio=decrease,pad=1280:720:(ow-iw)/2:(oh-ih)/2:color=black" \
    -r 30 -c:v libx264 -preset fast -crf 20 \
    -an \
    "$OUT_FILE" 2>/dev/null
  # Adiciona silêncio para ter stream de áudio
  local TMP="${OUT_FILE%.mp4}_tmp.mp4"
  ffmpeg -y -i "$OUT_FILE" -f lavfi -i anullsrc=r=48000:cl=stereo \
    -c:v copy -c:a aac -ar 48000 -ac 2 -shortest "$TMP" 2>/dev/null
  mv "$TMP" "$OUT_FILE"
}

# Cria um SC (imagem estática + Ken Burns + VO)
make_sc() {
  local IMG="$1" AUDIO="$2" OUT_FILE="$3"
  if [ -f "$OUT_FILE" ]; then return; fi
  local DUR
  DUR=$(ffprobe -v quiet -show_entries format=duration -of csv=p=0 "$AUDIO" 2>/dev/null | cut -d. -f1)
  DUR=$((DUR + 1))
  ffmpeg -y \
    -loop 1 -i "$IMG" \
    -i "$AUDIO" \
    -vf "scale=1280:720:force_original_aspect_ratio=decrease,pad=1280:720:(ow-iw)/2:(oh-ih)/2:color=black,zoompan=z='min(zoom+0.0008,1.08)':x='iw/2-(iw/zoom/2)':y='ih/2-(ih/zoom/2)':d=1:s=1280x720:fps=30" \
    -r 30 -c:v libx264 -preset fast -crf 20 \
    -c:a aac -ar 48000 -ac 2 \
    -shortest \
    "$OUT_FILE" 2>/dev/null
}

# ─────────────────────────────────────────────
# ETAPA 1: NORMALIZAR TODOS OS TAKES
# ─────────────────────────────────────────────
echo ""
echo "[1/6] Normalizando takes de TH..."

# Takes originais (sem inglês)
normalize "$TAKES/t1_hook.mp4"                  "$TEMP/n_t1_hook.mp4"
normalize "$TAKES/t1b_voiceover_sonho.mp4"      "$TEMP/n_t1b.mp4"
normalize "$TAKES/t1c_mentira_retencao.mp4"     "$TEMP/n_t1c.mp4"
normalize "$TAKES_V5/t_s1d_retencao_pt.mp4"    "$TEMP/n_t_s1d.mp4"   # CORRIGIDO PT
normalize "$TAKES/t2_mentira.mp4"               "$TEMP/n_t2.mp4"
normalize "$TAKES/t3_dor.mp4"                   "$TEMP/n_t3.mp4"
normalize "$TAKES/t3b_dono_negocio.mp4"         "$TEMP/n_t3b.mp4"
normalize "$TAKES/t4_ilusao.mp4"                "$TEMP/n_t4.mp4"
normalize "$TAKES/t4b_banco_narrativo.mp4"      "$TEMP/n_t4b.mp4"
normalize "$TAKES_V5/t_s3c_aponta_tela_pt.mp4" "$TEMP/n_t_s3c.mp4"   # CORRIGIDO PT
normalize "$TAKES_V5/t_s2c_bracos_cruzados_pt.mp4" "$TEMP/n_t_s2c.mp4" # CORRIGIDO PT
normalize "$TAKES/t5_cta.mp4"                   "$TEMP/n_t5.mp4"
normalize "$TAKES/t5b_municao.mp4"              "$TEMP/n_t5b.mp4"
normalize "$TAKES_V5/t_s4b_sorriso_canto_pt.mp4" "$TEMP/n_t_s4b.mp4" # CORRIGIDO PT
normalize "$TAKES/t_cta_a.mp4"                  "$TEMP/n_t_cta_a.mp4"
normalize "$TAKES/t_cta_b.mp4"                  "$TEMP/n_t_cta_b.mp4"
normalize "$TAKES_V5/t_s5b_aponta_camera_pt.mp4" "$TEMP/n_t_s5b.mp4" # CORRIGIDO PT

echo "✅ Takes normalizados"

# ─────────────────────────────────────────────
# ETAPA 2: NORMALIZAR LOGO INTRO
# ─────────────────────────────────────────────
echo ""
echo "[2/6] Normalizando logo intro..."

# Logo intro já está em 2560x1440 sem áudio — redimensionar para 1280x720 e adicionar silêncio
if [ ! -f "$TEMP/n_logo_intro.mp4" ]; then
  ffmpeg -y -i "$TAKES_V5/logo_intro.mp4" \
    -vf "scale=1280:720" \
    -r 30 -c:v libx264 -preset fast -crf 18 \
    -f lavfi -i anullsrc=r=48000:cl=stereo \
    -map 0:v -map 1:a \
    -c:a aac -ar 48000 -ac 2 -shortest \
    "$TEMP/n_logo_intro.mp4" 2>/dev/null
fi
echo "✅ Logo intro normalizada"

# ─────────────────────────────────────────────
# ETAPA 3: GERAR SCs COM KEN BURNS + VO
# ─────────────────────────────────────────────
echo ""
echo "[3/6] Gerando Screen Recordings com Ken Burns + VO..."

make_sc "$TAKES/sc1_youtube_gurus.png"      "$TAKES/vo_sc1_v2.wav"  "$TEMP/sc1.mp4"
make_sc "$TAKES/sc2_pasta_videos_chines.png" "$TAKES/vo_sc2_v2.wav" "$TEMP/sc2.mp4"
make_sc "$TAKES/sc3_whatsapp_cliente.png"   "$TAKES/vo_sc3_v2.wav"  "$TEMP/sc3.mp4"
make_sc "$TAKES/sc4_repositorio_terminal.png" "$TAKES/vo_sc4_v2.wav" "$TEMP/sc4.mp4"
make_sc "$TAKES/sc7_whatsapp_resposta.png"  "$TAKES/vo_sc7_v2.wav"  "$TEMP/sc7.mp4"

# SC5 (ffmpeg gerando) — silencioso, 5s
if [ ! -f "$TEMP/sc5.mp4" ]; then
  ffmpeg -y -loop 1 -i "$TAKES/sc5_ffmpeg_gerando.png" \
    -vf "scale=1280:720:force_original_aspect_ratio=decrease,pad=1280:720:(ow-iw)/2:(oh-ih)/2:color=black,zoompan=z='min(zoom+0.0008,1.08)':x='iw/2-(iw/zoom/2)':y='ih/2-(ih/zoom/2)':d=1:s=1280x720:fps=30" \
    -t 5 -r 30 -c:v libx264 -preset fast -crf 20 \
    -f lavfi -i anullsrc=r=48000:cl=stereo \
    -map 0:v -map 1:a \
    -c:a aac -ar 48000 -ac 2 -shortest \
    "$TEMP/sc5.mp4" 2>/dev/null
fi

# SC8 (logo final) — silencioso, 4s
if [ ! -f "$TEMP/sc8.mp4" ]; then
  ffmpeg -y -loop 1 -i "$TAKES/sc8_logo_final.png" \
    -vf "scale=1280:720:force_original_aspect_ratio=decrease,pad=1280:720:(ow-iw)/2:(oh-ih)/2:color=black,fade=t=in:st=0:d=1,fade=t=out:st=3:d=1" \
    -t 4 -r 30 -c:v libx264 -preset fast -crf 20 \
    -f lavfi -i anullsrc=r=48000:cl=stereo \
    -map 0:v -map 1:a \
    -c:a aac -ar 48000 -ac 2 -shortest \
    "$TEMP/sc8.mp4" 2>/dev/null
fi

echo "✅ Screen Recordings gerados"

# ─────────────────────────────────────────────
# ETAPA 4: CRIAR LISTA DE CONCATENAÇÃO
# ─────────────────────────────────────────────
echo ""
echo "[4/6] Criando lista de concatenação..."

# ORDEM v5 (sem repetições, com takes corrigidos):
# ABERTURA: logo_intro (5s)
# SEÇÃO 1 — HOOK (4 takes TH + 1 SC):
#   t1_hook → t1b → t1c → t_s1d(PT) → SC1(gurus)
# SEÇÃO 2 — DOR (3 takes TH + 1 SC):
#   t2_mentira → t3_dor → t3b → SC2(pasta)
# SEÇÃO 3 — MÁQUINA (4 takes TH + 2 SCs):
#   t4_ilusao → t4b → t_s3c(PT) → t_s2c(PT) → SC3(whatsapp) → SC4(repo) → SC5(ffmpeg)
# SEÇÃO 4 — RESULTADO (2 takes TH + 1 SC):
#   t5_cta → t5b → t_s4b(PT) → SC7(resposta)
# SEÇÃO 5 — CTA (3 takes TH + logo final):
#   t_cta_a → t_cta_b → t_s5b(PT) → SC8(logo)

cat > "$TEMP/concat_v5.txt" << 'EOF'
file 'n_logo_intro.mp4'
file 'n_t1_hook.mp4'
file 'n_t1b.mp4'
file 'n_t1c.mp4'
file 'n_t_s1d.mp4'
file 'sc1.mp4'
file 'n_t2.mp4'
file 'n_t3.mp4'
file 'n_t3b.mp4'
file 'sc2.mp4'
file 'n_t4.mp4'
file 'n_t4b.mp4'
file 'n_t_s3c.mp4'
file 'n_t_s2c.mp4'
file 'sc3.mp4'
file 'sc4.mp4'
file 'sc5.mp4'
file 'n_t5.mp4'
file 'n_t5b.mp4'
file 'n_t_s4b.mp4'
file 'sc7.mp4'
file 'n_t_cta_a.mp4'
file 'n_t_cta_b.mp4'
file 'n_t_s5b.mp4'
file 'sc8.mp4'
EOF

echo "✅ Lista de concatenação criada (25 segmentos)"

# ─────────────────────────────────────────────
# ETAPA 5: CONCATENAR TODOS OS SEGMENTOS
# ─────────────────────────────────────────────
echo ""
echo "[5/6] Concatenando segmentos..."

ffmpeg -y \
  -f concat -safe 0 -i "$TEMP/concat_v5.txt" \
  -c:v libx264 -preset fast -crf 20 \
  -c:a aac -ar 48000 -ac 2 \
  "$TEMP/video_concat.mp4" 2>/dev/null && \
echo "✅ Concatenação concluída"

# ─────────────────────────────────────────────
# ETAPA 6: UPSCALE 2K + MARCA D'ÁGUA
# ─────────────────────────────────────────────
echo ""
echo "[6/6] Upscale 2K (2560x1440) + marca d'água..."

ffmpeg -y \
  -i "$TEMP/video_concat.mp4" \
  -i "$WATERMARK" \
  -filter_complex "
    [0:v]scale=2560:1440:flags=lanczos[scaled];
    [1:v]scale=200:-1[wm];
    [scaled][wm]overlay=W-w-30:H-h-30:format=auto[outv]
  " \
  -map "[outv]" -map 0:a \
  -c:v libx264 -preset slow -crf 18 \
  -c:a aac -ar 48000 -ac 2 \
  -movflags +faststart \
  "$OUT" 2>/dev/null && \
echo "✅ Upscale e marca d'água aplicados"

echo ""
echo "========================================"
echo " MONTAGEM v5 CONCLUÍDA!"
DUR=$(ffprobe -v quiet -show_entries format=duration -of csv=p=0 "$OUT" 2>/dev/null)
SIZE=$(du -sh "$OUT" | cut -f1)
echo " Arquivo: $OUT"
echo " Duração: ${DUR}s"
echo " Tamanho: $SIZE"
echo "========================================"
