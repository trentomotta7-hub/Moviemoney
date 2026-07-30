#!/usr/bin/env python3
"""
gerar_karaoke_preciso.py — Karaokê fill progressivo estilo música.

Uso: python3 gerar_karaoke_preciso.py <words.json> <output.ass> [res_x] [res_y]

Comportamento:
- Usa \\kf (karaoke fill) — preenche da esquerda para direita progressivamente
- Quebra linhas por frase semântica (pontuação) ou máximo de palavras
- Linha inteira visível em branco; cor amarela avança conforme a fala
- Fonte grande e legível, canto inferior da tela
"""

import sys
import json
import re

MAX_PALAVRAS_LINHA = 5
FONTE = "Arial"
BORDA = 3.0
SOMBRA = 1.5
MARGEM_V_RATIO = 0.07   # 7% da altura da tela

def segundos_para_ass(s: float) -> str:
    h = int(s // 3600)
    m = int((s % 3600) // 60)
    sec = s % 60
    cs = int((sec % 1) * 100)
    return f"{h}:{m:02d}:{int(sec):02d}.{cs:02d}"

def limpar_palavra(w: str) -> str:
    return re.sub(r'[.,!?;:]$', '', w.strip())

def e_fim_de_frase(palavra: str) -> bool:
    """Detecta fim de frase semântica pela pontuação."""
    return bool(re.search(r'[.!?]$', palavra.strip()))

def agrupar_por_frase(words: list) -> list:
    """
    Agrupa palavras em linhas respeitando:
    1. Fim de frase (pontuação .!?)
    2. Máximo de MAX_PALAVRAS_LINHA palavras
    Garante que frases não sejam cortadas no meio.
    """
    grupos = []
    atual = []

    for i, w in enumerate(words):
        atual.append(w)
        fim_frase = e_fim_de_frase(w['word'])
        limite = len(atual) >= MAX_PALAVRAS_LINHA
        ultima = (i == len(words) - 1)

        if (fim_frase and len(atual) >= 2) or limite or ultima:
            grupos.append(atual)
            atual = []

    if atual:
        grupos.append(atual)

    return grupos

def gerar_ass(words: list, output_path: str, res_x: int = 1080, res_y: int = 1920):
    tamanho_fonte = max(22, int(res_x * 0.040))
    margem_v = int(res_y * MARGEM_V_RATIO)

    linhas_ass = []
    linhas_ass.append("[Script Info]")
    linhas_ass.append("ScriptType: v4.00+")
    linhas_ass.append(f"PlayResX: {res_x}")
    linhas_ass.append(f"PlayResY: {res_y}")
    linhas_ass.append("WrapStyle: 0")
    linhas_ass.append("ScaledBorderAndShadow: yes")
    linhas_ass.append("")
    linhas_ass.append("[V4+ Styles]")
    linhas_ass.append(
        "Format: Name, Fontname, Fontsize, PrimaryColour, SecondaryColour, OutlineColour, BackColour, "
        "Bold, Italic, Underline, StrikeOut, ScaleX, ScaleY, Spacing, Angle, BorderStyle, Outline, "
        "Shadow, Alignment, MarginL, MarginR, MarginV, Encoding"
    )
    # PrimaryColour = branco (texto ainda não falado)
    # SecondaryColour = amarelo (texto sendo falado — o fill avança sobre ele)
    linhas_ass.append(
        f"Style: Karaoke,{FONTE},{tamanho_fonte},"
        f"&H00FFFFFF,&H0000FFFF,&H00000000,&HAA000000,"
        f"-1,0,0,0,100,100,0.5,0,1,{BORDA},{SOMBRA},2,30,30,{margem_v},1"
    )
    linhas_ass.append("")
    linhas_ass.append("[Events]")
    linhas_ass.append(
        "Format: Layer, Start, End, Style, Name, MarginL, MarginR, MarginV, Effect, Text"
    )

    grupos = agrupar_por_frase(words)

    for grupo in grupos:
        t_inicio = grupo[0]['start']
        t_fim = grupo[-1]['end']

        partes = []
        for w in grupo:
            duracao_cs = max(1, int(round((w['end'] - w['start']) * 100)))
            palavra = limpar_palavra(w['word'])
            # \kf = karaoke fill progressivo (preenche da esquerda para direita)
            partes.append(f"{{\\kf{duracao_cs}}}{palavra} ")

        texto = "".join(partes).rstrip()

        linhas_ass.append(
            f"Dialogue: 0,"
            f"{segundos_para_ass(t_inicio)},"
            f"{segundos_para_ass(t_fim)},"
            f"Karaoke,,0,0,0,,"
            f"{texto}"
        )

    with open(output_path, 'w', encoding='utf-8') as f:
        f.write("\n".join(linhas_ass) + "\n")

    print(f"[gerar_karaoke_preciso] ASS gerado: {output_path} ({len(grupos)} linhas, \\kf fill progressivo)")

def main():
    if len(sys.argv) < 3:
        print(f"Uso: {sys.argv[0]} <words.json> <output.ass> [res_x] [res_y]")
        sys.exit(1)

    json_path = sys.argv[1]
    ass_path = sys.argv[2]
    res_x = int(sys.argv[3]) if len(sys.argv) > 3 else 1080
    res_y = int(sys.argv[4]) if len(sys.argv) > 4 else 1920

    with open(json_path, 'r', encoding='utf-8') as f:
        data = json.load(f)

    words = data.get('words', [])
    if not words:
        print("Erro: JSON sem campo 'words'")
        sys.exit(1)

    gerar_ass(words, ass_path, res_x, res_y)

if __name__ == '__main__':
    main()
