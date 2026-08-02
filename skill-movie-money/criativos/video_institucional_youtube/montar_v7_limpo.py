#!/usr/bin/env python3
"""
Montagem v7 — pasta temporária isolada, apenas os 20 segmentos do roteiro.
"""
import subprocess, os, shutil, tempfile

BASE  = "/home/ubuntu/Moviemoney/skill-movie-money/criativos/video_institucional_youtube"
TH    = f"{BASE}/takes_v2"
VO    = f"{BASE}/takes_v2_vo"
SC    = f"{BASE}/screens_v2_anim"
LOGO  = "/home/ubuntu/Moviemoney/skill-movie-money/templates/identidade_visual/logo_transparente.png"
TEMP  = "/tmp/mm_v7_build"   # pasta completamente isolada
OUT   = BASE

shutil.rmtree(TEMP, ignore_errors=True)
os.makedirs(TEMP)

def run(cmd, label=""):
    r = subprocess.run(cmd, capture_output=True, text=True)
    if r.returncode != 0:
        print(f"  ✗ {label}: {r.stderr[-300:]}")
    return r.returncode == 0

def dur(path):
    r = subprocess.run(
        ["ffprobe","-v","quiet","-show_entries","format=duration","-of","csv=p=0",path],
        capture_output=True, text=True)
    try: return float(r.stdout.strip())
    except: return 0.0

def norm_th(src, name):
    dst = f"{TEMP}/{name}"
    run(["ffmpeg","-y","-i",src,
         "-vf","scale=1280:720:force_original_aspect_ratio=decrease,pad=1280:720:(ow-iw)/2:(oh-ih)/2,setsar=1",
         "-c:v","libx264","-preset","fast","-crf","20","-pix_fmt","yuv420p",
         "-c:a","aac","-b:a","192k","-ar","48000","-ac","2",dst], name)
    d = dur(dst)
    print(f"  ✓ TH {name:<40}  {d:.1f}s")
    return dst

def sc_with_vo(sc_src, vo_src, name):
    """SC animado + áudio do take VO do Beto."""
    dst = f"{TEMP}/{name}"
    vo_dur = dur(vo_src)
    
    audio_tmp = f"{TEMP}/_a_{name}.wav"
    sc_tmp    = f"{TEMP}/_v_{name}.mp4"
    
    run(["ffmpeg","-y","-i",vo_src,"-vn","-ar","48000","-ac","2","-acodec","pcm_s16le",audio_tmp], "extract audio")
    run(["ffmpeg","-y","-i",sc_src,
         "-vf","scale=1280:720:force_original_aspect_ratio=decrease,pad=1280:720:(ow-iw)/2:(oh-ih)/2,setsar=1",
         "-t",str(vo_dur),"-c:v","libx264","-preset","fast","-crf","20","-pix_fmt","yuv420p","-an",
         sc_tmp], "scale sc")
    run(["ffmpeg","-y","-i",sc_tmp,"-i",audio_tmp,
         "-c:v","copy","-c:a","aac","-b:a","192k",
         "-map","0:v","-map","1:a","-t",str(vo_dur),dst], name)
    
    os.remove(audio_tmp)
    os.remove(sc_tmp)
    d = dur(dst)
    print(f"  ✓ SC+VO {name:<37}  {d:.1f}s")
    return dst

def logo_seg(sc_src, name, duration=5):
    """Logo final com fade, sem áudio."""
    dst = f"{TEMP}/{name}"
    vis = f"{TEMP}/_vis_{name}.mp4"
    run(["ffmpeg","-y","-i",sc_src,
         "-vf","scale=1280:720:force_original_aspect_ratio=decrease,pad=1280:720:(ow-iw)/2:(oh-ih)/2,setsar=1",
         "-t",str(duration),"-c:v","libx264","-preset","fast","-crf","20","-pix_fmt","yuv420p","-an",
         vis], "logo vis")
    run(["ffmpeg","-y","-i",vis,
         "-f","lavfi","-i","anullsrc=channel_layout=stereo:sample_rate=48000",
         "-c:v","copy","-c:a","aac","-b:a","64k",
         "-map","0:v","-map","1:a","-t",str(duration),dst], name)
    os.remove(vis)
    d = dur(dst)
    print(f"  ✓ LOGO {name:<38}  {d:.1f}s")
    return dst

# ── Gerar os 20 segmentos na ordem exata do roteiro ──────────────────────────
print("\n[1/3] Gerando 20 segmentos do roteiro...")
segments = []

# Seção 1 — Hook
segments.append(norm_th(f"{TH}/v2_t1a_hook_matematico.mp4",     "01_th1a.mp4"))
segments.append(norm_th(f"{TH}/v2_t1b_algoritmo_pune.mp4",      "02_th1b.mp4"))
segments.append(sc_with_vo(f"{SC}/sc1_anim.mp4", f"{VO}/vo_t_sc1.mp4", "03_sc1.mp4"))
segments.append(norm_th(f"{TH}/v2_t1c_caixa_preta.mp4",         "04_th1c.mp4"))
segments.append(norm_th(f"{TH}/v2_t1d_maquina_faz.mp4",         "05_th1d.mp4"))

# Seção 2 — Arquitetura
segments.append(sc_with_vo(f"{SC}/sc2_anim.mp4", f"{VO}/vo_t_sc2.mp4", "06_sc2.mp4"))
segments.append(sc_with_vo(f"{SC}/sc3_anim.mp4", f"{VO}/vo_t_sc3.mp4", "07_sc3.mp4"))
segments.append(norm_th(f"{TH}/v2_t2a_elenco_nunca_atrasa.mp4", "08_th2a.mp4"))
segments.append(norm_th(f"{TH}/v2_t2b_voce_gerencia.mp4",       "09_th2b.mp4"))

# Seção 3 — Banco Narrativo
segments.append(sc_with_vo(f"{SC}/sc4_anim.mp4", f"{VO}/vo_t_sc4.mp4", "10_sc4.mp4"))
segments.append(sc_with_vo(f"{SC}/sc5_anim.mp4", f"{VO}/vo_t_sc5.mp4", "11_sc5.mp4"))
segments.append(sc_with_vo(f"{SC}/sc6_anim.mp4", f"{VO}/vo_t_sc6.mp4", "12_sc6.mp4"))

# Seção 4 — Lip Sync e Safe Zone
segments.append(norm_th(f"{TH}/v2_t3a_cereja_bolo.mp4",         "13_th3a.mp4"))
segments.append(sc_with_vo(f"{SC}/sc7_anim.mp4", f"{VO}/vo_t_sc7.mp4", "14_sc7.mp4"))
segments.append(sc_with_vo(f"{SC}/sc8_anim.mp4", f"{VO}/vo_t_sc8.mp4", "15_sc8.mp4"))
segments.append(norm_th(f"{TH}/v2_t3b_engenharia_conversao.mp4","16_th3b.mp4"))

# Seção 5 — CTA
segments.append(norm_th(f"{TH}/v2_t4a_voce_viu_maquina.mp4",    "17_th4a.mp4"))
segments.append(norm_th(f"{TH}/v2_t4b_boa_noticia.mp4",         "18_th4b.mp4"))
segments.append(norm_th(f"{TH}/v2_t4c_proximo_video.mp4",       "19_th4c.mp4"))
segments.append(logo_seg(f"{SC}/sc9_anim.mp4",                  "20_logo.mp4", 5))

total_dur = sum(dur(s) for s in segments)
print(f"\n  Total: {len(segments)} segmentos, {total_dur:.1f}s ({total_dur/60:.1f} min)")

# ── Concatenar ────────────────────────────────────────────────────────────────
print("\n[2/3] Concatenando...")
concat_list = f"{TEMP}/concat.txt"
with open(concat_list,"w") as f:
    for s in segments:
        f.write(f"file '{s}'\n")

base = f"{TEMP}/base.mp4"
run(["ffmpeg","-y","-f","concat","-safe","0","-i",concat_list,
     "-c:v","libx264","-preset","medium","-crf","18","-pix_fmt","yuv420p",
     "-c:a","aac","-b:a","192k","-ar","48000","-ac","2",base], "concat")
print(f"  ✓ Vídeo base: {dur(base):.1f}s")

# ── Marca d'água ──────────────────────────────────────────────────────────────
print("\n[3/3] Marca d'água e exportação...")
final = f"{OUT}/video2_v7_ROTEIRO_FINAL.mp4"
if os.path.exists(LOGO):
    run(["ffmpeg","-y","-i",base,"-i",LOGO,
         "-filter_complex","[1:v]scale=140:-1[wm];[0:v][wm]overlay=W-w-25:H-h-25:format=auto,format=yuv420p",
         "-c:v","libx264","-preset","medium","-crf","18",
         "-c:a","aac","-b:a","192k",final], "watermark")
else:
    shutil.copy(base, final)

d_final = dur(final)
size = os.path.getsize(final) // (1024*1024)
print(f"\n{'='*52}")
print(f"  Arquivo: video2_v7_ROTEIRO_FINAL.mp4")
print(f"  Duração: {d_final/60:.2f} min  ({d_final:.1f}s)")
print(f"  Tamanho: {size}MB  |  1280x720")
print(f"  Segmentos: {len(segments)}")
print(f"{'='*52}")
shutil.rmtree(TEMP)
print("✅  Vídeo 2 v7 PRONTO!")
