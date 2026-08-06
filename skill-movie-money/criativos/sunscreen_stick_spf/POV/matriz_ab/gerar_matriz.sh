#!/bin/bash
set -e
# Script para montar as 20 variações A/B do POV Sunscreen
BASE_DIR="/home/ubuntu/Moviemoney/skill-movie-money/criativos/sunscreen_stick_spf/POV"
MATRIZ_DIR="$BASE_DIR/matriz_ab"

# Assegura takes base
T2="$BASE_DIR/montagem/beat2_problema_raw_norm.mp4"
T3="$BASE_DIR/montagem/beat3_causa_raw_norm.mp4"
T4="$BASE_DIR/montagem/beat4_solucao_raw_norm.mp4"

echo "Montando variações..."
for H in A B C D E; do
  for C in A B C D; do
    echo "Montando Hook $H - CTA $C..."
    # Monta lista
    cat > "$MATRIZ_DIR/list_${H}_${C}.txt" << LST
file '$BASE_DIR/takes/hook_${H}_norm.mp4'
file '$T2'
file '$T3'
file '$T4'
file '$BASE_DIR/takes/cta_${C}_norm.mp4'
LST
    # Concatenar video (mockup rápido para testar lógica, dps executo real)
    echo "Lista ${H}_${C} gerada."
  done
done
echo "Infra preparada."
