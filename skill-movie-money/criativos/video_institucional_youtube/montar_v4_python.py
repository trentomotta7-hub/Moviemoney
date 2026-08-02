#!/usr/bin/env python3
"""
Montagem v4 do Vídeo 2 — Python (mais robusto que bash para ffmpeg complexo)
Arquitetura:
  - Takes TH: vídeo do Beto COM seu áudio original (lip sync)
  - SCs: vídeos animados COM silêncio (Beto fala antes/depois)
  - Resultado: vídeo coerente onde o Beto fala com lip sync e as telas
    aparecem como "janelas visuais" entre as falas
"""
import subprocess, os, shutil

BASE = "/home/ubuntu/Moviemoney/skill-movie-money/criativos/video_institucional_youtube"
TAKES = f"{BASE}/takes_v2"
ANIM  = f"{BASE}/screens_v2_anim"
LOGO  = "/home/ubuntu/Moviemoney/skill-movie-money/templates/identidade_visual/logo_transparente.png"
TEMP  = f"{BASE}/temp_v4"
OUT   = BASE

os.makedirs(TEMP, exist_ok=True)

def run(cmd, label=""):
    r = subprocess.run(cmd, capture_output=True, text=True)
    if r.returncode != 0:
        print(f"  ✗ ERRO em {label}: {r.stderr[-300:]}")
    return r.returncode == 0

def dur(path):
    r = subprocess.run(
        ["ffprobe","-v","quiet","-show_entries","format=duration","-of","csv=p=0",path],
        capture_output=True, text=True)
    return float(r.stdout.strip()) if r.stdout.strip() else 0.0

def norm_th(src, dst):
    """Normaliza take TH mantendo áudio original (lip sync)."""
    ok = run([
        "ffmpeg","-y","-i",src,
        "-vf","scale=1280:720:force_original_aspect_ratio=decrease,pad=1280:720:(ow-iw)/2:(oh-ih)/2,setsar=1",
        "-c:v","libx264","-preset","fast","-crf","20","-pix_fmt","yuv420p",
        "-c:a","aac","-b:a","192k","-ar","48000","-ac","2",
        dst
    ], dst)
    d = dur(dst)
    print(f"  ✓ TH {os.path.basename(dst):<35}  {d:.1f}s")
    return ok

def sc_silent(src, dst, duration):
    """Prepara SC animado com duração exata e áudio silencioso."""
    # Passo 1: cortar/escalar o vídeo
    vis = dst.replace(".mp4","_vis.mp4")
    run([
        "ffmpeg","-y","-i",src,
        "-vf","scale=1280:720:force_original_aspect_ratio=decrease,pad=1280:720:(ow-iw)/2:(oh-ih)/2,setsar=1",
        "-t",str(duration),
        "-c:v","libx264","-preset","fast","-crf","20","-pix_fmt","yuv420p",
        vis
    ], vis)
    # Passo 2: adicionar áudio silencioso
    run([
        "ffmpeg","-y",
        "-i",vis,
        "-f","lavfi","-i","anullsrc=channel_layout=stereo:sample_rate=48000",
        "-c:v","copy","-c:a","aac","-b:a","64k",
        "-map","0:v","-map","1:a",
        "-t",str(duration),
        dst
    ], dst)
    os.remove(vis)
    d = dur(dst)
    print(f"  ✓ SC {os.path.basename(dst):<35}  {d:.1f}s")

def concat_sc(srcs, dst, total_dur):
    """Concatena múltiplos SCs animados e corta na duração desejada."""
    if len(srcs) == 1:
        vis = dst.replace(".mp4","_vis.mp4")
        run(["ffmpeg","-y","-i",srcs[0],
             "-vf","scale=1280:720:force_original_aspect_ratio=decrease,pad=1280:720:(ow-iw)/2:(oh-ih)/2,setsar=1",
             "-t",str(total_dur),"-c:v","libx264","-preset","fast","-crf","20","-pix_fmt","yuv420p",vis], vis)
    else:
        # Criar lista de concat
        lst = f"{TEMP}/tmp_concat_sc.txt"
        with open(lst,"w") as f:
            for s in srcs:
                f.write(f"file '{s}'\n")
        vis = dst.replace(".mp4","_vis.mp4")
        run(["ffmpeg","-y","-f","concat","-safe","0","-i",lst,
             "-vf","scale=1280:720:force_original_aspect_ratio=decrease,pad=1280:720:(ow-iw)/2:(oh-ih)/2,setsar=1",
             "-t",str(total_dur),"-c:v","libx264","-preset","fast","-crf","20","-pix_fmt","yuv420p",vis], vis)
    # Adicionar silêncio
    run([
        "ffmpeg","-y","-i",vis,
        "-f","lavfi","-i","anullsrc=channel_layout=stereo:sample_rate=48000",
        "-c:v","copy","-c:a","aac","-b:a","64k",
        "-map","0:v","-map","1:a","-t",str(total_dur),dst
    ], dst)
    os.remove(vis)
    d = dur(dst)
    print(f"  ✓ SC {os.path.basename(dst):<35}  {d:.1f}s")

# ── ETAPA 1: Takes TH ────────────────────────────────────────────────────────
print("\n[1/4] Takes de Talking Head (lip sync original)...")
norm_th(f"{TAKES}/v2_t1a_hook_matematico.mp4",      f"{TEMP}/t1a.mp4")
norm_th(f"{TAKES}/v2_t1b_algoritmo_pune.mp4",       f"{TEMP}/t1b.mp4")
norm_th(f"{TAKES}/v2_t1c_caixa_preta.mp4",          f"{TEMP}/t1c.mp4")
norm_th(f"{TAKES}/v2_t1d_maquina_faz.mp4",          f"{TEMP}/t1d.mp4")
norm_th(f"{TAKES}/v2_t2a_elenco_nunca_atrasa.mp4",  f"{TEMP}/t2a.mp4")
norm_th(f"{TAKES}/v2_t2b_voce_gerencia.mp4",        f"{TEMP}/t2b.mp4")
norm_th(f"{TAKES}/v2_t3a_cereja_bolo.mp4",          f"{TEMP}/t3a.mp4")
norm_th(f"{TAKES}/v2_t3b_engenharia_conversao.mp4", f"{TEMP}/t3b.mp4")
norm_th(f"{TAKES}/v2_t4a_voce_viu_maquina.mp4",     f"{TEMP}/t4a.mp4")
norm_th(f"{TAKES}/v2_t4b_boa_noticia.mp4",          f"{TEMP}/t4b.mp4")
norm_th(f"{TAKES}/v2_t4c_proximo_video.mp4",        f"{TEMP}/t4c.mp4")

# ── ETAPA 2: SCs animados com silêncio ───────────────────────────────────────
print("\n[2/4] Screen Recordings animados (silêncio — Beto fala antes/depois)...")
sc_silent(f"{ANIM}/sc1_anim.mp4", f"{TEMP}/sc1.mp4", 10)
concat_sc([f"{ANIM}/sc2_anim.mp4", f"{ANIM}/sc3_anim.mp4"], f"{TEMP}/sc23.mp4", 18)
concat_sc([f"{ANIM}/sc4_anim.mp4", f"{ANIM}/sc5_anim.mp4", f"{ANIM}/sc6_anim.mp4"], f"{TEMP}/sc456.mp4", 15)
concat_sc([f"{ANIM}/sc7_anim.mp4", f"{ANIM}/sc8_anim.mp4"], f"{TEMP}/sc78.mp4", 15)
sc_silent(f"{ANIM}/sc9_anim.mp4", f"{TEMP}/sc9.mp4", 5)

# ── ETAPA 3: Concatenar ───────────────────────────────────────────────────────
print("\n[3/4] Concatenando na ordem do roteiro...")
concat_list = f"{TEMP}/concat.txt"
segments = [
    # Seção 1
    f"{TEMP}/t1a.mp4", f"{TEMP}/sc1.mp4",
    f"{TEMP}/t1b.mp4", f"{TEMP}/t1c.mp4", f"{TEMP}/t1d.mp4",
    # Seção 2
    f"{TEMP}/sc23.mp4",
    f"{TEMP}/t2a.mp4", f"{TEMP}/t2b.mp4",
    # Seção 3
    f"{TEMP}/sc456.mp4",
    # Seção 4
    f"{TEMP}/t3a.mp4", f"{TEMP}/sc78.mp4", f"{TEMP}/t3b.mp4",
    # Seção 5
    f"{TEMP}/t4a.mp4", f"{TEMP}/t4b.mp4", f"{TEMP}/t4c.mp4",
    f"{TEMP}/sc9.mp4",
]
with open(concat_list,"w") as f:
    for s in segments:
        f.write(f"file '{s}'\n")
print(f"  ✓ {len(segments)} segmentos")

base_mp4 = f"{TEMP}/base.mp4"
run([
    "ffmpeg","-y","-f","concat","-safe","0","-i",concat_list,
    "-c:v","libx264","-preset","medium","-crf","18","-pix_fmt","yuv420p",
    "-c:a","aac","-b:a","192k","-ar","48000","-ac","2",
    base_mp4
], "concat final")
print(f"  ✓ Vídeo base: {dur(base_mp4):.1f}s")

# ── ETAPA 4: Marca d'água ─────────────────────────────────────────────────────
print("\n[4/4] Marca d'água e exportação final...")
final = f"{OUT}/video2_maquina_por_dentro_v4_FINAL.mp4"
if os.path.exists(LOGO):
    run([
        "ffmpeg","-y","-i",base_mp4,"-i",LOGO,
        "-filter_complex","[1:v]scale=140:-1[wm];[0:v][wm]overlay=W-w-25:H-h-25:format=auto,format=yuv420p",
        "-c:v","libx264","-preset","medium","-crf","18",
        "-c:a","aac","-b:a","192k",
        final
    ], "watermark")
else:
    shutil.copy(base_mp4, final)

d_final = dur(final)
size = os.path.getsize(final) // (1024*1024)
print(f"\n{'='*44}")
print(f"  Arquivo: video2_maquina_por_dentro_v4_FINAL.mp4")
print(f"  Duração: {d_final/60:.2f} min  ({d_final:.1f}s)")
print(f"  Tamanho: {size}MB  |  Resolução: 1280x720")
print(f"  Áudio TH: lip sync original do Beto")
print(f"  Áudio SC: silêncio (Beto fala antes/depois)")
print(f"  Visual SC: animados — zero prints estáticos")
print(f"{'='*44}")

shutil.rmtree(TEMP)
print("✅  Vídeo 2 v4 PRONTO!")
