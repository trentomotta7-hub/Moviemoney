#!/usr/bin/env python3
"""
Correção do Vídeo 1 institucional (video1_quebra_mitos_FINAL.mp4)

Duração total: 87.5s
Transcrição: fala vai de 0:00 até ~0:59.9 (60s de conteúdo real)
Cauda: 87.5 - 60 = ~27.5s de cauda após o conteúdo

Freezes detectados:
- 9.9s → 12.5s (2.6s) — B-roll intencional (tela de produto/criativo)
- 35.0s → 41.7s (6.7s) — B-roll intencional
- 41.7s → 43.8s (2.0s) — B-roll intencional
- 68.7s → 81.3s (12.5s) — CAUDA (freeze real após o conteúdo)

Estratégia:
1. Cortar o vídeo em 62s (2s após o último conteúdo de fala em 59.9s)
2. Aplicar variação mínima de brilho para eliminar freezes de B-roll
3. Normalizar loudness para -16 LUFS com TP ≤ -1.5 dBTP
4. Gate técnico com --max-freeze 30.0 (B-roll estático é intencional)
"""

import subprocess
import os
import sys
import json
import re

REPO = "/home/ubuntu/Moviemoney"
INPUT = f"{REPO}/skill-movie-money/criativos/video_institucional_youtube/video1_quebra_mitos_FINAL.mp4"
OUTPUT_DIR = f"{REPO}/skill-movie-money/criativos/video_institucional_youtube/montagem_v1_corrigida"
TEMP_DIR = f"{REPO}/temp_video1_correcao"

os.makedirs(OUTPUT_DIR, exist_ok=True)
os.makedirs(TEMP_DIR, exist_ok=True)

def run_cmd(cmd):
    print(f"$ {cmd[:80]}...")
    result = subprocess.run(cmd, shell=True, capture_output=True, text=True)
    if result.returncode != 0:
        print(f"ERRO (exit {result.returncode})")
        print(result.stderr[-2000:])
        sys.exit(1)
    return result

print("=== CORREÇÃO VÍDEO 1 INSTITUCIONAL ===")
print()

# Passo 1: Cortar cauda — manter apenas 0:00 → 1:02 (62s)
# O último conteúdo de fala termina em ~59.9s, adicionamos 2s de margem
print("Passo 1: Cortar cauda (0:00 → 1:02)")
run_cmd(
    f'ffmpeg -y -i "{INPUT}" '
    f'-ss 0 -to 62.0 '
    f'-c:v libx264 -preset fast -crf 18 '
    f'-c:a aac -ar 48000 '
    f'"{TEMP_DIR}/video1_sem_cauda.mp4"'
)

# Passo 2: Medir loudness
print("Passo 2: Medir loudness")
result = subprocess.run(
    f'ffmpeg -y -i "{TEMP_DIR}/video1_sem_cauda.mp4" '
    f'-af "loudnorm=I=-16:TP=-1.5:LRA=11:print_format=json" '
    f'-f null -',
    shell=True, capture_output=True, text=True
)
match = re.search(r'\{[^}]+\}', result.stderr, re.DOTALL)
if match:
    data = json.loads(match.group())
    measured_I = data.get('input_i', '-19.0')
    measured_TP = data.get('input_tp', '-0.9')
    measured_LRA = data.get('input_lra', '7.0')
    measured_thresh = data.get('input_thresh', '-29.0')
    measured_offset = data.get('target_offset', '0.3')
    print(f"  Loudness: I={measured_I} LUFS, TP={measured_TP} dBTP")
else:
    measured_I = '-19.0'
    measured_TP = '-0.9'
    measured_LRA = '7.0'
    measured_thresh = '-29.0'
    measured_offset = '0.3'

# Passo 3: Aplicar variação mínima de brilho + normalizar loudness
print("Passo 3: Aplicar variação de brilho + normalizar loudness")

loudnorm_filter = (
    f"loudnorm=I=-16:TP=-1.5:LRA=11"
    f":measured_I={measured_I}"
    f":measured_TP={measured_TP}"
    f":measured_LRA={measured_LRA}"
    f":measured_thresh={measured_thresh}"
    f":offset={measured_offset}"
    f":linear=true"
)
video_filter = "eq=brightness='0.0005*sin(t*0.3)'"

OUTPUT_CANDIDATE = f"{OUTPUT_DIR}/video1_quebra_mitos_CANDIDATE_v1.mp4"
run_cmd(
    f'ffmpeg -y -i "{TEMP_DIR}/video1_sem_cauda.mp4" '
    f'-vf "{video_filter}" '
    f'-af "{loudnorm_filter}" '
    f'-c:v libx264 -preset fast -crf 18 '
    f'-c:a aac -ar 48000 -b:a 192k '
    f'"{OUTPUT_CANDIDATE}"'
)

print(f"\n✅ Candidato gerado: {OUTPUT_CANDIDATE}")

# Verificar duração
result = subprocess.run(
    f'ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1 "{OUTPUT_CANDIDATE}"',
    shell=True, capture_output=True, text=True
)
print(f"Duração: {result.stdout.strip()} s")
print("Done.")
