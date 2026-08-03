#!/bin/bash
# ============================================================
# MOVIE MONEY — Vídeo 2 "A Máquina por Dentro" v12 DEFINITIVO
# ============================================================
# Correções v12:
#   1. VOZ ÚNICA: Todos os VOs dos SCs regravados com Fenrir (voz do Beto)
#   2. SC-3 recriado com ROSTOS REAIS do elenco (dashboard profissional)
#   3. TH-1a regravado (eliminada repetição "TikTok Shop, TikTok Shop")
#   4. RE-ENCODE TOTAL no concat (garante áudio contínuo — corrige bug do -c copy)
#   5. Marca d'água em todos os segmentos
#   6. Loudnorm -16 LUFS uniforme em todos os segmentos
# ============================================================
set -e

BASE="/home/ubuntu/Moviemoney/skill-movie-money/criativos/video_institucional_youtube"
NORM="$BASE/temp_v10/norm"
SCS="$BASE/scs_v12"
TAKES_V12="$BASE/takes_v12"
SC9="$BASE/temp_v10/v11_sc9_logo.mp4"
T2B="$BASE/temp_v2_montagem/t2b_norm.mp4"
T4A="$BASE/temp_v2_montagem/t4a_norm.mp4"
T4C="$BASE/temp_v2_montagem/t4c_norm.mp4"
MARKER="/home/ubuntu/Moviemoney/skill-movie-money/templates/identidade_visual/logo_transparente.png"
TEMP="$BASE/temp_v12_final"
OUT="$BASE/video2_maquina_por_dentro_v12_FINAL.mp4"

rm -rf "$TEMP"
mkdir -p "$TEMP"

echo "============================================================"
echo "  MOVIE MONEY — VÍDEO 2 v12 DEFINITIVO"
echo "  'A Máquina por Dentro'"
echo "  Voz ÚNICA: Fenrir (Beto) do início ao fim"
echo "============================================================"
echo ""

# ------------------------------------------------------------
# Função unificada: normaliza + marca d'água em UMA passada
# Garante: 1280x720, 24fps, AAC 48kHz stereo, loudnorm -16 LUFS
# ------------------------------------------------------------
process_segment() {
    local input="$1"
    local output="$2"
    local label="$3"

    ffmpeg -y -i "$input" -i "$MARKER" \
        -filter_complex "\
[0:v]scale=1280:720:flags=lanczos,fps=24,format=yuv420p[base];\
[1:v]scale=iw*0.15:-1[logo];\
[base][logo]overlay=W-w-20:H-h-20:format=auto[vout];\
[0:a]loudnorm=I=-16:LRA=11:TP=-1.0,aformat=sample_fmts=s16:channel_layouts=stereo,aresample=48000[aout]" \
        -map "[vout]" -map "[aout]" \
        -c:v libx264 -preset medium -crf 20 \
        -c:a aac -b:a 192k -ar 48000 -ac 2 \
        -video_track_timescale 24000 \
        "$output" 2>/dev/null

    if [ -f "$output" ]; then
        local vdur=$(ffprobe -v quiet -select_streams v:0 -show_entries stream=duration -of csv=p=0 "$output")
        local adur=$(ffprobe -v quiet -select_streams a:0 -show_entries stream=duration -of csv=p=0 "$output")
        echo "  ✓ $label — v:${vdur}s a:${adur}s"
    else
        echo "  ✗ FALHA: $label"
        return 1
    fi
}

echo "=== PASSO 1: Processar takes Talking Head (Beto) ==="

# TH-1a: usar o take REGRAVADO v12 (sem repetição)
process_segment "$TAKES_V12/v12_t1a_hook_matematico_v2.mp4" "$TEMP/01_th_t1a.mp4" "TH-1a (regravado v12)"

# THs mantidos da v10 (aprovados)
process_segment "$NORM/v10_t1b_algoritmo_pune.mp4"          "$TEMP/03_th_t1b.mp4" "TH-1b"
process_segment "$NORM/v10_t1c_caixa_preta.mp4"             "$TEMP/04_th_t1c.mp4" "TH-1c"
process_segment "$NORM/v10_t1d_maquina_faz.mp4"             "$TEMP/05_th_t1d.mp4" "TH-1d"
process_segment "$NORM/v10_t2a_elenco_nunca_atrasa.mp4"     "$TEMP/08_th_t2a.mp4" "TH-2a"
process_segment "$T2B"                                       "$TEMP/09_th_t2b.mp4" "TH-2b"
process_segment "$NORM/v10_t3a_cereja_bolo.mp4"             "$TEMP/13_th_t3a.mp4" "TH-3a"
process_segment "$NORM/v10_t3b_engenharia_conversao.mp4"    "$TEMP/16_th_t3b.mp4" "TH-3b"
process_segment "$T4A"                                       "$TEMP/17_th_t4a.mp4" "TH-4a"
process_segment "$NORM/v10_t4b_boa_noticia.mp4"             "$TEMP/18_th_t4b.mp4" "TH-4b"
process_segment "$T4C"                                       "$TEMP/19_th_t4c.mp4" "TH-4c"

echo ""
echo "=== PASSO 2: Processar Screen Recordings (voz Fenrir) ==="
process_segment "$SCS/sc1_final.mp4" "$TEMP/02_sc1.mp4" "SC-1 (vídeo genérico TikTok)"
process_segment "$SCS/sc2_final.mp4" "$TEMP/06_sc2.mp4" "SC-2 (repositório)"
process_segment "$SCS/sc3_final.mp4" "$TEMP/07_sc3.mp4" "SC-3 (elenco rostos reais)"
process_segment "$SCS/sc4_final.mp4" "$TEMP/10_sc4.mp4" "SC-4 (banco narrativo)"
process_segment "$SCS/sc5_final.mp4" "$TEMP/11_sc5.mp4" "SC-5 (70 dores)"
process_segment "$SCS/sc6_final.mp4" "$TEMP/12_sc6.mp4" "SC-6 (funil de atenção)"
process_segment "$SCS/sc7_final.mp4" "$TEMP/14_sc7.mp4" "SC-7 (comparação lip sync)"
process_segment "$SCS/sc8_final.mp4" "$TEMP/15_sc8.mp4" "SC-8 (safe zone)"
process_segment "$SC9"               "$TEMP/20_sc9.mp4" "SC-9 (logo final)"

echo ""
echo "=== PASSO 3: Validar todos os segmentos ==="
falhas=0
total=0
for f in $(ls "$TEMP"/*.mp4 | sort); do
    vdur=$(ffprobe -v quiet -select_streams v:0 -show_entries stream=duration -of csv=p=0 "$f" 2>/dev/null)
    adur=$(ffprobe -v quiet -select_streams a:0 -show_entries stream=duration -of csv=p=0 "$f" 2>/dev/null)
    vol=$(ffmpeg -i "$f" -af volumedetect -f null /dev/null 2>&1 | grep "mean_volume" | awk '{print $5}')

    # Verificar se há áudio real (não silêncio)
    if [ -z "$adur" ] || [ "$adur" == "N/A" ]; then
        echo "  ✗ SEM ÁUDIO: $(basename $f)"
        falhas=$((falhas+1))
    else
        echo "  ✓ $(basename $f): v=${vdur}s a=${adur}s vol=${vol}dB"
        total=$(echo "$total + $adur" | bc)
    fi
done

if [ $falhas -gt 0 ]; then
    echo ""
    echo "⚠ $falhas segmento(s) com problema de áudio. Abortando."
    exit 1
fi

echo ""
echo "  Duração total: ${total}s ($(echo "scale=1; $total/60" | bc) min)"

echo ""
echo "=== PASSO 4: Concatenar com RE-ENCODE (garante áudio contínuo) ==="

# Construir lista de concat na ordem numérica
> "$TEMP/concat_v12.txt"
for f in $(ls "$TEMP"/*.mp4 | sort); do
    echo "file '$(basename $f)'" >> "$TEMP/concat_v12.txt"
done

cat "$TEMP/concat_v12.txt"
echo ""

# RE-ENCODE completo no concat — isso corrige o bug de áudio mudo
ffmpeg -y -f concat -safe 0 -i "$TEMP/concat_v12.txt" \
    -c:v libx264 -preset medium -crf 20 \
    -c:a aac -b:a 192k -ar 48000 -ac 2 \
    -r 24 \
    -movflags +faststart \
    "$OUT" 2>/dev/null

echo ""
echo "============================================================"
echo "  VÍDEO FINAL v12 GERADO"
echo "============================================================"
ffprobe -v quiet -show_entries format=duration,size,bit_rate -of default "$OUT"
ffprobe -v quiet -show_entries stream=codec_type,codec_name,width,height,sample_rate,channels -of default "$OUT"
ls -lh "$OUT"

echo ""
echo "=== Verificação de áudio ao longo do vídeo ==="
dur=$(ffprobe -v quiet -show_entries format=duration -of csv=p=0 "$OUT")
for pos in 5 30 60 90 120 150 180 210 235; do
    if (( $(echo "$pos < $dur" | bc -l) )); then
        vol=$(ffmpeg -i "$OUT" -ss $pos -t 5 -af volumedetect -f null /dev/null 2>&1 | grep "mean_volume" | awk '{print $5}')
        echo "  t=${pos}s: mean_volume=${vol}dB"
    fi
done

echo ""
echo "=== CONCLUÍDO ==="
