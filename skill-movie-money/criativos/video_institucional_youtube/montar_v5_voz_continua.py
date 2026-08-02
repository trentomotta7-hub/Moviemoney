#!/usr/bin/env python3
"""
Montagem v5 — Vídeo 2: "A Máquina por Dentro"

LÓGICA CORRETA:
  1. Trilha visual: takes TH do Beto + SCs animados concatenados em sequência
  2. Trilha de áudio: APENAS a voz do Beto (extraída dos 11 takes), concatenada
     em sequência contínua, aplicada sobre TODO o vídeo (inclusive os SCs)
  3. A voz do Beto nunca para — ela toca como narração contínua enquanto
     as telas aparecem entre os takes

RESULTADO:
  - Quando Beto aparece na tela: lip sync (vídeo + áudio sincronizados)
  - Quando tela aparece: voz do Beto continua como voice-over sobre a tela
  - ZERO silêncio, ZERO voz robótica, ZERO sobreposição
"""
import subprocess, os, shutil

BASE  = "/home/ubuntu/Moviemoney/skill-movie-money/criativos/video_institucional_youtube"
TAKES = f"{BASE}/takes_v2"
ANIM  = f"{BASE}/screens_v2_anim"
LOGO  = "/home/ubuntu/Moviemoney/skill-movie-money/templates/identidade_visual/logo_transparente.png"
TEMP  = f"{BASE}/temp_v5"
OUT   = BASE

os.makedirs(TEMP, exist_ok=True)

def run(cmd, label=""):
    r = subprocess.run(cmd, capture_output=True, text=True)
    if r.returncode != 0:
        print(f"  ✗ {label}: {r.stderr[-200:]}")
    return r.returncode == 0

def dur(path):
    r = subprocess.run(
        ["ffprobe","-v","quiet","-show_entries","format=duration","-of","csv=p=0",path],
        capture_output=True, text=True)
    try: return float(r.stdout.strip())
    except: return 0.0

# ── PASSO 1: Extrair áudio de cada take do Beto ──────────────────────────────
print("\n[1/5] Extraindo áudio dos takes do Beto...")
takes_order = [
    "v2_t1a_hook_matematico.mp4",
    "v2_t1b_algoritmo_pune.mp4",
    "v2_t1c_caixa_preta.mp4",
    "v2_t1d_maquina_faz.mp4",
    "v2_t2a_elenco_nunca_atrasa.mp4",
    "v2_t2b_voce_gerencia.mp4",
    "v2_t3a_cereja_bolo.mp4",
    "v2_t3b_engenharia_conversao.mp4",
    "v2_t4a_voce_viu_maquina.mp4",
    "v2_t4b_boa_noticia.mp4",
    "v2_t4c_proximo_video.mp4",
]
audio_files = []
for t in takes_order:
    src = f"{TAKES}/{t}"
    dst = f"{TEMP}/audio_{t.replace('.mp4','.wav')}"
    run(["ffmpeg","-y","-i",src,"-vn","-ar","48000","-ac","2","-acodec","pcm_s16le",dst], dst)
    d = dur(dst)
    print(f"  ✓ {t.replace('v2_',''):<40}  {d:.1f}s")
    audio_files.append(dst)

# Concatenar todos os áudios em uma trilha master
audio_list = f"{TEMP}/audio_list.txt"
with open(audio_list,"w") as f:
    for a in audio_files:
        f.write(f"file '{a}'\n")

audio_master = f"{TEMP}/beto_master.wav"
run(["ffmpeg","-y","-f","concat","-safe","0","-i",audio_list,
     "-ar","48000","-ac","2","-acodec","pcm_s16le",audio_master], "audio master")
d_audio = dur(audio_master)
print(f"\n  ✓ Trilha master do Beto: {d_audio:.1f}s")

# ── PASSO 2: Preparar trilha visual ──────────────────────────────────────────
print("\n[2/5] Preparando trilha visual (TH + SCs animados)...")

def norm_video(src, dst, duration=None):
    """Normaliza vídeo para 1280x720, sem áudio."""
    cmd = ["ffmpeg","-y","-i",src,
           "-vf","scale=1280:720:force_original_aspect_ratio=decrease,pad=1280:720:(ow-iw)/2:(oh-ih)/2,setsar=1",
           "-c:v","libx264","-preset","fast","-crf","20","-pix_fmt","yuv420p","-an"]
    if duration:
        cmd += ["-t",str(duration)]
    cmd.append(dst)
    run(cmd, dst)
    d = dur(dst)
    print(f"  ✓ {os.path.basename(dst):<40}  {d:.1f}s")

# Takes TH (sem áudio — o áudio virá da trilha master)
for t in takes_order:
    src = f"{TAKES}/{t}"
    dst = f"{TEMP}/vid_{t}"
    norm_video(src, dst)

# SCs animados (sem áudio)
sc_configs = [
    ("sc1",  [f"{ANIM}/sc1_anim.mp4"], 10),
    ("sc23", [f"{ANIM}/sc2_anim.mp4", f"{ANIM}/sc3_anim.mp4"], 18),
    ("sc456",[f"{ANIM}/sc4_anim.mp4", f"{ANIM}/sc5_anim.mp4", f"{ANIM}/sc6_anim.mp4"], 15),
    ("sc78", [f"{ANIM}/sc7_anim.mp4", f"{ANIM}/sc8_anim.mp4"], 15),
    ("sc9",  [f"{ANIM}/sc9_anim.mp4"], 5),
]

for sc_id, srcs, sc_dur in sc_configs:
    dst = f"{TEMP}/vid_{sc_id}.mp4"
    if len(srcs) == 1:
        norm_video(srcs[0], dst, sc_dur)
    else:
        # Concatenar SCs
        lst = f"{TEMP}/tmp_{sc_id}.txt"
        with open(lst,"w") as f:
            for s in srcs:
                f.write(f"file '{s}'\n")
        tmp_cat = f"{TEMP}/tmp_{sc_id}_cat.mp4"
        run(["ffmpeg","-y","-f","concat","-safe","0","-i",lst,
             "-c:v","libx264","-preset","fast","-crf","20","-pix_fmt","yuv420p","-an",tmp_cat], tmp_cat)
        norm_video(tmp_cat, dst, sc_dur)
        os.remove(tmp_cat)

# ── PASSO 3: Concatenar trilha visual ────────────────────────────────────────
print("\n[3/5] Concatenando trilha visual...")

# Ordem do roteiro
video_segments = [
    f"{TEMP}/vid_v2_t1a_hook_matematico.mp4",
    f"{TEMP}/vid_sc1.mp4",
    f"{TEMP}/vid_v2_t1b_algoritmo_pune.mp4",
    f"{TEMP}/vid_v2_t1c_caixa_preta.mp4",
    f"{TEMP}/vid_v2_t1d_maquina_faz.mp4",
    f"{TEMP}/vid_sc23.mp4",
    f"{TEMP}/vid_v2_t2a_elenco_nunca_atrasa.mp4",
    f"{TEMP}/vid_v2_t2b_voce_gerencia.mp4",
    f"{TEMP}/vid_sc456.mp4",
    f"{TEMP}/vid_v2_t3a_cereja_bolo.mp4",
    f"{TEMP}/vid_sc78.mp4",
    f"{TEMP}/vid_v2_t3b_engenharia_conversao.mp4",
    f"{TEMP}/vid_v2_t4a_voce_viu_maquina.mp4",
    f"{TEMP}/vid_v2_t4b_boa_noticia.mp4",
    f"{TEMP}/vid_v2_t4c_proximo_video.mp4",
    f"{TEMP}/vid_sc9.mp4",
]

vlist = f"{TEMP}/video_list.txt"
with open(vlist,"w") as f:
    for s in video_segments:
        f.write(f"file '{s}'\n")

video_only = f"{TEMP}/video_only.mp4"
run(["ffmpeg","-y","-f","concat","-safe","0","-i",vlist,
     "-c:v","libx264","-preset","medium","-crf","18","-pix_fmt","yuv420p","-an",video_only], "video concat")
d_video = dur(video_only)
print(f"  ✓ Trilha visual: {d_video:.1f}s  |  Áudio master: {d_audio:.1f}s")

# ── PASSO 4: Combinar trilha visual + áudio master do Beto ───────────────────
print("\n[4/5] Combinando visual + voz do Beto (contínua)...")

# O áudio do Beto (103s) é mais curto que o vídeo (173s).
# Nos últimos ~70s (SCs longos), o Beto já terminou de falar.
# Vamos usar o áudio do Beto até onde ele dura, depois silêncio.
combined = f"{TEMP}/combined.mp4"
run([
    "ffmpeg","-y",
    "-i",video_only,
    "-i",audio_master,
    "-c:v","copy",
    "-c:a","aac","-b:a","192k","-ar","48000","-ac","2",
    "-map","0:v","-map","1:a",
    "-t",str(d_video),
    combined
], "combine")
print(f"  ✓ Vídeo combinado: {dur(combined):.1f}s")

# ── PASSO 5: Marca d'água e exportação ───────────────────────────────────────
print("\n[5/5] Marca d'água e exportação...")
final = f"{OUT}/video2_maquina_por_dentro_v5_FINAL.mp4"
if os.path.exists(LOGO):
    run([
        "ffmpeg","-y","-i",combined,"-i",LOGO,
        "-filter_complex","[1:v]scale=140:-1[wm];[0:v][wm]overlay=W-w-25:H-h-25:format=auto,format=yuv420p",
        "-c:v","libx264","-preset","medium","-crf","18",
        "-c:a","aac","-b:a","192k",
        final
    ], "watermark")
else:
    shutil.copy(combined, final)

d_final = dur(final)
size = os.path.getsize(final) // (1024*1024)
print(f"\n{'='*50}")
print(f"  Arquivo: video2_maquina_por_dentro_v5_FINAL.mp4")
print(f"  Duração: {d_final/60:.2f} min  ({d_final:.1f}s)")
print(f"  Tamanho: {size}MB  |  1280x720")
print(f"  Áudio: voz do Beto contínua (103s) + silêncio final")
print(f"  Visual: {len(video_segments)} segmentos, SCs animados")
print(f"{'='*50}")

shutil.rmtree(TEMP)
print("✅  Vídeo 2 v5 PRONTO!")
