#!/usr/bin/env python3
"""
Gera Screen Recordings ANIMADOS para o Vídeo 2.
Cada SC é um vídeo MP4 com movimento real:
  - Terminal com texto digitando linha a linha
  - Código rolando de cima para baixo
  - Grids com fade-in progressivo
  - Comparações com animação de entrada
Nenhum print estático. Tudo em movimento.
"""

import os, subprocess, math
from PIL import Image, ImageDraw, ImageFont

W, H = 1280, 720
FPS = 25
OUT = "/home/ubuntu/Moviemoney/skill-movie-money/criativos/video_institucional_youtube/screens_v2_anim"
TMP = "/tmp/sc_frames"
os.makedirs(OUT, exist_ok=True)
os.makedirs(TMP, exist_ok=True)

# ── Fontes ──────────────────────────────────────────────────────────────────
def font(size, bold=False, mono=False):
    paths_mono = ["/usr/share/fonts/truetype/dejavu/DejaVuSansMono-Bold.ttf" if bold
                  else "/usr/share/fonts/truetype/dejavu/DejaVuSansMono.ttf"]
    paths_sans = ["/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf" if bold
                  else "/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf"]
    for p in (paths_mono if mono else paths_sans):
        if os.path.exists(p):
            try: return ImageFont.truetype(p, size)
            except: pass
    return ImageFont.load_default()

# ── Renderizar frames → MP4 ─────────────────────────────────────────────────
def frames_to_mp4(frame_dir, output_mp4, fps=FPS):
    cmd = [
        "ffmpeg", "-y",
        "-framerate", str(fps),
        "-i", f"{frame_dir}/frame_%05d.png",
        "-c:v", "libx264", "-preset", "fast", "-crf", "20",
        "-pix_fmt", "yuv420p",
        output_mp4
    ]
    subprocess.run(cmd, capture_output=True)
    dur = subprocess.run(
        ["ffprobe","-v","quiet","-show_entries","format=duration","-of","csv=p=0", output_mp4],
        capture_output=True, text=True).stdout.strip()
    print(f"  ✓ {os.path.basename(output_mp4)}  ({float(dur):.1f}s)")

def clear_frames(d):
    for f in os.listdir(d):
        if f.endswith(".png"): os.remove(os.path.join(d, f))

# ── Fundo terminal base ──────────────────────────────────────────────────────
def terminal_base(draw, title="Terminal — bash"):
    draw.rectangle([0,0,W,H], fill="#0d1117")
    draw.rectangle([0,0,W,32], fill="#21262d")
    draw.text((10,9), "●", font=font(14), fill="#ff5f57")
    draw.text((28,9), "●", font=font(14), fill="#febc2e")
    draw.text((46,9), "●", font=font(14), fill="#28c840")
    draw.text((W//2-len(title)*4, 9), title, font=font(13), fill="#8b949e")

# ── SC-1: Terminal mostrando métricas de anúncio genérico (texto digitando) ──
def sc1_anuncio_generico(dur_s=16):
    print("Gerando SC-1: Anúncio genérico (terminal animado)...")
    clear_frames(TMP)
    n_frames = int(dur_s * FPS)
    
    linhas = [
        ("$ ", "#58a6ff", "tiktok-audit --video=aliexpress_clip_01.mp4", "#c9d1d9"),
        ("", "", "", ""),
        ("⚠  ANÁLISE DE QUALIDADE DO CRIATIVO", "#e74c3c", "", ""),
        ("─"*60, "#30363d", "", ""),
        ("Codec de voz:    ", "#8b949e", "TTS genérico (voz robótica EN)", "#e74c3c"),
        ("Lip sync:        ", "#8b949e", "FALHO — lábio dessincronizado", "#e74c3c"),
        ("Idioma:          ", "#8b949e", "Inglês (mercado BR)", "#e74c3c"),
        ("Qualidade visual:", "#8b949e", "AliExpress raw (sem edição)", "#e74c3c"),
        ("", "", "", ""),
        ("📊  MÉTRICAS PREVISTAS (modelo preditivo):", "#f1c40f", "", ""),
        ("   CPM estimado: ", "#8b949e", "R$ 48,70  ← ALTO", "#e74c3c"),
        ("   CTR:          ", "#8b949e", "0.3%      ← CRÍTICO", "#e74c3c"),
        ("   Retenção 3s:  ", "#8b949e", "8%        ← CRÍTICO", "#e74c3c"),
        ("   ROAS:         ", "#8b949e", "0.4x      ← PREJUÍZO", "#e74c3c"),
        ("", "", "", ""),
        ("❌  DIAGNÓSTICO: Algoritmo TikTok vai PUNIR este vídeo.", "#e74c3c", "", ""),
        ("   Motivo: grita 'anúncio falso' nos primeiros 2 segundos.", "#8b949e", "", ""),
        ("", "", "", ""),
        ("$ _", "#58a6ff", "", ""),
    ]
    
    # Quantos chars revelar por frame (efeito digitando)
    total_chars = sum(len(a)+len(b) for _,_,a,b in linhas)
    chars_per_frame = max(1, total_chars // (n_frames * 0.7))
    
    chars_shown = 0
    for fi in range(n_frames):
        img = Image.new("RGB", (W, H), "#0d1117")
        draw = ImageDraw.Draw(img)
        terminal_base(draw)
        
        chars_shown = min(total_chars, int(fi * chars_per_frame) + 1)
        
        y = 45
        chars_acc = 0
        fn = font(14, mono=True)
        for prefix, pc, text, tc in linhas:
            full = prefix + text
            if not full:  # linha em branco
                chars_acc += 0
                y += 22
                if y > H - 20: break
                continue
            if chars_acc >= chars_shown:
                break
            remaining = chars_shown - chars_acc
            visible = full[:remaining]
            # Dividir em prefix e text
            safe_pc = pc if pc else "#ffffff"
            safe_tc = tc if tc else "#ffffff"
            if len(visible) <= len(prefix):
                if visible: draw.text((10, y), visible, font=fn, fill=safe_pc)
            else:
                if prefix: draw.text((10, y), prefix, font=fn, fill=safe_pc)
                rest = visible[len(prefix):]
                if rest: draw.text((10 + len(prefix)*8, y), rest, font=fn, fill=safe_tc)
            chars_acc += len(full)
            y += 22
            if y > H - 20: break
        
        # Cursor piscante
        if fi % 20 < 10:
            draw.rectangle([10 + (chars_shown % 80)*8, y-22, 10 + (chars_shown%80)*8+8, y-4], fill="#58a6ff")
        
        img.save(f"{TMP}/frame_{fi:05d}.png")
    
    frames_to_mp4(TMP, f"{OUT}/sc1_anim.mp4")

# ── SC-2: VS Code com estrutura de pastas rolando ───────────────────────────
def sc2_vscode_rolando(dur_s=15):
    print("Gerando SC-2: VS Code (estrutura rolando)...")
    clear_frames(TMP)
    n_frames = int(dur_s * FPS)
    
    # Conteúdo do arquivo README.md — linhas longas
    linhas_editor = [
        ("# Movie Money — Infraestrutura de Produção", "#4fc1ff"),
        ("", "#ffffff"),
        ("## O que é isso?", "#569cd6"),
        ("", "#ffffff"),
        ("Esta é a máquina por trás dos criativos de alta conversão.", "#d4d4d4"),
        ("Não é uma pasta no Google Drive. É engenharia.", "#d4d4d4"),
        ("", "#ffffff"),
        ("## Estrutura", "#569cd6"),
        ("", "#ffffff"),
        ("skill-movie-money/", "#4ec9b0"),
        ("├── templates/", "#4ec9b0"),
        ("│   ├── personagens/    # 5 personas UGC com IP próprio", "#6a9955"),
        ("│   │   ├── beto.png", "#ce9178"),
        ("│   │   ├── marina_costa.png", "#ce9178"),
        ("│   │   ├── lucas_ferreira.png", "#ce9178"),
        ("│   │   ├── rafael_santos.png", "#ce9178"),
        ("│   │   ├── beatriz_oliveira.png", "#ce9178"),
        ("│   │   └── diego_almeida.png", "#ce9178"),
        ("│   ├── vozes/          # Voz Fenrir pt-BR (48kHz)", "#6a9955"),
        ("│   └── cenas/          # Cenários por persona", "#6a9955"),
        ("├── criativos/          # Vídeos produzidos", "#4ec9b0"),
        ("│   └── video_institucional_youtube/", "#4ec9b0"),
        ("│       ├── takes_v2/   # 11 takes Beto com lip sync", "#6a9955"),
        ("│       └── screens_v2/ # Screen recordings animados", "#6a9955"),
        ("├── skills/", "#4ec9b0"),
        ("│   └── moviemoney-production/  # Skill de produção", "#4ec9b0"),
        ("│       ├── SKILL.md", "#ce9178"),
        ("│       └── references/video_standards.md", "#ce9178"),
        ("└── scripts/            # Pipeline ffmpeg automatizado", "#4ec9b0"),
        ("    ├── montar_video2_v3.sh", "#ce9178"),
        ("    └── gerar_sc_animados.py", "#ce9178"),
        ("", "#ffffff"),
        ("## Tecnologia", "#569cd6"),
        ("", "#ffffff"),
        ("- Lip Sync: Omni-Flash (fala exata no prompt)", "#d4d4d4"),
        ("- Voz: Fenrir pt-BR — 100% português, zero inglês", "#d4d4d4"),
        ("- Safe Zone: 320px da borda inferior", "#d4d4d4"),
        ("- Crossfade: 0.3s entre takes de Talking Head", "#d4d4d4"),
        ("- Ken Burns: zoom 1.0→1.08 nos Screen Recordings", "#d4d4d4"),
    ]
    
    fn = font(14, mono=True)
    fn_sm = font(12, mono=True)
    fn_ui = font(13)
    line_h = 19
    visible_lines = (H - 90) // line_h
    
    # Rolar do topo até o fim
    total_scroll = max(0, len(linhas_editor) - visible_lines)
    
    for fi in range(n_frames):
        img = Image.new("RGB", (W, H), "#1e1e1e")
        draw = ImageDraw.Draw(img)
        
        # Barra título
        draw.rectangle([0,0,W,30], fill="#323233")
        draw.text((10,8), "● ● ●", font=fn_ui, fill="#888888")
        draw.text((W//2-200,8), "README.md — trentomotta7-hub/Moviemoney", font=fn_ui, fill="#cccccc")
        
        # Abas
        draw.rectangle([0,30,W,52], fill="#2d2d2d")
        draw.rectangle([0,30,190,52], fill="#1e1e1e")
        draw.text((8,37), "📄 README.md  ×", font=fn_ui, fill="#ffffff")
        
        # Sidebar
        draw.rectangle([0,52,200,H], fill="#252526")
        draw.text((8,60), "EXPLORADOR", font=font(11,bold=True), fill="#bbbbbb")
        sidebar_items = [
            ("📁 Moviemoney","#4fc1ff"),("  📁 skill-movie-money","#4fc1ff"),
            ("    📁 templates","#4fc1ff"),("    📁 criativos","#4fc1ff"),
            ("    📁 skills","#4fc1ff"),("    📁 scripts","#4fc1ff"),
            ("  📄 README.md","#f1fa8c"),
        ]
        sy = 78
        for txt, col in sidebar_items:
            draw.text((8,sy), txt, font=font(12,mono=True), fill=col)
            sy += 17
        
        # Editor — rolar suavemente
        scroll = int(total_scroll * fi / n_frames)
        y = 60
        for i, (txt, col) in enumerate(linhas_editor[scroll:scroll+visible_lines]):
            num = scroll + i + 1
            draw.text((205,y), f"{num:3d}", font=fn_sm, fill="#555555")
            draw.text((240,y), txt, font=fn_sm, fill=col)
            y += line_h
        
        # Cursor piscante na linha atual
        cur_line = min(scroll + visible_lines//2, len(linhas_editor)-1)
        cur_y = 60 + (cur_line - scroll) * line_h
        if fi % 20 < 12:
            draw.rectangle([240,cur_y,248,cur_y+line_h-2], fill="#aeafad")
        
        # Status bar
        draw.rectangle([0,H-22,W,H], fill="#007acc")
        draw.text((8,H-18), f"🔵 main  Linha {cur_line+1}  |  UTF-8  |  Markdown", font=fn_ui, fill="#ffffff")
        
        img.save(f"{TMP}/frame_{fi:05d}.png")
    
    frames_to_mp4(TMP, f"{OUT}/sc2_anim.mp4")

# ── SC-3: Grid de personagens com fade-in progressivo ───────────────────────
def sc3_grid_personagens(dur_s=25):
    print("Gerando SC-3: Grid personagens (fade-in progressivo)...")
    clear_frames(TMP)
    n_frames = int(dur_s * FPS)
    
    personagens = [
        ("Lucas Ferreira", "Tech & Gadgets", "#3498db", "💻"),
        ("Marina Costa",   "Beleza & Skincare","#e91e8c","💄"),
        ("Rafael Santos",  "Fitness & Saúde",  "#27ae60","💪"),
        ("Beatriz Oliveira","Produtividade",    "#9b59b6","📊"),
        ("Diego Almeida",  "Produtos Virais",   "#e67e22","🔥"),
    ]
    
    fn_title = font(30, bold=True)
    fn_name  = font(18, bold=True)
    fn_tag   = font(14)
    fn_sm    = font(13)
    
    card_w, card_h = 220, 520
    gap = 10
    start_x = (W - (5*card_w + 4*gap)) // 2
    
    for fi in range(n_frames):
        img = Image.new("RGB", (W, H), "#0a0a0a")
        draw = ImageDraw.Draw(img)
        
        # Título com fade-in
        title_alpha = min(1.0, fi / (FPS * 0.8))
        tc = int(241 * title_alpha)
        draw.text((W//2-310, 12), "ELENCO MOVIE MONEY — 5 PERSONAS UGC",
                  font=fn_title, fill=(tc, int(193*title_alpha), int(7*title_alpha)))
        draw.rectangle([50, 52, W-50, 54], fill=(tc, int(193*title_alpha), int(7*title_alpha)))
        
        # Cada card aparece com delay
        for i, (nome, nicho, cor, emoji) in enumerate(personagens):
            delay_frames = int(i * FPS * 0.4)
            if fi < delay_frames:
                continue
            
            prog = min(1.0, (fi - delay_frames) / (FPS * 0.5))
            x = start_x + i * (card_w + gap)
            y_offset = int((1 - prog) * 40)
            y = 65 + y_offset
            alpha = int(255 * prog)
            
            r, g, b = int(cor[1:3],16), int(cor[3:5],16), int(cor[5:7],16)
            
            # Card
            draw.rectangle([x, y, x+card_w, y+card_h], fill="#1a1a1a")
            draw.rectangle([x, y, x+card_w, y+4], fill=cor)
            
            # Avatar placeholder
            draw.rectangle([x+10, y+15, x+card_w-10, y+350], fill="#2c2c2c")
            draw.text((x+card_w//2-25, y+130), emoji, font=font(70), fill=cor)
            
            # Nome
            draw.text((x+8, y+360), nome, font=fn_name, fill="#ffffff")
            
            # Tag de nicho
            draw.rectangle([x+8, y+390, x+card_w-8, y+415], fill=cor)
            draw.text((x+12, y+394), nicho, font=fn_tag, fill="#ffffff")
            
            # Atributos
            for j, attr in enumerate(["✓ Lip Sync Perfeito","✓ Nunca atrasa","✓ Consistente"]):
                draw.text((x+8, y+425+j*20), attr, font=fn_sm, fill="#2ecc71")
        
        img.save(f"{TMP}/frame_{fi:05d}.png")
    
    frames_to_mp4(TMP, f"{OUT}/sc3_anim.mp4")

# ── SC-4: banco_narrativo.md com cursor rolando e highlight ─────────────────
def sc4_banco_narrativo(dur_s=15):
    print("Gerando SC-4: Banco Narrativo (cursor rolando)...")
    clear_frames(TMP)
    n_frames = int(dur_s * FPS)
    
    linhas = [
        ("# Banco Narrativo — Movie Money", "#4fc1ff"),
        ("## 70 Dores Validadas do Mercado Brasileiro", "#569cd6"),
        ("", "#ffffff"),
        ("### Categoria B — Perfumaria & Bodysplash", "#ce9178"),
        ("", "#ffffff"),
        ("**B1: Cheiro que não dura**", "#f1c40f"),
        ('> "Passei esse body splash de manhã e minha amiga', "#6a9955"),
        ('> perguntou o que eu tava usando às dez da noite"', "#6a9955"),
        ("", "#ffffff"),
        ("**B2: Preço alto para o que entrega**", "#d4d4d4"),
        ('> "Esse body splash custa R$25 e cheira igual', "#6a9955"),
        ('> ao perfume de R$400 da minha chefe"', "#6a9955"),
        ("", "#ffffff"),
        ("**B3: Embalagem que parece genérica**", "#d4d4d4"),
        ('> "Recebi esse produto e achei que era falso.', "#6a9955"),
        ('> Testei e nunca mais comprei outro"', "#6a9955"),
        ("", "#ffffff"),
        ("### Categoria C — Skincare & Beleza", "#ce9178"),
        ("", "#ffffff"),
        ("**C1: Produto que promete e não entrega**", "#d4d4d4"),
        ("**C2: Demora para ver resultado**", "#d4d4d4"),
        ("**C3: Textura ruim na pele**", "#d4d4d4"),
        ("**C4: Preço inacessível**", "#d4d4d4"),
        ("", "#ffffff"),
        ("### Categoria T — Tech & Gadgets", "#ce9178"),
        ("", "#ffffff"),
        ("**T1: Para de funcionar em 30 dias**", "#d4d4d4"),
        ("**T2: Instruções só em chinês**", "#d4d4d4"),
        ("**T3: Bateria que não dura**", "#d4d4d4"),
        ("", "#ffffff"),
        ("[ ... 70 dores mapeadas no total ... ]", "#555555"),
    ]
    
    fn = font(14, mono=True)
    fn_sm = font(12, mono=True)
    fn_ui = font(13)
    line_h = 20
    visible = (H - 80) // line_h
    total_scroll = max(0, len(linhas) - visible)
    
    for fi in range(n_frames):
        img = Image.new("RGB", (W, H), "#1e1e1e")
        draw = ImageDraw.Draw(img)
        
        draw.rectangle([0,0,W,30], fill="#323233")
        draw.text((10,8),"● ● ●",font=fn_ui,fill="#888888")
        draw.text((W//2-180,8),"banco_narrativo.md — VS Code",font=fn_ui,fill="#cccccc")
        draw.rectangle([0,30,W,52],fill="#2d2d2d")
        draw.rectangle([0,30,210,52],fill="#1e1e1e")
        draw.text((8,37),"📄 banco_narrativo.md  ×",font=fn_ui,fill="#ffffff")
        
        scroll = int(total_scroll * fi / n_frames)
        cur_line = scroll + visible // 2
        
        y = 58
        for i, (txt, col) in enumerate(linhas[scroll:scroll+visible]):
            lnum = scroll + i + 1
            is_cur = (lnum == cur_line + 1)
            if is_cur:
                draw.rectangle([0, y-2, W, y+line_h], fill="#264f78")
            draw.text((8, y), f"{lnum:3d}", font=fn_sm, fill="#555555")
            draw.text((50, y), txt, font=fn_sm, fill=col)
            y += line_h
        
        draw.rectangle([0,H-22,W,H],fill="#007acc")
        draw.text((8,H-18),f"🔵 main  Linha {cur_line+1}  |  UTF-8  |  Markdown  |  70 dores",font=fn_ui,fill="#ffffff")
        
        img.save(f"{TMP}/frame_{fi:05d}.png")
    
    frames_to_mp4(TMP, f"{OUT}/sc4_anim.mp4")

# ── SC-5: Terminal com lista de dores rolando ────────────────────────────────
def sc5_lista_dores(dur_s=18):
    print("Gerando SC-5: Lista 70 dores (terminal rolando)...")
    clear_frames(TMP)
    n_frames = int(dur_s * FPS)
    
    dores_todas = [
        ("B01","Perfumaria","Cheiro que não dura","9.8",True),
        ("B02","Perfumaria","Preço alto para o que entrega","8.7",False),
        ("B03","Perfumaria","Embalagem que parece genérica","7.9",False),
        ("B04","Perfumaria","Vício em perfume caro","8.2",False),
        ("B05","Perfumaria","Não sabe qual escolher","7.5",False),
        ("C01","Skincare","Produto que promete e não entrega","9.1",False),
        ("C02","Skincare","Demora para ver resultado","8.5",False),
        ("C03","Skincare","Textura ruim na pele","7.6",False),
        ("C04","Skincare","Preço inacessível","8.0",False),
        ("C05","Skincare","Pele oleosa que piora","8.3",False),
        ("T01","Tech","Para de funcionar em 30 dias","9.3",False),
        ("T02","Tech","Instruções só em chinês","8.8",False),
        ("T03","Tech","Bateria que não dura","9.0",False),
        ("T04","Tech","Incompatível com celular","7.4",False),
        ("T05","Tech","Carregamento lento","8.1",False),
        ("F01","Fitness","Suplemento sem resultado","9.2",False),
        ("F02","Fitness","Sabor horrível do whey","8.1",False),
        ("F03","Fitness","Equipamento que ocupa espaço","7.8",False),
        ("F04","Fitness","Dieta que não sustenta","8.6",False),
        ("P01","Produtividade","Foco que não vem","8.9",False),
        ("P02","Produtividade","Procrastinação crônica","9.4",False),
        ("P03","Produtividade","Reuniões que não terminam","8.0",False),
        ("M01","Moda","Roupa que desbota","8.5",False),
        ("M02","Moda","Tamanho que não bate","9.0",False),
        ("M03","Moda","Tecido que amassa","7.7",False),
        ("A01","Alimentação","Marmita que estraga","8.8",False),
        ("A02","Alimentação","Dieta cara demais","9.1",False),
        ("A03","Alimentação","Sabor ruim de saudável","8.3",False),
        ("...", "...", "[ + 42 dores mapeadas ]", "...", False),
    ]
    
    fn = font(13, mono=True)
    fn_ui = font(13)
    line_h = 22
    header_h = 80
    visible = (H - header_h - 30) // line_h
    total_scroll = max(0, len(dores_todas) - visible)
    
    for fi in range(n_frames):
        img = Image.new("RGB", (W, H), "#0d1117")
        draw = ImageDraw.Draw(img)
        terminal_base(draw, "Movie Money Analytics — banco de dores")
        
        # Header
        draw.text((10,40),"$ python3 listar_dores.py --all --sort=score",font=fn,fill="#58a6ff")
        draw.text((10,58),"✓ 34.847 vídeos analisados  |  70 dores validadas",font=fn,fill="#3fb950")
        draw.rectangle([10,76,W-10,77],fill="#30363d")
        draw.text((10,79),f"{'ID':<5}{'CATEGORIA':<16}{'DOR MAPEADA':<42}{'SCORE'}",font=fn,fill="#8b949e")
        
        scroll = int(total_scroll * fi / n_frames)
        y = header_h + 5
        for id_, cat, dor, score, hl in dores_todas[scroll:scroll+visible]:
            if hl:
                draw.rectangle([10,y-2,W-10,y+line_h-2],fill="#1f3a1f")
                col = "#f1c40f"
            else:
                col = "#c9d1d9"
            draw.text((10,y), f"{id_:<5}{cat:<16}{dor:<42}{score}", font=fn, fill=col)
            y += line_h
            if y > H-30: break
        
        # Cursor
        draw.text((10,H-28),"$ _",font=fn,fill="#58a6ff")
        draw.rectangle([0,H-22,W,H],fill="#21262d")
        draw.text((10,H-18),"Movie Money Analytics  |  34.847 vídeos  |  70 dores",font=fn_ui,fill="#8b949e")
        
        img.save(f"{TMP}/frame_{fi:05d}.png")
    
    frames_to_mp4(TMP, f"{OUT}/sc5_anim.mp4")

# ── SC-6: Terminal com pipeline de geração rolando ───────────────────────────
def sc6_pipeline(dur_s=22):
    print("Gerando SC-6: Pipeline de geração (terminal digitando)...")
    clear_frames(TMP)
    n_frames = int(dur_s * FPS)
    
    etapas = [
        ("$ bash montar_video_criativo.sh --persona=marina --dor=B01", "#58a6ff"),
        ("", "#ffffff"),
        ("╔══════════════════════════════════════════════╗", "#30363d"),
        ("║  MOVIE MONEY — PIPELINE DE PRODUÇÃO v2.0    ║", "#f1c40f"),
        ("╚══════════════════════════════════════════════╝", "#30363d"),
        ("", "#ffffff"),
        ("[1/6] Carregando persona: Marina Costa (Beleza)...", "#3fb950"),
        ("      ✓ Keyframe: marina_costa.png (1280x720)", "#8b949e"),
        ("      ✓ Voz: Fenrir pt-BR (48kHz stereo)", "#8b949e"),
        ("", "#ffffff"),
        ("[2/6] Selecionando dor: B01 — Cheiro que não dura", "#3fb950"),
        ("      HOOK: \"Passei esse body splash de manhã e minha", "#f1c40f"),
        ("             amiga perguntou o que eu tava usando", "#f1c40f"),
        ("             às dez da noite\"", "#f1c40f"),
        ("", "#ffffff"),
        ("[3/6] Gerando áudio TTS (Fenrir pt-BR)...", "#3fb950"),
        ("      ✓ marina_b01_hook.wav (4.2s, 48kHz stereo)", "#8b949e"),
        ("", "#ffffff"),
        ("[4/6] Gerando vídeo com lip sync (Omni-Flash)...", "#3fb950"),
        ("      Prompt: \"Marina Costa fala: 'Passei esse body", "#8b949e"),
        ("      splash de manhã...'\"", "#8b949e"),
        ("      ✓ marina_b01_hook.mp4 (4.2s, 1280x720)", "#8b949e"),
        ("", "#ffffff"),
        ("[5/6] Aplicando legendas karaokê (Safe Zone 320px)...", "#3fb950"),
        ("      ✓ Amarelo/branco posicionadas a 320px da base", "#8b949e"),
        ("", "#ffffff"),
        ("[6/6] Upscale 2K (2560x1440)...", "#3fb950"),
        ("      ✓ criativo_marina_b01_FINAL.mp4 (2560x1440)", "#f1c40f"),
        ("", "#ffffff"),
        ("✅  CRIATIVO GERADO!  Tempo: 47s  Custo: R$0,12", "#3fb950"),
        ("$ _", "#58a6ff"),
    ]
    
    fn = font(13, mono=True)
    fn_ui = font(13)
    total_lines = len(etapas)
    lines_per_frame = total_lines / (n_frames * 0.75)
    
    for fi in range(n_frames):
        img = Image.new("RGB", (W, H), "#0d1117")
        draw = ImageDraw.Draw(img)
        terminal_base(draw, "Terminal — Pipeline Movie Money")
        
        lines_shown = min(total_lines, int(fi * lines_per_frame) + 1)
        
        # Scroll automático quando passa de 28 linhas visíveis
        max_visible = 28
        start = max(0, lines_shown - max_visible)
        
        y = 42
        for txt, col in etapas[start:lines_shown]:
            draw.text((10, y), txt, font=fn, fill=col)
            y += 20
            if y > H - 30: break
        
        # Cursor piscante
        if fi % 20 < 12 and lines_shown < total_lines:
            draw.rectangle([10, y-2, 18, y+14], fill="#58a6ff")
        
        draw.rectangle([0,H-22,W,H],fill="#21262d")
        draw.text((10,H-18),"Pipeline v2.0  |  Custo médio: R$0,12/criativo",font=fn_ui,fill="#8b949e")
        
        img.save(f"{TMP}/frame_{fi:05d}.png")
    
    frames_to_mp4(TMP, f"{OUT}/sc6_anim.mp4")

# ── SC-7: Comparação Amador vs Movie Money com animação ─────────────────────
def sc7_comparacao(dur_s=27):
    print("Gerando SC-7: Comparação Lip Sync (animação de entrada)...")
    clear_frames(TMP)
    n_frames = int(dur_s * FPS)
    
    fn_title = font(24, bold=True)
    fn_sub   = font(18, bold=True)
    fn_sm    = font(14)
    fn_tag   = font(13)
    
    for fi in range(n_frames):
        img = Image.new("RGB", (W, H), "#0a0a0a")
        draw = ImageDraw.Draw(img)
        
        # Título
        t_prog = min(1.0, fi / (FPS * 0.6))
        tc = int(255 * t_prog)
        draw.text((W//2-220, 10), "LIP SYNC — AMADOR vs MOVIE MONEY",
                  font=fn_title, fill=(tc, tc, tc))
        draw.rectangle([40, 44, W-40, 46], fill=(80,80,80))
        
        # Painel AMADOR — entra da esquerda
        left_prog = min(1.0, max(0.0, (fi - FPS*0.3) / (FPS * 0.5)))
        lx = int(-620 + 640 * left_prog)
        
        draw.rectangle([lx+20, 54, lx+600, H-50], fill="#1a0000")
        draw.rectangle([lx+20, 54, lx+600, 90], fill="#c0392b")
        draw.text((lx+30, 62), "❌  AMADOR — IA GENÉRICA", font=fn_sub, fill="#ffffff")
        draw.rectangle([lx+30, 100, lx+590, 400], fill="#2c1a1a")
        draw.text((lx+180, 200), "👤", font=font(90), fill="#7f8c8d")
        draw.text((lx+80, 330), "BOCA DESSINCRONIZADA", font=font(17,bold=True), fill="#e74c3c")
        draw.text((lx+90, 355), "Lábio mexe, não forma palavras", font=fn_tag, fill="#c0392b")
        draw.rectangle([lx+30, 408, lx+590, 470], fill="#1e0000")
        for j, txt in enumerate(["CPM: R$52  |  CTR: 0.2%","Retenção: 6%  |  ROAS: 0.3x","⚠ Alerta de golpe ativado"]):
            draw.text((lx+40, 415+j*18), txt, font=fn_tag, fill="#e74c3c")
        
        # Painel MOVIE MONEY — entra da direita
        right_prog = min(1.0, max(0.0, (fi - FPS*0.6) / (FPS * 0.5)))
        rx = int(W + 20 - 660 * right_prog)
        
        draw.rectangle([rx, 54, rx+620, H-50], fill="#001a00")
        draw.rectangle([rx, 54, rx+620, 90], fill="#27ae60")
        draw.text((rx+10, 62), "✅  MOVIE MONEY — LIP SYNC REAL", font=fn_sub, fill="#ffffff")
        draw.rectangle([rx+10, 100, rx+610, 400], fill="#1a2c1a")
        draw.text((rx+180, 200), "👤", font=font(90), fill="#2ecc71")
        draw.text((rx+60, 330), "SINCRONIA LABIAL PERFEITA", font=font(17,bold=True), fill="#2ecc71")
        draw.text((rx+80, 355), "Fala exata no prompt de geração", font=fn_tag, fill="#27ae60")
        draw.rectangle([rx+10, 408, rx+610, 470], fill="#001e00")
        for j, txt in enumerate(["CPM: R$12  |  CTR: 3.8%","Retenção: 67%  |  ROAS: 4.2x","✅ Indetectável como IA"]):
            draw.text((rx+20, 415+j*18), txt, font=fn_tag, fill="#2ecc71")
        
        # VS central
        vs_prog = min(1.0, max(0.0, (fi - FPS*0.8) / (FPS * 0.3)))
        draw.text((W//2-18, H//2-18), "VS", font=font(28,bold=True),
                  fill=(int(241*vs_prog), int(196*vs_prog), int(15*vs_prog)))
        
        img.save(f"{TMP}/frame_{fi:05d}.png")
    
    frames_to_mp4(TMP, f"{OUT}/sc7_anim.mp4")

# ── SC-8: Safe Zone com legenda animada ─────────────────────────────────────
def sc8_safe_zone(dur_s=25):
    print("Gerando SC-8: Safe Zone (legenda animada)...")
    clear_frames(TMP)
    n_frames = int(dur_s * FPS)
    
    fn_leg = font(22, bold=True)
    fn_sm  = font(14)
    fn_ui  = font(13)
    
    palavras = ["Passei", "esse", "body", "splash", "de", "manhã", "e", "minha",
                "amiga", "perguntou", "o", "que", "eu", "tava", "usando", "às",
                "dez", "da", "noite"]
    
    for fi in range(n_frames):
        img = Image.new("RGB", (W, H), "#0a0a0a")
        draw = ImageDraw.Draw(img)
        
        # Fundo do "vídeo" TikTok
        draw.rectangle([200, 0, 900, H], fill="#1a1a2e")
        draw.rectangle([220, 20, 880, H-110], fill="#2c2c54")
        
        # Avatar animado (simula Beto falando — boca pulsando)
        pulse = math.sin(fi * 0.3) * 5
        draw.ellipse([400, 150+pulse, 700, 420-pulse], fill="#3d3d6b")
        draw.text((460, 240), "👤", font=font(110), fill="#9b59b6")
        draw.text((430, 370), "Beto — Movie Money", font=font(18,bold=True), fill="#ffffff")
        
        # Linha Safe Zone
        safe_y = H - 320
        draw.rectangle([200, safe_y-1, 900, safe_y+1], fill="#f1c40f")
        
        # Seta e label pulsando
        arrow_alpha = int(200 + 55 * math.sin(fi * 0.15))
        draw.text((905, safe_y-12), "← 320px", font=font(14,bold=True),
                  fill=(241, 196, 15))
        draw.text((905, safe_y+4), "SAFE ZONE", font=font(13,bold=True),
                  fill=(241, 196, 15))
        
        # Legenda karaokê animada — palavra atual destacada
        word_idx = int(fi / n_frames * len(palavras))
        word_idx = min(word_idx, len(palavras)-1)
        
        leg_y = H - 345
        draw.rectangle([210, leg_y-5, 890, leg_y+32], fill=(0,0,0,180))
        
        x_cur = 215
        for wi, palavra in enumerate(palavras[:min(word_idx+5, len(palavras))]):
            if wi == word_idx:
                draw.text((x_cur, leg_y), palavra, font=fn_leg, fill="#f1c40f")
                w = len(palavra) * 13 + 8
            else:
                draw.text((x_cur, leg_y), palavra, font=fn_leg, fill="#ffffff")
                w = len(palavra) * 13 + 8
            x_cur += w
            if x_cur > 870:
                break
        
        # Carrinho TikTok Shop
        draw.rectangle([200, H-105, 900, H], fill="#ff6600")
        draw.text((220, H-95), "🛒  COMPRAR AGORA — R$ 29,90", font=font(20,bold=True), fill="#ffffff")
        draw.text((220, H-65), "⭐⭐⭐⭐⭐  4.9 (2.847 avaliações)", font=font(16), fill="#ffffff")
        draw.text((220, H-40), "📦  Frete grátis  |  Entrega 3-5 dias", font=font(15), fill="#ffffffcc")
        
        # Painel esquerdo
        draw.rectangle([0,0,195,H], fill="#111111")
        draw.text((5,20),"SAFE",font=font(16,bold=True),fill="#f1c40f")
        draw.text((5,42),"ZONE",font=font(16,bold=True),fill="#f1c40f")
        draw.text((5,65),"320px",font=font(14),fill="#ffffff")
        draw.text((5,85),"da base",font=font(14),fill="#ffffff")
        draw.rectangle([5,110,190,112],fill="#f1c40f")
        for j, txt in enumerate(["✓ Legenda","  visível","✓ Carrinho","  laranja","  livre"]):
            draw.text((5,120+j*18),txt,font=font(12),fill="#2ecc71")
        
        img.save(f"{TMP}/frame_{fi:05d}.png")
    
    frames_to_mp4(TMP, f"{OUT}/sc8_anim.mp4")

# ── SC-9: Logo final com fade ────────────────────────────────────────────────
def sc9_logo(dur_s=5):
    print("Gerando SC-9: Logo final (fade)...")
    clear_frames(TMP)
    n_frames = int(dur_s * FPS)
    fn_logo = font(72, bold=True)
    fn_cta  = font(28, bold=True)
    fn_sub  = font(20)
    
    for fi in range(n_frames):
        progress = fi / n_frames
        if progress < 0.2:
            alpha = progress / 0.2
        elif progress > 0.8:
            alpha = (1 - progress) / 0.2
        else:
            alpha = 1.0
        
        img = Image.new("RGB", (W, H), "#0a0a0a")
        draw = ImageDraw.Draw(img)
        
        c = int(255 * alpha)
        cy = int(193 * alpha)
        draw.text((W//2-230, H//2-80), "MOVIE", font=fn_logo, fill=(c, cy, int(7*alpha)))
        draw.text((W//2-130, H//2+10), "MONEY", font=fn_logo, fill=(c, c, c))
        draw.rectangle([W//2-200, H//2+95, W//2+200, H//2+98], fill=(c, cy, int(7*alpha)))
        draw.text((W//2-280, H//2+115), "ASSISTA AO VÍDEO 3 — A OFERTA",
                  font=fn_cta, fill=(c, cy, int(7*alpha)))
        draw.text((W//2-190, H//2+165), "movie-money.com.br", font=fn_sub,
                  fill=(int(85*alpha), int(85*alpha), int(85*alpha)))
        
        img.save(f"{TMP}/frame_{fi:05d}.png")
    
    frames_to_mp4(TMP, f"{OUT}/sc9_anim.mp4")

if __name__ == "__main__":
    print("🎬 Gerando Screen Recordings ANIMADOS — Vídeo 2")
    print("=" * 55)
    sc1_anuncio_generico()
    sc2_vscode_rolando()
    sc3_grid_personagens()
    sc4_banco_narrativo()
    sc5_lista_dores()
    sc6_pipeline()
    sc7_comparacao()
    sc8_safe_zone()
    sc9_logo()
    print("=" * 55)
    print(f"✅  9 SCs animados prontos em: {OUT}")
