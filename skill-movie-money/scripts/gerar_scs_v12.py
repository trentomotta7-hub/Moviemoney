#!/usr/bin/env python3
"""
Gera os Screen Recordings v12 do Vídeo 2 "A Máquina por Dentro".
Melhoria principal: SC-3 usa imagens reais do elenco (rostos reais dos personagens).
Todos os SCs recebem Ken Burns (zoom 1.0 → 1.08) + VO Fenrir do v12.
"""
import os
import subprocess
from PIL import Image, ImageDraw, ImageFont
import numpy as np

BASE = "/home/ubuntu/Moviemoney/skill-movie-money/criativos/video_institucional_youtube"
SCREENS_V2 = os.path.join(BASE, "screens_v2")
VO_DIR = os.path.join(BASE, "takes_v12_vos")
OUT_DIR = os.path.join(BASE, "scs_v12")
PERSONAGENS = "/home/ubuntu/Moviemoney/skill-movie-money/templates/personagens"
MARKER = "/home/ubuntu/Moviemoney/skill-movie-money/templates/identidade_visual/logo_transparente.png"

os.makedirs(OUT_DIR, exist_ok=True)


def get_vo_duration(vo_id):
    """Retorna a duração do VO em segundos."""
    wav = os.path.join(VO_DIR, f"{vo_id}.wav")
    result = subprocess.run(
        ["ffprobe", "-v", "quiet", "-show_entries", "format=duration",
         "-of", "csv=p=0", wav],
        capture_output=True, text=True
    )
    try:
        return float(result.stdout.strip())
    except:
        return 10.0


def make_sc_video(sc_id, img_path, vo_id, output_path):
    """Cria vídeo SC com Ken Burns + VO + marca d'água."""
    dur = get_vo_duration(vo_id)
    vo_path = os.path.join(VO_DIR, f"{vo_id}.wav")

    # Adicionar 0.5s de padding ao final
    dur_total = dur + 0.5

    frames = int(dur_total * 24)
    # Ken Burns via scale dinamico + crop centralizado.
    # zoompan com -loop 1 nao avanca os frames corretamente, por isso usamos
    # uma expressao de escala dependente do tempo (t) e recorte central fixo.
    zoom_expr = f"1+0.08*t/{dur_total}"
    cmd = [
        "ffmpeg", "-y",
        "-loop", "1", "-framerate", "24", "-t", str(dur_total), "-i", img_path,
        "-i", vo_path,
        "-i", MARKER,
        "-filter_complex",
        (
            f"[0:v]scale=2560:1440:force_original_aspect_ratio=increase,"
            f"crop=2560:1440,setsar=1,fps=24,"
            f"scale=w='ceil(2560*({zoom_expr})/2)*2':h='ceil(1440*({zoom_expr})/2)*2':eval=frame,"
            f"crop=w=2560:h=1440:x='(iw-2560)/2':y='(ih-1440)/2',"
            f"scale=1280:720:flags=bicubic,format=yuv420p[vid];"
            f"[2:v]scale=iw*0.15:-1[logo];"
            f"[vid][logo]overlay=W-w-20:H-h-20[out]"
        ),
        "-map", "[out]",
        "-map", "1:a",
        "-c:v", "libx264", "-preset", "medium", "-crf", "20",
        "-pix_fmt", "yuv420p",
        "-c:a", "aac", "-b:a", "192k", "-ar", "48000", "-ac", "2",
        "-t", str(dur_total),
        "-r", "24",
        output_path
    ]
    result = subprocess.run(cmd, capture_output=True)
    if result.returncode == 0:
        print(f"  ✓ {os.path.basename(output_path)} ({dur_total:.1f}s)")
        return True
    else:
        print(f"  ✗ Erro em {sc_id}: {result.stderr[-200:]}")
        return False


def create_sc3_grid(output_path):
    """
    Cria o SC-3: Grid dos 5 personagens com rostos reais do elenco.
    Layout: 5 fotos em linha com nome e nicho abaixo de cada um.
    Fundo escuro estilo dashboard.
    """
    print("  Criando SC-3 grid com rostos reais...")

    W, H = 1280, 720
    img = Image.new("RGB", (W, H), color=(10, 10, 20))
    draw = ImageDraw.Draw(img)

    # Título
    try:
        font_title = ImageFont.truetype("/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf", 28)
        font_name = ImageFont.truetype("/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf", 18)
        font_nicho = ImageFont.truetype("/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf", 14)
    except:
        font_title = ImageFont.load_default()
        font_name = font_title
        font_nicho = font_title

    # Título do dashboard
    draw.text((W//2, 28), "ELENCO MOVIE MONEY", font=font_title, fill="#FFD700", anchor="mm")
    draw.text((W//2, 58), "5 personas • 90% dos nichos lucrativos do TikTok Shop", font=font_nicho, fill="#8b949e", anchor="mm")

    # Linha separadora
    draw.line([(40, 72), (W-40, 72)], fill="#1f2937", width=1)

    # Personagens
    personagens = [
        {"nome": "Lucas Ferreira", "nicho": "Tech & Gadgets", "arquivo": "lucas_ferreira.png", "cor": "#3b82f6"},
        {"nome": "Marina Costa", "nicho": "Beleza & Skincare", "arquivo": "marina_costa.png", "cor": "#ec4899"},
        {"nome": "Rafael Santos", "nicho": "Fitness & Saúde", "arquivo": "rafael_santos.png", "cor": "#10b981"},
        {"nome": "Beatriz Oliveira", "nicho": "Produtividade", "arquivo": "beatriz_oliveira.png", "cor": "#f59e0b"},
        {"nome": "Diego Almeida", "nicho": "Produtos Virais", "arquivo": "diego_almeida.png", "cor": "#8b5cf6"},
    ]

    n = len(personagens)
    margin = 30
    spacing = 12
    card_w = (W - 2*margin - (n-1)*spacing) // n
    card_h = 560
    y_start = 85

    for i, p in enumerate(personagens):
        x = margin + i * (card_w + spacing)

        # Fundo do card
        draw.rounded_rectangle(
            [(x, y_start), (x + card_w, y_start + card_h)],
            radius=12,
            fill=(18, 24, 38),
            outline=p["cor"],
            width=2
        )

        # Foto do personagem (crop quadrado centralizado, topo do card)
        foto_path = os.path.join(PERSONAGENS, p["arquivo"])
        if os.path.exists(foto_path):
            foto = Image.open(foto_path).convert("RGB")
            # Crop quadrado centralizado
            fw, fh = foto.size
            side = min(fw, fh)
            left = (fw - side) // 2
            top = max(0, (fh - side) // 3)  # Focar no rosto (terço superior)
            foto_crop = foto.crop((left, top, left + side, top + side))

            foto_size = card_w - 16
            foto_resized = foto_crop.resize((foto_size, foto_size), Image.LANCZOS)

            # Criar máscara circular
            mask = Image.new("L", (foto_size, foto_size), 0)
            mask_draw = ImageDraw.Draw(mask)
            mask_draw.ellipse([(0, 0), (foto_size, foto_size)], fill=255)

            foto_x = x + 8
            foto_y = y_start + 12
            img.paste(foto_resized, (foto_x, foto_y), mask)

            # Borda circular colorida
            draw.ellipse(
                [(foto_x - 2, foto_y - 2), (foto_x + foto_size + 2, foto_y + foto_size + 2)],
                outline=p["cor"],
                width=3
            )

        # Nome
        nome_y = y_start + card_w - 8 + 18
        draw.text((x + card_w//2, nome_y), p["nome"], font=font_name, fill="#f1f5f9", anchor="mm")

        # Nicho
        nicho_y = nome_y + 26
        draw.text((x + card_w//2, nicho_y), p["nicho"], font=font_nicho, fill=p["cor"], anchor="mm")

        # Badge de status
        badge_y = nicho_y + 24
        badge_text = "● ATIVO"
        draw.text((x + card_w//2, badge_y), badge_text, font=font_nicho, fill="#10b981", anchor="mm")

    # Footer
    draw.line([(40, H - 40), (W-40, H - 40)], fill="#1f2937", width=1)
    draw.text((W//2, H - 22), "movie-money.com.br  •  Criativos que vendem no TikTok Shop", font=font_nicho, fill="#4b5563", anchor="mm")

    img.save(output_path, "PNG")
    print(f"  ✓ SC-3 grid salvo: {output_path}")
    return output_path


if __name__ == "__main__":
    print("🎬  Gerando Screen Recordings v12 do Vídeo 2")
    print("=" * 60)

    # SC-3: Recriar com rostos reais
    sc3_img = os.path.join(OUT_DIR, "sc3_grid_personagens.png")
    create_sc3_grid(sc3_img)

    # Mapeamento: SC → imagem fonte → VO
    scs = [
        ("sc1", os.path.join(SCREENS_V2, "v2_sc1_video_generico_tiktok.png"), "vo_sc1"),
        ("sc2", os.path.join(SCREENS_V2, "v2_sc2_vscode_repositorio.png"), "vo_sc2"),
        ("sc3", sc3_img, "vo_sc3"),
        ("sc4", os.path.join(SCREENS_V2, "v2_sc4_banco_narrativo.png"), "vo_sc4"),
        ("sc5", os.path.join(SCREENS_V2, "v2_sc5_lista_70_dores.png"), "vo_sc5"),
        ("sc6", os.path.join(SCREENS_V2, "v2_sc6_terminal_gerando_video.png"), "vo_sc6"),
        ("sc7", os.path.join(SCREENS_V2, "v2_sc7_comparacao_lipsync.png"), "vo_sc7"),
        ("sc8", os.path.join(SCREENS_V2, "v2_sc8_legendas_safe_zone.png"), "vo_sc8"),
    ]

    print("\n=== Gerando vídeos SC com Ken Burns + VO Fenrir ===")
    for sc_id, img_path, vo_id in scs:
        out = os.path.join(OUT_DIR, f"{sc_id}_final.mp4")
        if os.path.exists(img_path):
            make_sc_video(sc_id, img_path, vo_id, out)
        else:
            print(f"  ⚠ Imagem não encontrada: {img_path}")

    print("=" * 60)
    print(f"✅  SCs v12 gerados em: {OUT_DIR}")
