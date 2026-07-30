#!/usr/bin/env python3
"""
transcrever_palavras.py — Transcreve áudio e gera word timestamps precisos
Uso: python3 transcrever_palavras.py <audio_ou_video> <output.json>

Estratégia: usa Whisper via OpenAI API com verbose_json para obter
timestamps por segmento, depois distribui o tempo de cada segmento
proporcionalmente ao número de caracteres de cada palavra.
Isso é muito mais preciso que divisão igual (método anterior).
"""

import sys
import json
import re
import os
import subprocess
import openai

def extrair_audio(input_path: str) -> str:
    """Extrai áudio de vídeo MP4 para WAV temporário."""
    if input_path.endswith('.wav'):
        return input_path
    wav_path = input_path.replace('.mp4', '_audio_tmp.wav')
    subprocess.run([
        'ffmpeg', '-y', '-i', input_path,
        '-vn', '-acodec', 'pcm_s16le', '-ar', '16000', '-ac', '1',
        wav_path
    ], check=True, capture_output=True)
    return wav_path

def transcrever_segmentos(audio_path: str) -> list:
    """Transcreve com Whisper e retorna segmentos com timestamps."""
    client = openai.OpenAI()
    with open(audio_path, 'rb') as f:
        result = client.audio.transcriptions.create(
            model='whisper-1',
            file=f,
            response_format='verbose_json',
            timestamp_granularities=['segment'],
            language='pt'
        )
    return result.segments

def segmentos_para_palavras(segmentos: list) -> list:
    """
    Converte segmentos em palavras com timestamps proporcionais por caractere.
    Muito mais preciso que divisão igual — respeita o peso natural de cada palavra.
    """
    palavras = []
    for seg in segmentos:
        texto = seg.text.strip()
        t_inicio = seg.start
        t_fim = seg.end
        duracao = t_fim - t_inicio

        # Tokenizar: preservar pontuação junto à palavra anterior
        tokens = re.findall(r"[\w']+[.,!?;:]*|[.,!?;:]", texto)
        tokens = [t for t in tokens if t.strip()]

        if not tokens:
            continue

        # Calcular peso de cada token pelo número de caracteres (sem pontuação)
        pesos = [len(re.sub(r'[^\w]', '', t)) or 1 for t in tokens]
        total = sum(pesos)

        t_atual = t_inicio
        for token, peso in zip(tokens, pesos):
            duracao_token = duracao * (peso / total)
            palavras.append({
                'word': token,
                'start': round(t_atual, 3),
                'end': round(t_atual + duracao_token, 3)
            })
            t_atual += duracao_token

    return palavras

def main():
    if len(sys.argv) < 3:
        print(f"Uso: {sys.argv[0]} <audio_ou_video> <output.json>")
        sys.exit(1)

    input_path = sys.argv[1]
    output_json = sys.argv[2]

    print(f"[transcrever_palavras] Entrada: {input_path}")

    # Extrair áudio se necessário
    audio_path = extrair_audio(input_path)
    tmp_criado = audio_path != input_path

    try:
        # Transcrever
        print("[transcrever_palavras] Transcrevendo com Whisper...")
        segmentos = transcrever_segmentos(audio_path)
        print(f"[transcrever_palavras] {len(segmentos)} segmentos obtidos")

        # Converter para palavras com timestamps proporcionais
        palavras = segmentos_para_palavras(segmentos)
        print(f"[transcrever_palavras] {len(palavras)} palavras com timestamps")

        # Salvar JSON
        with open(output_json, 'w', encoding='utf-8') as f:
            json.dump({'words': palavras}, f, ensure_ascii=False, indent=2)
        print(f"[transcrever_palavras] Salvo: {output_json}")

    finally:
        if tmp_criado and os.path.exists(audio_path):
            os.remove(audio_path)

if __name__ == '__main__':
    main()
