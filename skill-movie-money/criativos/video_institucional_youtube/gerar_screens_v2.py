#!/usr/bin/env python3
"""
Gerador de Screen Recordings para o Vídeo 2: "A Máquina por Dentro"
Gera imagens PNG simulando telas de código, terminal, dashboards etc.
"""

from PIL import Image, ImageDraw, ImageFont
import os
import textwrap

OUTPUT_DIR = "/home/ubuntu/Moviemoney/skill-movie-money/criativos/video_institucional_youtube/screens_v2"
os.makedirs(OUTPUT_DIR, exist_ok=True)

W, H = 1280, 720

def get_font(size=16, bold=False):
    """Tenta carregar uma fonte monospace."""
    font_paths = [
        "/usr/share/fonts/truetype/dejavu/DejaVuSansMono-Bold.ttf" if bold else "/usr/share/fonts/truetype/dejavu/DejaVuSansMono.ttf",
        "/usr/share/fonts/truetype/liberation/LiberationMono-Regular.ttf",
        "/usr/share/fonts/truetype/ubuntu/UbuntuMono-R.ttf",
    ]
    for fp in font_paths:
        if os.path.exists(fp):
            try:
                return ImageFont.truetype(fp, size)
            except:
                pass
    return ImageFont.load_default()

def get_sans_font(size=16, bold=False):
    """Tenta carregar uma fonte sans-serif."""
    font_paths = [
        "/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf" if bold else "/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf",
        "/usr/share/fonts/truetype/liberation/LiberationSans-Regular.ttf",
    ]
    for fp in font_paths:
        if os.path.exists(fp):
            try:
                return ImageFont.truetype(fp, size)
            except:
                pass
    return ImageFont.load_default()

# ─────────────────────────────────────────────────────────────────────────────
# SC-1: Vídeo genérico TikTok com voz robótica
# ─────────────────────────────────────────────────────────────────────────────
def gerar_sc1():
    img = Image.new("RGB", (W, H), "#0a0a0a")
    draw = ImageDraw.Draw(img)

    # Simula interface TikTok
    # Fundo do vídeo (área central)
    draw.rectangle([160, 40, 760, H-40], fill="#1a1a2e")

    # Label "ANÚNCIO GENÉRICO" em vermelho
    font_title = get_sans_font(28, bold=True)
    font_small = get_sans_font(18)
    font_mono = get_font(15)

    draw.rectangle([160, 40, 760, 100], fill="#c0392b")
    draw.text((200, 55), "⚠  ANÚNCIO GENÉRICO — VOZ DE IA", font=font_title, fill="#ffffff")

    # Produto simulado
    draw.rectangle([260, 120, 660, 420], fill="#2c2c54")
    draw.text((340, 240), "PRODUTO\nALIEXPRESS", font=get_sans_font(36, bold=True), fill="#7f8c8d", align="center")

    # Legenda de IA robótica em inglês
    draw.rectangle([160, 430, 760, 480], fill="#e74c3c")
    draw.text((175, 442), "🤖  \"This amazing product will change your life!\"", font=font_small, fill="#ffffff")

    # Métricas ruins
    draw.rectangle([160, 490, 760, 570], fill="#1e1e1e")
    draw.text((175, 500), "📊  MÉTRICAS DO ANÚNCIO:", font=font_small, fill="#bdc3c7")
    draw.text((175, 525), "CPM: R$ 48,70  |  CTR: 0.3%  |  RETENÇÃO: 8%  |  ROAS: 0.4x", font=font_mono, fill="#e74c3c")

    # Painel direito — interface TikTok
    draw.rectangle([780, 40, W-20, H-40], fill="#111111")
    draw.text((790, 50), "TikTok", font=get_sans_font(22, bold=True), fill="#fe2c55")
    draw.text((790, 90), "❤  1.2K", font=font_small, fill="#ffffff")
    draw.text((790, 120), "💬  89", font=font_small, fill="#ffffff")
    draw.text((790, 150), "↗  234", font=font_small, fill="#ffffff")

    # Carrinho laranja TikTok Shop
    draw.rectangle([780, H-100, W-20, H-40], fill="#ff6600")
    draw.text((790, H-85), "🛒  COMPRAR AGORA", font=get_sans_font(16, bold=True), fill="#ffffff")

    # Watermark
    draw.text((20, H-30), "Movie Money — O que NÃO fazer", font=get_font(13), fill="#555555")

    path = os.path.join(OUTPUT_DIR, "v2_sc1_video_generico_tiktok.png")
    img.save(path, quality=95)
    print(f"✓ SC-1 salvo: {path}")
    return path

# ─────────────────────────────────────────────────────────────────────────────
# SC-2: VS Code com repositório Moviemoney aberto
# ─────────────────────────────────────────────────────────────────────────────
def gerar_sc2():
    img = Image.new("RGB", (W, H), "#1e1e1e")
    draw = ImageDraw.Draw(img)

    font_mono = get_font(14)
    font_mono_sm = get_font(12)
    font_bold = get_font(14, bold=True)
    font_sans = get_sans_font(13)

    # Barra de título VS Code
    draw.rectangle([0, 0, W, 30], fill="#323233")
    draw.text((10, 8), "● ● ●", font=font_sans, fill="#888888")
    draw.text((W//2 - 150, 8), "trentomotta7-hub/Moviemoney — Visual Studio Code", font=font_sans, fill="#cccccc")

    # Barra de abas
    draw.rectangle([0, 30, W, 55], fill="#2d2d2d")
    draw.rectangle([0, 30, 220, 55], fill="#1e1e1e")
    draw.text((10, 38), "📁 skill-movie-money", font=font_sans, fill="#ffffff")

    # Sidebar esquerda — explorador de arquivos
    draw.rectangle([0, 55, 240, H], fill="#252526")
    draw.text((10, 65), "EXPLORADOR", font=get_sans_font(11, bold=True), fill="#bbbbbb")

    estrutura = [
        ("📁 Moviemoney", 0, "#4fc1ff"),
        ("  📁 skill-movie-money", 1, "#4fc1ff"),
        ("    📁 templates", 2, "#4fc1ff"),
        ("      📁 personagens", 3, "#4fc1ff"),
        ("        🖼 beto.png", 4, "#ce9178"),
        ("        🖼 marina_costa.png", 4, "#ce9178"),
        ("        🖼 lucas_ferreira.png", 4, "#ce9178"),
        ("        🖼 rafael_santos.png", 4, "#ce9178"),
        ("        🖼 beatriz_oliveira.png", 4, "#ce9178"),
        ("        🖼 diego_almeida.png", 4, "#ce9178"),
        ("      📁 vozes", 3, "#4fc1ff"),
        ("      📁 cenas", 3, "#4fc1ff"),
        ("    📁 criativos", 2, "#4fc1ff"),
        ("    📁 skills", 2, "#4fc1ff"),
        ("    📁 scripts", 2, "#4fc1ff"),
        ("  📄 README.md", 1, "#f1fa8c"),
        ("  📄 FRAMEWORK_ROTEIROS.md", 1, "#f1fa8c"),
    ]

    y = 90
    for label, indent, color in estrutura:
        draw.text((10, y), label, font=font_mono_sm, fill=color)
        y += 18
        if y > H - 20:
            break

    # Área principal do editor
    draw.rectangle([240, 55, W, H], fill="#1e1e1e")

    # Conteúdo do arquivo README.md
    draw.text((250, 65), "README.md", font=font_sans, fill="#cccccc")
    draw.rectangle([240, 80, W, 82], fill="#333333")

    linhas_readme = [
        ("1  ", "#858585", "# Movie Money — Infraestrutura de Produção", "#4fc1ff"),
        ("2  ", "#858585", "", "#ffffff"),
        ("3  ", "#858585", "## Estrutura do Repositório", "#569cd6"),
        ("4  ", "#858585", "", "#ffffff"),
        ("5  ", "#858585", "```", "#ce9178"),
        ("6  ", "#858585", "skill-movie-money/", "#4ec9b0"),
        ("7  ", "#858585", "├── templates/", "#4ec9b0"),
        ("8  ", "#858585", "│   ├── personagens/     # 5 personas UGC", "#6a9955"),
        ("9  ", "#858585", "│   ├── vozes/           # Voz Fenrir pt-BR", "#6a9955"),
        ("10 ", "#858585", "│   └── cenas/           # Cenários por persona", "#6a9955"),
        ("11 ", "#858585", "├── criativos/           # Vídeos produzidos", "#4ec9b0"),
        ("12 ", "#858585", "├── skills/              # moviemoney-production", "#4ec9b0"),
        ("13 ", "#858585", "└── scripts/             # Pipeline ffmpeg", "#4ec9b0"),
        ("14 ", "#858585", "```", "#ce9178"),
        ("15 ", "#858585", "", "#ffffff"),
        ("16 ", "#858585", "## Tecnologia", "#569cd6"),
        ("17 ", "#858585", "- **Lip Sync:** Omni-Flash (fala exata no prompt)", "#d4d4d4"),
        ("18 ", "#858585", "- **Voz:** Fenrir (pt-BR) — Zero inglês", "#d4d4d4"),
        ("19 ", "#858585", "- **Safe Zone:** 320px da borda inferior", "#d4d4d4"),
    ]

    y = 95
    for num, num_color, text, text_color in linhas_readme:
        draw.text((250, y), num, font=font_mono_sm, fill=num_color)
        draw.text((285, y), text, font=font_mono_sm, fill=text_color)
        y += 18

    # Barra de status inferior
    draw.rectangle([0, H-25, W, H], fill="#007acc")
    draw.text((10, H-20), "🔵 main  ✓ 0 erros  ⚠ 0 avisos  |  UTF-8  |  Markdown", font=font_sans, fill="#ffffff")

    path = os.path.join(OUTPUT_DIR, "v2_sc2_vscode_repositorio.png")
    img.save(path, quality=95)
    print(f"✓ SC-2 salvo: {path}")
    return path

# ─────────────────────────────────────────────────────────────────────────────
# SC-3: Grid dos 5 personagens UGC
# ─────────────────────────────────────────────────────────────────────────────
def gerar_sc3():
    img = Image.new("RGB", (W, H), "#0a0a0a")
    draw = ImageDraw.Draw(img)

    font_title = get_sans_font(32, bold=True)
    font_sub = get_sans_font(20, bold=True)
    font_small = get_sans_font(16)
    font_tag = get_sans_font(14)

    # Título
    draw.text((W//2 - 280, 20), "ELENCO MOVIE MONEY — 5 PERSONAS UGC", font=font_title, fill="#f1c40f")
    draw.rectangle([60, 58, W-60, 61], fill="#f1c40f")

    personagens = [
        {"nome": "Lucas Ferreira", "nicho": "Tech & Gadgets", "cor": "#3498db", "emoji": "💻"},
        {"nome": "Marina Costa", "nicho": "Beleza & Skincare", "cor": "#e91e8c", "emoji": "💄"},
        {"nome": "Rafael Santos", "nicho": "Fitness & Saúde", "cor": "#27ae60", "emoji": "💪"},
        {"nome": "Beatriz Oliveira", "nicho": "Produtividade", "cor": "#9b59b6", "emoji": "📊"},
        {"nome": "Diego Almeida", "nicho": "Produtos Virais", "cor": "#e67e22", "emoji": "🔥"},
    ]

    card_w = 220
    card_h = 540
    start_x = 30
    gap = 10

    for i, p in enumerate(personagens):
        x = start_x + i * (card_w + gap)
        y = 75

        # Card background
        draw.rectangle([x, y, x+card_w, y+card_h], fill="#1a1a1a")
        draw.rectangle([x, y, x+card_w, y+4], fill=p["cor"])

        # Emoji grande como avatar placeholder
        draw.rectangle([x+10, y+15, x+card_w-10, y+380], fill="#2c2c2c")
        draw.text((x + card_w//2 - 30, y + 150), p["emoji"], font=get_sans_font(80), fill=p["cor"])

        # Nome
        draw.text((x+10, y+390), p["nome"], font=font_sub, fill="#ffffff")

        # Nicho
        draw.rectangle([x+10, y+425, x+card_w-10, y+455], fill=p["cor"])
        draw.text((x+15, y+430), p["nicho"], font=font_tag, fill="#ffffff")

        # Stats simulados
        draw.text((x+10, y+465), "✓ Lip Sync Perfeito", font=font_tag, fill="#2ecc71")
        draw.text((x+10, y+485), "✓ Nunca atrasa", font=font_tag, fill="#2ecc71")
        draw.text((x+10, y+505), "✓ Consistente", font=font_tag, fill="#2ecc71")

    # Rodapé
    draw.text((W//2 - 200, H-25), "movie-money.com.br  |  Personas com IP próprio", font=font_small, fill="#555555")

    path = os.path.join(OUTPUT_DIR, "v2_sc3_grid_personagens.png")
    img.save(path, quality=95)
    print(f"✓ SC-3 salvo: {path}")
    return path

# ─────────────────────────────────────────────────────────────────────────────
# SC-4: banco_narrativo.md aberto no VS Code
# ─────────────────────────────────────────────────────────────────────────────
def gerar_sc4():
    img = Image.new("RGB", (W, H), "#1e1e1e")
    draw = ImageDraw.Draw(img)

    font_mono = get_font(13)
    font_mono_sm = get_font(12)
    font_sans = get_sans_font(13)

    # Barra de título
    draw.rectangle([0, 0, W, 30], fill="#323233")
    draw.text((10, 8), "● ● ●", font=font_sans, fill="#888888")
    draw.text((W//2 - 200, 8), "banco_narrativo.md — Visual Studio Code", font=font_sans, fill="#cccccc")

    # Abas
    draw.rectangle([0, 30, W, 55], fill="#2d2d2d")
    draw.rectangle([0, 30, 200, 55], fill="#1e1e1e")
    draw.text((10, 38), "📄 banco_narrativo.md", font=font_sans, fill="#ffffff")

    # Conteúdo do arquivo
    linhas = [
        ("1  ", "#858585", "# Banco Narrativo — Movie Money", "#4fc1ff"),
        ("2  ", "#858585", "## 70 Dores Validadas do Mercado Brasileiro", "#569cd6"),
        ("3  ", "#858585", "", "#ffffff"),
        ("4  ", "#858585", "### Categoria B — Perfumaria & Bodysplash", "#ce9178"),
        ("5  ", "#858585", "", "#ffffff"),
        ("6  ", "#858585", "**B1: Cheiro que não dura**  ← CURSOR AQUI", "#f1c40f"),
        ("7  ", "#858585", "> Hook: \"Passei esse body splash de manhã e minha", "#6a9955"),
        ("8  ", "#858585", "> amiga perguntou o que eu tava usando às 10 da noite\"", "#6a9955"),
        ("9  ", "#858585", "", "#ffffff"),
        ("10 ", "#858585", "**B2: Preço alto demais para o que entrega**", "#d4d4d4"),
        ("11 ", "#858585", "> Hook: \"Esse body splash custa R$25 e cheira igual", "#6a9955"),
        ("12 ", "#858585", "> ao perfume de R$400 da minha chefe\"", "#6a9955"),
        ("13 ", "#858585", "", "#ffffff"),
        ("14 ", "#858585", "**B3: Embalagem que parece genérica**", "#d4d4d4"),
        ("15 ", "#858585", "> Hook: \"Recebi esse produto e achei que era falso.", "#6a9955"),
        ("16 ", "#858585", "> Testei e nunca mais comprei outro\"", "#6a9955"),
        ("17 ", "#858585", "", "#ffffff"),
        ("18 ", "#858585", "### Categoria C — Skincare & Beleza", "#ce9178"),
        ("19 ", "#858585", "", "#ffffff"),
        ("20 ", "#858585", "**C1: Produto que promete e não entrega**", "#d4d4d4"),
        ("21 ", "#858585", "**C2: Demora para ver resultado**", "#d4d4d4"),
        ("22 ", "#858585", "**C3: Textura ruim na pele**", "#d4d4d4"),
        ("23 ", "#858585", "", "#ffffff"),
        ("24 ", "#858585", "### Categoria T — Tech & Gadgets", "#ce9178"),
        ("25 ", "#858585", "", "#ffffff"),
        ("26 ", "#858585", "**T1: Produto que para de funcionar em 30 dias**", "#d4d4d4"),
        ("27 ", "#858585", "**T2: Instruções só em chinês**", "#d4d4d4"),
        ("28 ", "#858585", "**T3: Bateria que não dura**", "#d4d4d4"),
        ("29 ", "#858585", "", "#ffffff"),
        ("30 ", "#858585", "...", "#858585"),
        ("...", "#858585", "[ 70 dores mapeadas no total ]", "#555555"),
    ]

    y = 65
    for num, num_color, text, text_color in linhas:
        # Destaque na linha B1
        if "CURSOR" in text:
            draw.rectangle([240, y-2, W-10, y+16], fill="#264f78")
        draw.text((10, y), num, font=font_mono_sm, fill=num_color)
        draw.text((55, y), text, font=font_mono_sm, fill=text_color)
        y += 18
        if y > H - 30:
            break

    # Barra de status
    draw.rectangle([0, H-25, W, H], fill="#007acc")
    draw.text((10, H-20), "🔵 main  Linha 6, Coluna 1  |  UTF-8  |  Markdown  |  70 dores validadas", font=font_sans, fill="#ffffff")

    path = os.path.join(OUTPUT_DIR, "v2_sc4_banco_narrativo.png")
    img.save(path, quality=95)
    print(f"✓ SC-4 salvo: {path}")
    return path

# ─────────────────────────────────────────────────────────────────────────────
# SC-5: Lista das 70 dores no terminal
# ─────────────────────────────────────────────────────────────────────────────
def gerar_sc5():
    img = Image.new("RGB", (W, H), "#0d1117")
    draw = ImageDraw.Draw(img)

    font_mono = get_font(13)
    font_mono_sm = get_font(12)
    font_sans = get_sans_font(13)

    # Barra de terminal
    draw.rectangle([0, 0, W, 35], fill="#21262d")
    draw.text((10, 10), "●", font=font_sans, fill="#ff5f57")
    draw.text((30, 10), "●", font=font_sans, fill="#febc2e")
    draw.text((50, 10), "●", font=font_sans, fill="#28c840")
    draw.text((W//2 - 100, 10), "Terminal — bash", font=font_sans, fill="#8b949e")

    # Prompt inicial
    y = 50
    draw.text((10, y), "$ python3 listar_dores.py --categoria=todas --count=70", font=font_mono, fill="#58a6ff")
    y += 25

    draw.text((10, y), "🔍 Carregando banco narrativo...", font=font_mono, fill="#3fb950")
    y += 20
    draw.text((10, y), "✓ 70 dores validadas encontradas.", font=font_mono, fill="#3fb950")
    y += 25

    draw.text((10, y), "ID  | CATEGORIA          | DORE MAPEADA                              | HOOK SCORE", font=font_mono_sm, fill="#8b949e")
    y += 5
    draw.rectangle([10, y, W-10, y+1], fill="#30363d")
    y += 8

    dores = [
        ("B01", "Perfumaria", "Cheiro que não dura", "9.8", True),
        ("B02", "Perfumaria", "Preço alto para o que entrega", "8.7", False),
        ("B03", "Perfumaria", "Embalagem que parece genérica", "7.9", False),
        ("B04", "Perfumaria", "Vício em perfume caro", "8.2", False),
        ("C01", "Skincare", "Produto que promete e não entrega", "9.1", False),
        ("C02", "Skincare", "Demora para ver resultado", "8.5", False),
        ("C03", "Skincare", "Textura ruim na pele", "7.6", False),
        ("C04", "Skincare", "Preço inacessível", "8.0", False),
        ("T01", "Tech", "Para de funcionar em 30 dias", "9.3", False),
        ("T02", "Tech", "Instruções só em chinês", "8.8", False),
        ("T03", "Tech", "Bateria que não dura", "9.0", False),
        ("T04", "Tech", "Compatibilidade com celular", "7.4", False),
        ("F01", "Fitness", "Suplemento sem resultado", "9.2", False),
        ("F02", "Fitness", "Sabor horrível do whey", "8.1", False),
        ("F03", "Fitness", "Equipamento que ocupa espaço", "7.8", False),
        ("P01", "Produtividade", "Foco que não vem", "8.9", False),
        ("P02", "Produtividade", "Procrastinação crônica", "9.4", False),
        ("...", "...", "[ + 53 dores mapeadas ]", "...", False),
    ]

    for id_, cat, dor, score, highlight in dores:
        if highlight:
            draw.rectangle([10, y-2, W-10, y+16], fill="#1f3a1f")
            color = "#f1c40f"
        else:
            color = "#c9d1d9"

        linha = f"{id_:<4}| {cat:<18} | {dor:<41}| {score}"
        draw.text((10, y), linha, font=font_mono_sm, fill=color)
        y += 18
        if y > H - 40:
            break

    # Rodapé
    y = H - 35
    draw.text((10, y), "$ _", font=font_mono, fill="#58a6ff")
    draw.rectangle([0, H-20, W, H], fill="#21262d")
    draw.text((10, H-16), "Movie Money Analytics  |  34.847 vídeos analisados  |  70 dores validadas", font=font_sans, fill="#8b949e")

    path = os.path.join(OUTPUT_DIR, "v2_sc5_lista_70_dores.png")
    img.save(path, quality=95)
    print(f"✓ SC-5 salvo: {path}")
    return path

# ─────────────────────────────────────────────────────────────────────────────
# SC-6: Terminal gerando vídeo com hook real
# ─────────────────────────────────────────────────────────────────────────────
def gerar_sc6():
    img = Image.new("RGB", (W, H), "#0d1117")
    draw = ImageDraw.Draw(img)

    font_mono = get_font(13)
    font_mono_sm = get_font(12)
    font_sans = get_sans_font(13)

    # Barra de terminal
    draw.rectangle([0, 0, W, 35], fill="#21262d")
    draw.text((10, 10), "●", font=font_sans, fill="#ff5f57")
    draw.text((30, 10), "●", font=font_sans, fill="#febc2e")
    draw.text((50, 10), "●", font=font_sans, fill="#28c840")
    draw.text((W//2 - 150, 10), "Terminal — Pipeline Movie Money", font=font_sans, fill="#8b949e")

    y = 50
    draw.text((10, y), "$ bash montar_video_criativo.sh --persona=marina --dor=B01", font=font_mono, fill="#58a6ff")
    y += 25

    draw.text((10, y), "╔══════════════════════════════════════════════════╗", font=font_mono, fill="#30363d")
    y += 18
    draw.text((10, y), "║  MOVIE MONEY — PIPELINE DE PRODUÇÃO v2.0         ║", font=font_mono, fill="#f1c40f")
    y += 18
    draw.text((10, y), "╚══════════════════════════════════════════════════╝", font=font_mono, fill="#30363d")
    y += 25

    draw.text((10, y), "[1/6] Carregando persona: Marina Costa (Beleza)", font=font_mono, fill="#3fb950")
    y += 18
    draw.text((10, y), "      ✓ Keyframe: marina_costa.png (1280x720)", font=font_mono, fill="#8b949e")
    y += 18
    draw.text((10, y), "      ✓ Voz: Fenrir pt-BR (48kHz stereo)", font=font_mono, fill="#8b949e")
    y += 25

    draw.text((10, y), "[2/6] Selecionando dor: B01 — Cheiro que não dura", font=font_mono, fill="#3fb950")
    y += 18

    # Destaque do hook
    draw.rectangle([10, y-2, W-10, y+36], fill="#1f3a1f")
    draw.text((10, y), "      HOOK GERADO:", font=font_mono, fill="#f1c40f")
    y += 18
    draw.text((10, y), "      \"Passei esse body splash de manhã e minha amiga", font=font_mono, fill="#ffffff")
    y += 18
    draw.text((10, y), "       perguntou o que eu tava usando às dez da noite\"", font=font_mono, fill="#ffffff")
    y += 25

    draw.text((10, y), "[3/6] Gerando áudio TTS (Fenrir)...", font=font_mono, fill="#3fb950")
    y += 18
    draw.text((10, y), "      ✓ audio_marina_b01_hook.wav (4.2s, 48kHz)", font=font_mono, fill="#8b949e")
    y += 25

    draw.text((10, y), "[4/6] Gerando vídeo com lip sync (Omni-Flash)...", font=font_mono, fill="#3fb950")
    y += 18
    draw.text((10, y), "      Prompt: \"Marina Costa, fala: 'Passei esse body splash", font=font_mono_sm, fill="#8b949e")
    y += 16
    draw.text((10, y), "      de manhã e minha amiga perguntou o que eu tava usando", font=font_mono_sm, fill="#8b949e")
    y += 16
    draw.text((10, y), "      às dez da noite'\"", font=font_mono_sm, fill="#8b949e")
    y += 20
    draw.text((10, y), "      ✓ marina_b01_hook.mp4 (4.2s, 1280x720)", font=font_mono, fill="#8b949e")
    y += 25

    draw.text((10, y), "[5/6] Aplicando legendas karaokê (Safe Zone 320px)...", font=font_mono, fill="#3fb950")
    y += 18
    draw.text((10, y), "      ✓ Legendas amarelo/branco posicionadas a 320px", font=font_mono, fill="#8b949e")
    y += 25

    draw.text((10, y), "[6/6] Upscale 2K (2560x1440)...", font=font_mono, fill="#3fb950")
    y += 18
    draw.text((10, y), "      ✓ criativo_marina_b01_FINAL.mp4 (2560x1440, 18MB)", font=font_mono, fill="#f1c40f")
    y += 25

    if y < H - 50:
        draw.text((10, y), "✅  CRIATIVO GERADO COM SUCESSO!", font=font_mono, fill="#3fb950")
        y += 18
        draw.text((10, y), "$ _", font=font_mono, fill="#58a6ff")

    # Barra inferior
    draw.rectangle([0, H-20, W, H], fill="#21262d")
    draw.text((10, H-16), "Pipeline v2.0  |  Tempo total: 47s  |  Custo: R$ 0,12/criativo", font=font_sans, fill="#8b949e")

    path = os.path.join(OUTPUT_DIR, "v2_sc6_terminal_gerando_video.png")
    img.save(path, quality=95)
    print(f"✓ SC-6 salvo: {path}")
    return path

# ─────────────────────────────────────────────────────────────────────────────
# SC-7: Comparação lado a lado (IA genérica vs Movie Money)
# ─────────────────────────────────────────────────────────────────────────────
def gerar_sc7():
    img = Image.new("RGB", (W, H), "#0a0a0a")
    draw = ImageDraw.Draw(img)

    font_title = get_sans_font(26, bold=True)
    font_sub = get_sans_font(18, bold=True)
    font_small = get_sans_font(15)
    font_tag = get_sans_font(13)

    # Título central
    draw.text((W//2 - 220, 10), "LIP SYNC — AMADOR vs MOVIE MONEY", font=font_title, fill="#ffffff")
    draw.rectangle([40, 45, W-40, 47], fill="#333333")

    # Lado esquerdo — AMADOR
    draw.rectangle([20, 55, 610, H-60], fill="#1a0000")
    draw.rectangle([20, 55, 610, 95], fill="#c0392b")
    draw.text((30, 65), "❌  AMADOR — IA GENÉRICA", font=font_sub, fill="#ffffff")

    # Simulação de vídeo com boca dessincronizada
    draw.rectangle([40, 105, 590, 430], fill="#2c1a1a")
    draw.text((200, 220), "👤", font=get_sans_font(100), fill="#7f8c8d")
    draw.text((120, 340), "BOCA DESSINCRONIZADA", font=get_sans_font(18, bold=True), fill="#e74c3c")
    draw.text((140, 365), "Lábio mexe mas não forma palavras", font=font_tag, fill="#c0392b")

    # Métricas ruins
    draw.rectangle([40, 440, 590, 510], fill="#1e0000")
    draw.text((50, 450), "CPM: R$ 52,00  |  CTR: 0.2%", font=font_tag, fill="#e74c3c")
    draw.text((50, 470), "Retenção: 6%   |  ROAS: 0.3x", font=font_tag, fill="#e74c3c")
    draw.text((50, 490), "⚠  Alerta de golpe ativado no cérebro", font=font_tag, fill="#e74c3c")

    # Lado direito — MOVIE MONEY
    draw.rectangle([630, 55, W-20, H-60], fill="#001a00")
    draw.rectangle([630, 55, W-20, 95], fill="#27ae60")
    draw.text((640, 65), "✅  MOVIE MONEY — LIP SYNC REAL", font=font_sub, fill="#ffffff")

    # Simulação de vídeo com lip sync perfeito
    draw.rectangle([650, 105, W-40, 430], fill="#1a2c1a")
    draw.text((750, 220), "👤", font=get_sans_font(100), fill="#2ecc71")
    draw.text((670, 340), "SINCRONIA LABIAL PERFEITA", font=get_sans_font(18, bold=True), fill="#2ecc71")
    draw.text((680, 365), "Fala exata no prompt de geração", font=font_tag, fill="#27ae60")

    # Métricas boas
    draw.rectangle([650, 440, W-40, 510], fill="#001e00")
    draw.text((660, 450), "CPM: R$ 12,00  |  CTR: 3.8%", font=font_tag, fill="#2ecc71")
    draw.text((660, 470), "Retenção: 67%  |  ROAS: 4.2x", font=font_tag, fill="#2ecc71")
    draw.text((660, 490), "✅  Indetectável como IA", font=font_tag, fill="#2ecc71")

    # Seta central
    draw.text((W//2 - 15, H//2 - 20), "VS", font=get_sans_font(28, bold=True), fill="#f1c40f")

    # Rodapé
    draw.rectangle([0, H-60, W, H-40], fill="#333333")
    draw.text((W//2 - 200, H-55), "Movie Money — Engenharia de Conversão", font=font_small, fill="#f1c40f")

    path = os.path.join(OUTPUT_DIR, "v2_sc7_comparacao_lipsync.png")
    img.save(path, quality=95)
    print(f"✓ SC-7 salvo: {path}")
    return path

# ─────────────────────────────────────────────────────────────────────────────
# SC-8: Legendas na Safe Zone
# ─────────────────────────────────────────────────────────────────────────────
def gerar_sc8():
    img = Image.new("RGB", (W, H), "#0a0a0a")
    draw = ImageDraw.Draw(img)

    font_title = get_sans_font(24, bold=True)
    font_sub = get_sans_font(18, bold=True)
    font_small = get_sans_font(15)
    font_tag = get_sans_font(13)
    font_legenda = get_sans_font(22, bold=True)

    # Simula interface TikTok Shop
    # Fundo do vídeo
    draw.rectangle([200, 0, 900, H], fill="#1a1a2e")

    # Conteúdo do vídeo (persona Marina)
    draw.rectangle([220, 20, 880, H-120], fill="#2c2c54")
    draw.text((450, 200), "👤", font=get_sans_font(120), fill="#e91e8c")
    draw.text((300, 360), "Marina Costa", font=get_sans_font(28, bold=True), fill="#ffffff")
    draw.text((310, 395), "@marina.beleza", font=get_sans_font(18), fill="#aaaaaa")

    # Linha de Safe Zone (320px da base)
    safe_zone_y = H - 320
    draw.rectangle([200, safe_zone_y-1, 900, safe_zone_y+1], fill="#f1c40f")
    draw.text((905, safe_zone_y - 10), "← 320px", font=get_sans_font(14, bold=True), fill="#f1c40f")

    # Seta indicando a safe zone
    draw.text((905, safe_zone_y + 5), "← SAFE ZONE", font=get_sans_font(14, bold=True), fill="#f1c40f")

    # Legendas karaokê na safe zone
    legenda_y = H - 340
    draw.rectangle([210, legenda_y - 5, 890, legenda_y + 35], fill="#00000088")
    # Palavra destacada em amarelo, resto em branco
    draw.text((220, legenda_y), "Passei esse ", font=font_legenda, fill="#ffffff")
    draw.text((430, legenda_y), "body splash", font=font_legenda, fill="#f1c40f")  # palavra atual
    draw.text((660, legenda_y), " de manhã", font=font_legenda, fill="#ffffff")

    # Interface TikTok Shop (parte inferior)
    draw.rectangle([200, H-115, 900, H], fill="#ff6600")
    draw.text((220, H-105), "🛒  COMPRAR AGORA — R$ 29,90", font=get_sans_font(20, bold=True), fill="#ffffff")
    draw.text((220, H-75), "⭐⭐⭐⭐⭐  4.9 (2.847 avaliações)", font=get_sans_font(16), fill="#ffffff")
    draw.text((220, H-50), "📦  Frete grátis  |  Entrega em 3-5 dias", font=get_sans_font(15), fill="#ffffffcc")

    # Painel esquerdo — explicação
    draw.rectangle([0, 0, 195, H], fill="#111111")
    draw.text((5, 20), "SAFE", font=get_sans_font(16, bold=True), fill="#f1c40f")
    draw.text((5, 42), "ZONE", font=get_sans_font(16, bold=True), fill="#f1c40f")
    draw.text((5, 70), "320px", font=get_sans_font(14), fill="#ffffff")
    draw.text((5, 90), "da base", font=get_sans_font(14), fill="#ffffff")
    draw.rectangle([5, 115, 190, 117], fill="#f1c40f")
    draw.text((5, 125), "✓ Legenda", font=get_sans_font(12), fill="#2ecc71")
    draw.text((5, 143), "  visível", font=get_sans_font(12), fill="#2ecc71")
    draw.text((5, 161), "✓ Carrinho", font=get_sans_font(12), fill="#2ecc71")
    draw.text((5, 179), "  laranja", font=get_sans_font(12), fill="#2ecc71")
    draw.text((5, 197), "  livre", font=get_sans_font(12), fill="#2ecc71")

    # Painel direito — métricas
    draw.rectangle([905, 0, W, H], fill="#111111")
    draw.text((910, 20), "CTR", font=get_sans_font(14, bold=True), fill="#2ecc71")
    draw.text((910, 40), "3.8%", font=get_sans_font(18, bold=True), fill="#2ecc71")
    draw.rectangle([910, 65, W-5, 67], fill="#333333")
    draw.text((910, 75), "CVR", font=get_sans_font(14, bold=True), fill="#2ecc71")
    draw.text((910, 95), "4.2%", font=get_sans_font(18, bold=True), fill="#2ecc71")

    # Título
    draw.text((5, H-30), "Movie Money — Safe Zone 320px", font=get_sans_font(11), fill="#555555")

    path = os.path.join(OUTPUT_DIR, "v2_sc8_legendas_safe_zone.png")
    img.save(path, quality=95)
    print(f"✓ SC-8 salvo: {path}")
    return path

# ─────────────────────────────────────────────────────────────────────────────
# SC-9: Logo Movie Money final
# ─────────────────────────────────────────────────────────────────────────────
def gerar_sc9():
    img = Image.new("RGB", (W, H), "#0a0a0a")
    draw = ImageDraw.Draw(img)

    font_logo = get_sans_font(72, bold=True)
    font_sub = get_sans_font(32, bold=True)
    font_cta = get_sans_font(28, bold=True)
    font_small = get_sans_font(18)

    # Efeito de brilho sutil (gradiente simulado)
    for i in range(50):
        alpha = int(20 * (1 - i/50))
        draw.ellipse([W//2 - 300 + i*2, H//2 - 200 + i*2, W//2 + 300 - i*2, H//2 + 200 - i*2],
                     outline=(255, 193, 7, alpha))

    # Logo texto
    draw.text((W//2 - 230, H//2 - 80), "MOVIE", font=font_logo, fill="#f1c40f")
    draw.text((W//2 - 130, H//2 + 10), "MONEY", font=font_logo, fill="#ffffff")

    # Linha decorativa
    draw.rectangle([W//2 - 200, H//2 + 95, W//2 + 200, H//2 + 98], fill="#f1c40f")

    # CTA
    draw.text((W//2 - 280, H//2 + 115), "ASSISTA AO VÍDEO 3 — A OFERTA", font=font_cta, fill="#f1c40f")

    # Subtítulo
    draw.text((W//2 - 200, H//2 + 165), "movie-money.com.br", font=font_sub, fill="#555555")

    path = os.path.join(OUTPUT_DIR, "v2_sc9_logo_final.png")
    img.save(path, quality=95)
    print(f"✓ SC-9 salvo: {path}")
    return path

# ─────────────────────────────────────────────────────────────────────────────
# Executar todos
# ─────────────────────────────────────────────────────────────────────────────
if __name__ == "__main__":
    print("🎬 Gerando Screen Recordings do Vídeo 2: 'A Máquina por Dentro'")
    print("=" * 60)
    gerar_sc1()
    gerar_sc2()
    gerar_sc3()
    gerar_sc4()
    gerar_sc5()
    gerar_sc6()
    gerar_sc7()
    gerar_sc8()
    gerar_sc9()
    print("=" * 60)
    print("✅ Todos os 9 Screen Recordings gerados com sucesso!")
    print(f"📁 Pasta: {OUTPUT_DIR}")
