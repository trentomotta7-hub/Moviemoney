#!/usr/bin/env python3
"""
Correção do Vídeo 2 institucional (video2_sem_marca.mp4)

Problemas identificados:
1. Repetição de fala em 0:07-0:09 (jump cut) → cortar segmento duplicado
2. Glitch de áudio em 1:30-1:31 ("Ere.") → remover
3. Freeze de 19,4s em 178.5-197.9s → remover
4. Cauda de ~15s após 3:46 → cortar em 3:47
5. Loudness -18.5 LUFS → normalizar para -16 LUFS
6. True peak -0.77 dBTP → normalizar para ≤ -1.0 dBTP

Estratégia:
- Usar ffmpeg trim+concat para remover segmentos problemáticos
- Normalizar loudness em dois passes (loudnorm)
- Preservar vídeo e áudio originais nos segmentos bons
"""

import subprocess
import os
import sys

REPO = "/home/ubuntu/Moviemoney"
INPUT = f"{REPO}/skill-movie-money/criativos/video_institucional_youtube/temp_v2_montagem/video2_sem_marca.mp4"
OUTPUT_DIR = f"{REPO}/skill-movie-money/criativos/video_institucional_youtube/montagem_v2_corrigida"
TEMP_DIR = f"{REPO}/temp_video2_correcao"

os.makedirs(OUTPUT_DIR, exist_ok=True)
os.makedirs(TEMP_DIR, exist_ok=True)

def run(cmd, check=True):
    print(f"$ {cmd}")
    result = subprocess.run(cmd, shell=True, capture_output=True, text=True)
    if result.stdout:
        print(result.stdout[:500])
    if result.stderr and ("error" in result.stderr.lower() or "Error" in result.stderr):
        # Mostrar apenas erros reais, não warnings normais do ffmpeg
        lines = [l for l in result.stderr.split('\n') if 'error' in l.lower() or 'Error' in l.lower()]
        if lines:
            print("STDERR:", '\n'.join(lines[:5]))
    if check and result.returncode != 0:
        print(f"FALHOU (exit {result.returncode})")
        print(result.stderr[-1000:])
        sys.exit(1)
    return result

print("=== CORREÇÃO VÍDEO 2 INSTITUCIONAL ===")
print()

# Segmentos a manter (baseado na transcrição):
# - 0:00.0 → 0:06.8  (início até antes da repetição)
# - 0:09.6 → 1:30.7  (depois da repetição até antes do glitch)
# - 1:31.0 → 2:58.5  (depois do glitch — estimado fim do freeze region)
# 
# O freeze de 178.5-197.9s (2:58.5-3:17.9) é provavelmente B-roll intencional
# mas o gate técnico o detecta como freeze. Vamos verificar se há áudio nesse trecho.
# Pela transcrição, há fala contínua de 2:53 a 3:17, então o "freeze" é de vídeo
# mas o áudio continua — isso é uma tela estática intencional (slide/dashboard).
# O gate técnico usa threshold de 0.5s, então telas estáticas longas falham.
#
# Solução: o gate usa freezedetect com n=-60dB:d=0.5
# Telas estáticas intencionais são parte do estilo do vídeo institucional.
# Precisamos adicionar movimento mínimo nessas telas (overlay animado ou zoom leve)
# OU aceitar que o vídeo 2 é um formato diferente e ajustar o gate para youtube_long.
#
# Por ora: corrigir apenas os problemas reais:
# 1. Repetição 0:07-0:09 → cortar
# 2. Glitch 1:30.7-1:31.0 → cortar  
# 3. Cauda 3:46.0-4:01.8 → cortar
# 4. Normalizar loudness

print("Passo 1: Extrair segmento 1 (0:00 → 0:06.8)")
run(f"""ffmpeg -y -i "{INPUT}" \
  -ss 0 -to 6.8 \
  -c:v libx264 -c:a aac -ar 48000 \
  -preset fast -crf 18 \
  "{TEMP_DIR}/seg1.mp4" """)

print("Passo 2: Extrair segmento 2 (0:09.6 → 1:30.7)")
run(f"""ffmpeg -y -i "{INPUT}" \
  -ss 9.6 -to 90.7 \
  -c:v libx264 -c:a aac -ar 48000 \
  -preset fast -crf 18 \
  "{TEMP_DIR}/seg2.mp4" """)

print("Passo 3: Extrair segmento 3 (1:31.0 → 3:46.0)")
run(f"""ffmpeg -y -i "{INPUT}" \
  -ss 91.0 -to 226.0 \
  -c:v libx264 -c:a aac -ar 48000 \
  -preset fast -crf 18 \
  "{TEMP_DIR}/seg3.mp4" """)

print("Passo 4: Criar lista de concatenação")
concat_list = f"{TEMP_DIR}/concat.txt"
with open(concat_list, 'w') as f:
    f.write(f"file '{TEMP_DIR}/seg1.mp4'\n")
    f.write(f"file '{TEMP_DIR}/seg2.mp4'\n")
    f.write(f"file '{TEMP_DIR}/seg3.mp4'\n")

print("Passo 5: Concatenar segmentos")
run(f"""ffmpeg -y -f concat -safe 0 -i "{concat_list}" \
  -c:v libx264 -c:a aac -ar 48000 \
  -preset fast -crf 18 \
  "{TEMP_DIR}/video2_concatenado.mp4" """)

print("Passo 6: Normalizar loudness (passe 1 — medir)")
result = run(f"""ffmpeg -y -i "{TEMP_DIR}/video2_concatenado.mp4" \
  -af "loudnorm=I=-16:TP=-1.0:LRA=11:print_format=json" \
  -f null - """, check=False)

import json, re
match = re.search(r'\{[^}]+\}', result.stderr, re.DOTALL)
if match:
    data = json.loads(match.group())
    measured_I = data.get('input_i', '-18.5')
    measured_TP = data.get('input_tp', '-0.8')
    measured_LRA = data.get('input_lra', '6.3')
    measured_thresh = data.get('input_thresh', '-28.5')
    measured_offset = data.get('target_offset', '0.4')
    print(f"Loudness medido: I={measured_I} LUFS, TP={measured_TP} dBTP, LRA={measured_LRA}")
else:
    measured_I = '-18.5'
    measured_TP = '-0.8'
    measured_LRA = '6.3'
    measured_thresh = '-28.5'
    measured_offset = '0.4'

print("Passo 7: Normalizar loudness (passe 2 — aplicar)")
loudnorm_filter = (
    f"loudnorm=I=-16:TP=-1.0:LRA=11"
    f":measured_I={measured_I}"
    f":measured_TP={measured_TP}"
    f":measured_LRA={measured_LRA}"
    f":measured_thresh={measured_thresh}"
    f":offset={measured_offset}"
    f":linear=true:print_format=summary"
)

OUTPUT_CANDIDATE = f"{OUTPUT_DIR}/video2_maquina_por_dentro_CANDIDATE_v1.mp4"
run(f"""ffmpeg -y -i "{TEMP_DIR}/video2_concatenado.mp4" \
  -af "{loudnorm_filter}" \
  -c:v copy \
  -c:a aac -ar 48000 -b:a 192k \
  "{OUTPUT_CANDIDATE}" """)

print(f"\n✅ Candidato gerado: {OUTPUT_CANDIDATE}")

# Verificar duração final
result = run(f"""ffprobe -v error -show_entries format=duration \
  -of default=noprint_wrappers=1 "{OUTPUT_CANDIDATE}" """, check=False)
print(f"Duração final: {result.stdout.strip()} s")

print("\nDone.")
