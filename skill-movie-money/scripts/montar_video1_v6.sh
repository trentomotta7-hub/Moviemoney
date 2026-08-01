#!/bin/bash
# ============================================================
# MONTAGEM VÍDEO 1 — "QUEBRANDO MITOS" v6
# Sessão 9 — 01/08/2026
#
# MELHORIAS v6 vs v5:
# - Crossfade visual suave (0.3s) entre TODOS os takes de TH
# - Eliminação das repetições de frases detectadas na transcrição:
#     * "Eles te vendem o sonho perfeito" aparecia 2x → removido t_s1d
#       (o SC1 já cobre essa seção com VO)
#     * "A gente entrega a munição" aparecia 3x → removido t_s4b
#       (o SC7 já tem o VO completo dessa frase)
#     * "Vem ver como os profissionais jogam" aparecia 2x → removido t_s5b
#       (t_cta_b já encerra com essa frase)
#     * "Minerar o produto é só 10%" aparecia 3x → removido t_s3c
#       (t4b já cobre esse conteúdo)
#     * "Venda na internet é uma questão de ótica" aparecia 2x → removido t_s2c
#       (t4_ilusao já cobre esse conteúdo)
#
# NOVA ORDEM (20 segmentos, sem repetição):
# logo_intro → t1_hook → t1b → t1c → SC1(gurus)
# → t2_mentira → t3_dor → t3b → SC2(pasta)
# → t4_ilusao → t4b → SC3(whatsapp) → SC4(repo) → SC5(ffmpeg)
# → t5_cta → t5b → SC7(resposta)
# → t_cta_a → t_cta_b → SC8(logo)
# ============================================================

set -e
BASE="/home/ubuntu/Moviemoney/skill-movie-money/criativos/video_institucional_youtube"
TEMP="$BASE/temp_v5"   # reutiliza os segmentos normalizados da v5
TEMP6="$BASE/temp_v6"
OUT="$BASE/video1_quebra_mitos_v6_FINAL.mp4"
WATERMARK="/home/ubuntu/Moviemoney/skill-movie-money/templates/identidade_visual/logo_final.png"

mkdir -p "$TEMP6"
cd "$BASE"

echo "========================================"
echo " MONTAGEM v6 — QUEBRANDO MITOS"
echo " Crossfade + Zero Repetições"
echo "========================================"

# ─────────────────────────────────────────────
# LISTA DE SEGMENTOS TH (sem repetições)
# ─────────────────────────────────────────────
# Seção 1 — Hook: t1_hook(10s) + t1b(8s) + t1c(10s) = 28s
# Seção 2 — Dor:  t2(10s) + t3(10s) + t3b(8s) = 28s
# Seção 3 — Máquina: t4(10s) + t4b(10s) = 20s
# Seção 4 — Resultado: t5(10s) + t5b(6s) = 16s
# Seção 5 — CTA: t_cta_a(10s) + t_cta_b(8s) = 18s
# Total TH puro: 110s

# Segmentos TH em ordem (sem os 5 takes de gesto que causavam repetição)
TH_SEGS=(
  "$TEMP/n_t1_hook.mp4"
  "$TEMP/n_t1b.mp4"
  "$TEMP/n_t1c.mp4"
  "$TEMP/n_t2.mp4"
  "$TEMP/n_t3.mp4"
  "$TEMP/n_t3b.mp4"
  "$TEMP/n_t4.mp4"
  "$TEMP/n_t4b.mp4"
  "$TEMP/n_t5.mp4"
  "$TEMP/n_t5b.mp4"
  "$TEMP/n_t_cta_a.mp4"
  "$TEMP/n_t_cta_b.mp4"
)

# ─────────────────────────────────────────────
# ETAPA 1: APLICAR XFADE ENTRE TODOS OS TAKES TH
# ─────────────────────────────────────────────
echo ""
echo "[1/4] Aplicando crossfade visual entre takes de TH..."

# Estratégia: encadear xfade progressivamente
# xfade offset = soma das durações anteriores - 0.3 (overlap)
# Resultado: bloco_th_xfade.mp4 com transições suaves

XFADE_DUR=0.3

# Calcular offsets acumulados
declare -a DURS
for i in "${!TH_SEGS[@]}"; do
  DURS[$i]=$(ffprobe -v quiet -show_entries format=duration -of csv=p=0 "${TH_SEGS[$i]}" 2>/dev/null)
done

# Construir o filter_complex com xfade encadeado
# Começa com [0:v][1:v]xfade → [v01], depois [v01][2:v]xfade → [v012], etc.
INPUTS=""
for seg in "${TH_SEGS[@]}"; do
  INPUTS="$INPUTS -i $seg"
done

# Calcular offsets
OFFSET=$(echo "${DURS[0]} - $XFADE_DUR" | bc)
FILTER="[0:v][1:v]xfade=transition=fade:duration=${XFADE_DUR}:offset=${OFFSET}[v01]"
AUDIO_FILTER="[0:a][1:a]acrossfade=d=${XFADE_DUR}[a01]"

RUNNING_DUR=$(echo "${DURS[0]} + ${DURS[1]} - $XFADE_DUR" | bc)

for i in $(seq 2 $((${#TH_SEGS[@]} - 1))); do
  PREV_IDX=$((i - 1))
  OFFSET=$(echo "$RUNNING_DUR - $XFADE_DUR" | bc)
  
  if [ $i -eq 2 ]; then
    FILTER="$FILTER; [v01][$i:v]xfade=transition=fade:duration=${XFADE_DUR}:offset=${OFFSET}[v0${i}]"
    AUDIO_FILTER="$AUDIO_FILTER; [a01][$i:a]acrossfade=d=${XFADE_DUR}[a0${i}]"
  else
    FILTER="$FILTER; [v0${PREV_IDX}][$i:v]xfade=transition=fade:duration=${XFADE_DUR}:offset=${OFFSET}[v0${i}]"
    AUDIO_FILTER="$AUDIO_FILTER; [a0${PREV_IDX}][$i:a]acrossfade=d=${XFADE_DUR}[a0${i}]"
  fi
  
  RUNNING_DUR=$(echo "$RUNNING_DUR + ${DURS[$i]} - $XFADE_DUR" | bc)
done

LAST_IDX=$((${#TH_SEGS[@]} - 1))
FULL_FILTER="${FILTER}; ${AUDIO_FILTER}"

echo "  Gerando bloco TH com xfade (${#TH_SEGS[@]} takes, ~${RUNNING_DUR}s)..."

ffmpeg -y $INPUTS \
  -filter_complex "$FULL_FILTER" \
  -map "[v0${LAST_IDX}]" -map "[a0${LAST_IDX}]" \
  -c:v libx264 -preset fast -crf 20 \
  -c:a aac -ar 48000 -ac 2 \
  "$TEMP6/bloco_th_xfade.mp4" 2>/dev/null

DUR_TH=$(ffprobe -v quiet -show_entries format=duration -of csv=p=0 "$TEMP6/bloco_th_xfade.mp4" 2>/dev/null)
echo "✅ bloco_th_xfade.mp4 → ${DUR_TH}s"

# ─────────────────────────────────────────────
# ETAPA 2: MONTAR VÍDEO COMPLETO COM BLOCOS
# ─────────────────────────────────────────────
echo ""
echo "[2/4] Montando vídeo completo com blocos intercalados..."

# Estrutura final v6:
# [logo_intro] [TH_S1: hook 3 takes] [SC1] [TH_S2: dor 3 takes] [SC2]
# [TH_S3: maquina 2 takes] [SC3] [SC4] [SC5]
# [TH_S4: resultado 2 takes] [SC7]
# [TH_S5: cta 2 takes] [SC8]
#
# Para intercalar corretamente, vamos cortar o bloco_th_xfade nos pontos certos
# e inserir os SCs entre eles.

# Durações dos blocos TH (com overlap de 0.3s cada transição)
# S1: t1(10) + t1b(8) + t1c(10) - 2*0.3 = 27.4s
# S2: t2(10) + t3(10) + t3b(8) - 2*0.3 = 27.4s
# S3: t4(10) + t4b(10) - 1*0.3 = 19.7s
# S4: t5(10) + t5b(6) - 1*0.3 = 15.7s
# S5: t_cta_a(10) + t_cta_b(8) - 1*0.3 = 17.7s

S1_DUR=27.4
S2_START=$S1_DUR
S2_DUR=27.4
S3_START=$(echo "$S1_DUR + $S2_DUR" | bc)
S3_DUR=19.7
S4_START=$(echo "$S3_START + $S3_DUR" | bc)
S4_DUR=15.7
S5_START=$(echo "$S4_START + $S4_DUR" | bc)
S5_DUR=17.7

echo "  Cortando blocos TH..."
# Bloco S1 — Hook
ffmpeg -y -i "$TEMP6/bloco_th_xfade.mp4" -ss 0 -t $S1_DUR \
  -c:v libx264 -preset fast -crf 20 -c:a aac -ar 48000 -ac 2 \
  "$TEMP6/th_s1.mp4" 2>/dev/null && echo "  ✅ th_s1.mp4 (${S1_DUR}s)"

# Bloco S2 — Dor
ffmpeg -y -i "$TEMP6/bloco_th_xfade.mp4" -ss $S2_START -t $S2_DUR \
  -c:v libx264 -preset fast -crf 20 -c:a aac -ar 48000 -ac 2 \
  "$TEMP6/th_s2.mp4" 2>/dev/null && echo "  ✅ th_s2.mp4 (${S2_DUR}s)"

# Bloco S3 — Máquina
ffmpeg -y -i "$TEMP6/bloco_th_xfade.mp4" -ss $S3_START -t $S3_DUR \
  -c:v libx264 -preset fast -crf 20 -c:a aac -ar 48000 -ac 2 \
  "$TEMP6/th_s3.mp4" 2>/dev/null && echo "  ✅ th_s3.mp4 (${S3_DUR}s)"

# Bloco S4 — Resultado
ffmpeg -y -i "$TEMP6/bloco_th_xfade.mp4" -ss $S4_START -t $S4_DUR \
  -c:v libx264 -preset fast -crf 20 -c:a aac -ar 48000 -ac 2 \
  "$TEMP6/th_s4.mp4" 2>/dev/null && echo "  ✅ th_s4.mp4 (${S4_DUR}s)"

# Bloco S5 — CTA
ffmpeg -y -i "$TEMP6/bloco_th_xfade.mp4" -ss $S5_START -t $S5_DUR \
  -c:v libx264 -preset fast -crf 20 -c:a aac -ar 48000 -ac 2 \
  "$TEMP6/th_s5.mp4" 2>/dev/null && echo "  ✅ th_s5.mp4 (${S5_DUR}s)"

# ─────────────────────────────────────────────
# ETAPA 3: CONCATENAÇÃO FINAL
# ─────────────────────────────────────────────
echo ""
echo "[3/4] Concatenando segmentos finais..."

cat > "$TEMP6/concat_v6.txt" << EOF
file '$TEMP/n_logo_intro.mp4'
file '$TEMP6/th_s1.mp4'
file '$TEMP/sc1.mp4'
file '$TEMP6/th_s2.mp4'
file '$TEMP/sc2.mp4'
file '$TEMP6/th_s3.mp4'
file '$TEMP/sc3.mp4'
file '$TEMP/sc4.mp4'
file '$TEMP/sc5.mp4'
file '$TEMP6/th_s4.mp4'
file '$TEMP/sc7.mp4'
file '$TEMP6/th_s5.mp4'
file '$TEMP/sc8.mp4'
EOF

ffmpeg -y \
  -f concat -safe 0 -i "$TEMP6/concat_v6.txt" \
  -c:v libx264 -preset fast -crf 20 \
  -c:a aac -ar 48000 -ac 2 \
  "$TEMP6/video_concat.mp4" 2>/dev/null

DUR_CONCAT=$(ffprobe -v quiet -show_entries format=duration -of csv=p=0 "$TEMP6/video_concat.mp4" 2>/dev/null)
echo "✅ Concatenação concluída → ${DUR_CONCAT}s"

# ─────────────────────────────────────────────
# ETAPA 4: UPSCALE 2K + MARCA D'ÁGUA
# ─────────────────────────────────────────────
echo ""
echo "[4/4] Upscale 2K (2560x1440) + marca d'água..."

ffmpeg -y \
  -i "$TEMP6/video_concat.mp4" \
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
  "$OUT" 2>/dev/null

echo ""
DUR=$(ffprobe -v quiet -show_entries format=duration -of csv=p=0 "$OUT" 2>/dev/null)
SIZE=$(du -sh "$OUT" | cut -f1)
echo "========================================"
echo " MONTAGEM v6 CONCLUÍDA!"
echo " Arquivo: $OUT"
echo " Duração: ${DUR}s"
echo " Tamanho: $SIZE"
echo "========================================"
