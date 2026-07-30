#!/usr/bin/env python3
"""
Gera arquivo ASS de legendas estilo karaokê para o vídeo do Beto.
As palavras ficam amarelas conforme são faladas (karaokê progressivo).
"""

import json
import re

# Segmentos com timestamps reais da transcrição
segments = [
    {"start": 0.62,  "end": 2.10,  "text": "Mano, eu vou ser direto com você."},
    {"start": 2.10,  "end": 7.70,  "text": "A maioria das pessoas que tenta vender no TikTok Shop erra no mesmo lugar: o criativo."},
    {"start": 7.70,  "end": 9.80,  "text": "Não é o produto, não é o preço, é o vídeo."},
    {"start": 9.80,  "end": 14.10, "text": "E os gurus da internet não vão te contar isso, porque eles ganham dinheiro vendendo curso de como ganhar dinheiro."},
    {"start": 14.10, "end": 16.10, "text": "É exatamente isso que a Movie Money resolve."},
    {"start": 16.10, "end": 22.10, "text": "A gente pega o seu produto e transforma em criativo que para a rolagem nos quatro primeiros segundos, sem você aparecer, sem filmar nada, sem contratar ninguém."},
    {"start": 22.10, "end": 25.10, "text": "Vem pra Movie Money, dê brilho no seu caminho."},
    {"start": 25.10, "end": 26.70, "text": "Bora vender?"},
]

def ts_to_ass(seconds):
    """Converte segundos para formato ASS: H:MM:SS.cc"""
    h = int(seconds // 3600)
    m = int((seconds % 3600) // 60)
    s = seconds % 60
    cs = int((s - int(s)) * 100)
    return f"{h}:{m:02d}:{int(s):02d}.{cs:02d}"

def split_into_chunks(text, max_words=5):
    """Divide o texto em chunks de até max_words palavras."""
    words = text.split()
    chunks = []
    for i in range(0, len(words), max_words):
        chunks.append(words[i:i+max_words])
    return chunks

# Cabeçalho ASS
ass_header = """[Script Info]
ScriptType: v4.00+
PlayResX: 720
PlayResY: 1280
ScaledBorderAndShadow: yes

[V4+ Styles]
Format: Name, Fontname, Fontsize, PrimaryColour, SecondaryColour, OutlineColour, BackColour, Bold, Italic, Underline, StrikeOut, ScaleX, ScaleY, Spacing, Angle, BorderStyle, Outline, Shadow, Alignment, MarginL, MarginR, MarginV, Encoding
Style: Karaoke,Arial,22,&H00FFFFFF,&H0000FFFF,&H00000000,&H80000000,1,0,0,0,100,100,0,0,1,2,1,2,20,20,80,1

[Events]
Format: Layer, Start, End, Style, Name, MarginL, MarginR, MarginV, Effect, Text
"""

# Gera os eventos de karaokê
events = []

for seg in segments:
    seg_start = seg["start"]
    seg_end = seg["end"]
    seg_duration = seg_end - seg_start
    text = re.sub(r'[,.:!?]', '', seg["text"])
    words = text.split()
    
    if not words:
        continue
    
    # Divide em linhas de até 5 palavras
    chunks = split_into_chunks(text, max_words=5)
    n_chunks = len(chunks)
    chunk_duration = seg_duration / n_chunks
    
    for ci, chunk_words in enumerate(chunks):
        chunk_start = seg_start + ci * chunk_duration
        chunk_end = chunk_start + chunk_duration
        n_words = len(chunk_words)
        word_duration = chunk_duration / n_words  # duração por palavra em segundos
        word_duration_cs = int(word_duration * 100)  # em centissegundos para ASS \k
        
        # Monta a linha karaokê: palavras ficam amarelas (\k) conforme o tempo passa
        # \k<cs> = karaokê, cada palavra fica amarela por <cs> centissegundos
        karaoke_line = ""
        for word in chunk_words:
            karaoke_line += f"{{\\k{word_duration_cs}}}{word} "
        karaoke_line = karaoke_line.strip()
        
        start_str = ts_to_ass(chunk_start)
        end_str = ts_to_ass(chunk_end)
        
        events.append(f"Dialogue: 0,{start_str},{end_str},Karaoke,,0,0,0,,{karaoke_line}")

# Escreve o arquivo ASS
output_path = "/home/ubuntu/skills/movie-money/templates/videos/beto_karaoke.ass"
with open(output_path, "w", encoding="utf-8") as f:
    f.write(ass_header)
    for event in events:
        f.write(event + "\n")

print(f"Arquivo ASS gerado: {output_path}")
print(f"Total de linhas de diálogo: {len(events)}")
