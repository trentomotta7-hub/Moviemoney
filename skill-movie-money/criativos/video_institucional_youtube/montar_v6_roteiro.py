#!/usr/bin/env python3
"""
Montagem v6 — Vídeo 2: "A Máquina por Dentro"
Segue o roteiro linha a linha.

ESTRUTURA DO ROTEIRO:
  Seção 1 — Hook da Prova Lógica
    TH-1a: Beto fala direto (hook matemático)
    TH-1b: Beto fala direto (algoritmo pune)
    [SC-1 + VO-SC1]: Tela animada (anúncio genérico) COM Beto em VO
    TH-1c: Beto fala direto (caixa preta)
    TH-1d: Beto fala direto (o que a máquina faz)

  Seção 2 — A Arquitetura do Repositório
    [SC-2 + VO-SC2]: Tela VS Code COM Beto em VO
    [SC-3 + VO-SC3]: Tela personagens COM Beto em VO
    TH-2a: Beto fala direto (elenco nunca atrasa)
    TH-2b: Beto fala direto (você gerencia)

  Seção 3 — O Banco Narrativo
    [SC-4 + VO-SC4]: Tela banco narrativo COM Beto em VO
    [SC-5 + VO-SC5]: Tela 70 dores COM Beto em VO
    [SC-6 + VO-SC6]: Tela terminal COM Beto em VO

  Seção 4 — Lip Sync e Safe Zone
    TH-3a: Beto fala direto (cereja do bolo)
    [SC-7 + VO-SC7]: Tela comparação COM Beto em VO
    [SC-8 + VO-SC8]: Tela safe zone COM Beto em VO
    TH-3b: Beto fala direto (engenharia de conversão)

  Seção 5 — CTA
    TH-4a: Beto fala direto (você viu a máquina)
    TH-4b: Beto fala direto (boa notícia)
    TH-4c: Beto fala direto (próximo vídeo)
    SC-9: Logo final

PARA CADA SEGMENTO COM TELA:
  - Vídeo: SC animado (tela em movimento)
  - Áudio: extraído do take VO do Beto (lip sync real)
  Assim o Beto fala com lip sync E a tela aparece ao mesmo tempo.
"""
import subprocess, os, shutil

BASE  = "/home/ubuntu/Moviemoney/skill-movie-money/criativos/video_institucional_youtube"
TH    = f"{BASE}/takes_v2"
VO    = f"{BASE}/takes_v2_vo"
SC    = f"{BASE}/screens_v2_anim"
LOGO  = "/home/ubuntu/Moviemoney/skill-movie-money/templates/identidade_visual/logo_transparente.png"
TEMP  = f"{BASE}/temp_v6"
OUT   = BASE

os.makedirs(TEMP, exist_ok=True)

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

def norm_th(src, dst):
    """Normaliza take TH: vídeo 1280x720 + áudio original do Beto."""
    run(["ffmpeg","-y","-i",src,
         "-vf","scale=1280:720:force_original_aspect_ratio=decrease,pad=1280:720:(ow-iw)/2:(oh-ih)/2,setsar=1",
         "-c:v","libx264","-preset","fast","-crf","20","-pix_fmt","yuv420p",
         "-c:a","aac","-b:a","192k","-ar","48000","-ac","2",
         dst], dst)
    d = dur(dst)
    print(f"  ✓ TH {os.path.basename(dst):<40}  {d:.1f}s")

def sc_with_vo(sc_src, vo_src, dst):
    """
    Combina SC animado (visual) com áudio do take VO do Beto.
    O resultado é: tela em movimento + voz do Beto com lip sync.
    A duração é determinada pelo VO (fala do Beto).
    """
    vo_dur = dur(vo_src)
    
    # Extrair áudio do take VO
    audio_tmp = dst.replace(".mp4","_audio.wav")
    run(["ffmpeg","-y","-i",vo_src,"-vn","-ar","48000","-ac","2","-acodec","pcm_s16le",audio_tmp], audio_tmp)
    
    # Normalizar SC para 1280x720 com duração do VO
    sc_tmp = dst.replace(".mp4","_sc.mp4")
    run(["ffmpeg","-y","-i",sc_src,
         "-vf","scale=1280:720:force_original_aspect_ratio=decrease,pad=1280:720:(ow-iw)/2:(oh-ih)/2,setsar=1",
         "-t",str(vo_dur),
         "-c:v","libx264","-preset","fast","-crf","20","-pix_fmt","yuv420p","-an",
         sc_tmp], sc_tmp)
    
    # Combinar SC visual + áudio do Beto
    run(["ffmpeg","-y",
         "-i",sc_tmp,"-i",audio_tmp,
         "-c:v","copy","-c:a","aac","-b:a","192k",
         "-map","0:v","-map","1:a",
         "-t",str(vo_dur),
         dst], dst)
    
    os.remove(audio_tmp)
    os.remove(sc_tmp)
    d = dur(dst)
    print(f"  ✓ SC+VO {os.path.basename(dst):<37}  {d:.1f}s  (voz Beto + tela animada)")

def sc_logo(sc_src, dst, duration=5):
    """Logo final: apenas visual, sem áudio."""
    run(["ffmpeg","-y","-i",sc_src,
         "-vf","scale=1280:720:force_original_aspect_ratio=decrease,pad=1280:720:(ow-iw)/2:(oh-ih)/2,setsar=1",
         "-t",str(duration),
         "-c:v","libx264","-preset","fast","-crf","20","-pix_fmt","yuv420p",
         "-f","lavfi","-i","anullsrc=channel_layout=stereo:sample_rate=48000",
         "-map","0:v","-map","1:a","-c:a","aac","-b:a","64k",
         "-t",str(duration),dst], dst)
    d = dur(dst)
    print(f"  ✓ SC logo {os.path.basename(dst):<37}  {d:.1f}s")

# ── ETAPA 1: Normalizar takes TH ─────────────────────────────────────────────
print("\n[1/4] Normalizando takes de Talking Head (lip sync original)...")
norm_th(f"{TH}/v2_t1a_hook_matematico.mp4",      f"{TEMP}/s01_th1a.mp4")
norm_th(f"{TH}/v2_t1b_algoritmo_pune.mp4",       f"{TEMP}/s02_th1b.mp4")
norm_th(f"{TH}/v2_t1c_caixa_preta.mp4",          f"{TEMP}/s04_th1c.mp4")
norm_th(f"{TH}/v2_t1d_maquina_faz.mp4",          f"{TEMP}/s05_th1d.mp4")
norm_th(f"{TH}/v2_t2a_elenco_nunca_atrasa.mp4",  f"{TEMP}/s08_th2a.mp4")
norm_th(f"{TH}/v2_t2b_voce_gerencia.mp4",        f"{TEMP}/s09_th2b.mp4")
norm_th(f"{TH}/v2_t3a_cereja_bolo.mp4",          f"{TEMP}/s13_th3a.mp4")
norm_th(f"{TH}/v2_t3b_engenharia_conversao.mp4", f"{TEMP}/s16_th3b.mp4")
norm_th(f"{TH}/v2_t4a_voce_viu_maquina.mp4",     f"{TEMP}/s17_th4a.mp4")
norm_th(f"{TH}/v2_t4b_boa_noticia.mp4",          f"{TEMP}/s18_th4b.mp4")
norm_th(f"{TH}/v2_t4c_proximo_video.mp4",        f"{TEMP}/s19_th4c.mp4")

# ── ETAPA 2: Gerar segmentos SC+VO (tela animada + voz Beto) ─────────────────
print("\n[2/4] Gerando segmentos de tela (SC animado + voz Beto em VO)...")
sc_with_vo(f"{SC}/sc1_anim.mp4", f"{VO}/vo_t_sc1.mp4", f"{TEMP}/s03_sc1_vo.mp4")
sc_with_vo(f"{SC}/sc2_anim.mp4", f"{VO}/vo_t_sc2.mp4", f"{TEMP}/s06_sc2_vo.mp4")
sc_with_vo(f"{SC}/sc3_anim.mp4", f"{VO}/vo_t_sc3.mp4", f"{TEMP}/s07_sc3_vo.mp4")
sc_with_vo(f"{SC}/sc4_anim.mp4", f"{VO}/vo_t_sc4.mp4", f"{TEMP}/s10_sc4_vo.mp4")
sc_with_vo(f"{SC}/sc5_anim.mp4", f"{VO}/vo_t_sc5.mp4", f"{TEMP}/s11_sc5_vo.mp4")
sc_with_vo(f"{SC}/sc6_anim.mp4", f"{VO}/vo_t_sc6.mp4", f"{TEMP}/s12_sc6_vo.mp4")
sc_with_vo(f"{SC}/sc7_anim.mp4", f"{VO}/vo_t_sc7.mp4", f"{TEMP}/s14_sc7_vo.mp4")
sc_with_vo(f"{SC}/sc8_anim.mp4", f"{VO}/vo_t_sc8.mp4", f"{TEMP}/s15_sc8_vo.mp4")
sc_logo(f"{SC}/sc9_anim.mp4", f"{TEMP}/s20_sc9.mp4", 5)

# ── ETAPA 3: Concatenar na ordem do roteiro ───────────────────────────────────
print("\n[3/4] Concatenando na ordem exata do roteiro...")

# Ordenar por prefixo numérico
segments = sorted([f"{TEMP}/{f}" for f in os.listdir(TEMP) if f.endswith(".mp4")])

concat_list = f"{TEMP}/concat.txt"
with open(concat_list,"w") as f:
    for s in segments:
        f.write(f"file '{s}'\n")

print(f"  Segmentos ({len(segments)}):")
for s in segments:
    print(f"    {os.path.basename(s)}: {dur(s):.1f}s")

base = f"{TEMP}/base.mp4"
run(["ffmpeg","-y","-f","concat","-safe","0","-i",concat_list,
     "-c:v","libx264","-preset","medium","-crf","18","-pix_fmt","yuv420p",
     "-c:a","aac","-b:a","192k","-ar","48000","-ac","2",
     base], "concat")
print(f"\n  ✓ Vídeo base: {dur(base):.1f}s")

# ── ETAPA 4: Marca d'água e exportação ───────────────────────────────────────
print("\n[4/4] Marca d'água e exportação final...")
final = f"{OUT}/video2_v6_ROTEIRO_FINAL.mp4"
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
print(f"  Arquivo: video2_v6_ROTEIRO_FINAL.mp4")
print(f"  Duração: {d_final/60:.2f} min  ({d_final:.1f}s)")
print(f"  Tamanho: {size}MB  |  1280x720")
print(f"  Segmentos: {len(segments)}")
print(f"  Áudio TH: lip sync original do Beto")
print(f"  Áudio SC: voz do Beto (take VO gerado com lip sync)")
print(f"  Visual SC: animado — zero prints estáticos")
print(f"{'='*52}")
shutil.rmtree(TEMP)
print("✅  Vídeo 2 v6 PRONTO!")
