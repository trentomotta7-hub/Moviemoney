#!/usr/bin/env python3
"""
gerar_karaoke_preciso.py — Gera arquivo ASS com karaokê palavra a palavra
Uso: python3 gerar_karaoke_preciso.py <words.json> <output.ass>

Formato do JSON de entrada:
{
  "words": [
    {"word": "Mano,", "start": 0.4, "end": 0.8},
    ...
  ]
}

Comportamento:
- Agrupa palavras em linhas de até MAX_PALAVRAS_LINHA palavras
- Cada linha aparece na tela durante toda a sua duração
- As palavras ficam AMARELAS conforme são faladas (karaokê real)
- Palavras ainda não faladas ficam BRANCAS
- Palavras já faladas ficam CINZA CLARO
- Fonte pequena, canto inferior da tela
"""

import sys
import json
import re

MAX_PALAVRAS_LINHA = 6   # máximo de palavras por linha de legenda
FONTE = "Arial"
TAMANHO = 20
COR_FALANDO = "&H0000FFFF"   # amarelo (BGR: 00 FF FF → R=FF G=FF B=00 → amarelo)
COR_PENDENTE = "&H00FFFFFF"  # branco
COR_FALADO   = "&H00CCCCCC"  # cinza claro
BORDA = 2.5
SOMBRA = 1.0
MARGEM_V = 60  # pixels do fundo

def segundos_para_ass(s: float) -> str:
    """Converte segundos para formato ASS: H:MM:SS.cc"""
    h = int(s // 3600)
    m = int((s % 3600) // 60)
    sec = s % 60
    cs = int((sec % 1) * 100)
    return f"{h}:{m:02d}:{int(sec):02d}.{cs:02d}"

def limpar_palavra(w: str) -> str:
    """Remove pontuação para exibição limpa."""
    return re.sub(r'[.,!?;:]$', '', w)

def gerar_ass(words: list, output_path: str):
    linhas_ass = []

    # Cabeçalho ASS
    linhas_ass.append("[Script Info]")
    linhas_ass.append("ScriptType: v4.00+")
    linhas_ass.append("PlayResX: 1080")
    linhas_ass.append("PlayResY: 1920")
    linhas_ass.append("WrapStyle: 0")
    linhas_ass.append("")
    linhas_ass.append("[V4+ Styles]")
    linhas_ass.append(
        f"Format: Name, Fontname, Fontsize, PrimaryColour, SecondaryColour, OutlineColour, BackColour, "
        f"Bold, Italic, Underline, StrikeOut, ScaleX, ScaleY, Spacing, Angle, BorderStyle, Outline, "
        f"Shadow, Alignment, MarginL, MarginR, MarginV, Encoding"
    )
    linhas_ass.append(
        f"Style: Karaoke,{FONTE},{TAMANHO},{COR_PENDENTE},{COR_FALANDO},&H00000000,&H80000000,"
        f"-1,0,0,0,100,100,0,0,1,{BORDA},{SOMBRA},2,20,20,{MARGEM_V},1"
    )
    linhas_ass.append("")
    linhas_ass.append("[Events]")
    linhas_ass.append(
        "Format: Layer, Start, End, Style, Name, MarginL, MarginR, MarginV, Effect, Text"
    )

    # Agrupar palavras em linhas de até MAX_PALAVRAS_LINHA
    grupos = []
    i = 0
    while i < len(words):
        grupo = words[i:i + MAX_PALAVRAS_LINHA]
        grupos.append(grupo)
        i += MAX_PALAVRAS_LINHA

    for grupo in grupos:
        t_inicio = grupo[0]['start']
        t_fim = grupo[-1]['end']

        # Construir texto karaokê com tags \k (duração em centissegundos)
        partes = []
        for w in grupo:
            duracao_cs = max(1, int(round((w['end'] - w['start']) * 100)))
            palavra_limpa = limpar_palavra(w['word'])
            partes.append(f"{{\\k{duracao_cs}}}{palavra_limpa} ")

        texto_karaoke = "".join(partes).rstrip()

        linha = (
            f"Dialogue: 0,"
            f"{segundos_para_ass(t_inicio)},"
            f"{segundos_para_ass(t_fim)},"
            f"Karaoke,,0,0,0,,"
            f"{texto_karaoke}"
        )
        linhas_ass.append(linha)

    with open(output_path, 'w', encoding='utf-8') as f:
        f.write("\n".join(linhas_ass) + "\n")

    print(f"[gerar_karaoke_preciso] ASS gerado: {output_path} ({len(grupos)} linhas)")

def main():
    if len(sys.argv) < 3:
        print(f"Uso: {sys.argv[0]} <words.json> <output.ass>")
        sys.exit(1)

    with open(sys.argv[1], 'r', encoding='utf-8') as f:
        data = json.load(f)

    words = data.get('words', [])
    if not words:
        print("Erro: JSON sem campo 'words'")
        sys.exit(1)

    gerar_ass(words, sys.argv[2])

if __name__ == '__main__':
    main()
