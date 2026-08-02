#!/usr/bin/env python3
"""
Gerador dos VOs faltantes para o Vídeo 2: "A Máquina por Dentro"
Gera: vo_sc5_v2.wav, vo_sc6_v2.wav, vo_sc8_v2.wav
Usa gTTS (pt-BR) como substituto da voz Fenrir
"""

from gtts import gTTS
import subprocess
import os

TAKES_DIR = "/home/ubuntu/Moviemoney/skill-movie-money/criativos/video_institucional_youtube/takes"
os.makedirs(TAKES_DIR, exist_ok=True)

# Textos dos VOs faltantes conforme o plano de takes
vos = {
    "vo_sc5_v2": {
        "texto": (
            "A gente analisou mais de trinta e quatro mil vídeos no TikTok. "
            "Nós mapeamos setenta dores reais do mercado brasileiro. "
            "A gente não inventa que o perfume tem notas amadeiradas. "
            "Ninguém liga pra isso."
        ),
        "duracao_esperada": "~12s"
    },
    "vo_sc6_v2": {
        "texto": (
            "A gente escreve: Passei esse body splash de manhã e minha amiga "
            "perguntou o que eu tava usando às dez da noite. "
            "É assim que a gente estrutura o funil de atenção: "
            "Hook nos primeiros quatro segundos. Agitação. Causa. Solução. CTA."
        ),
        "duracao_esperada": "~14s"
    },
    "vo_sc8_v2": {
        "texto": (
            "E não para por aí. Legendas. A gente queima as legendas em amarelo e branco "
            "no estilo karaokê. Mas repara na posição. "
            "A gente eleva as legendas trezentos e vinte pixels acima da borda inferior. "
            "Pra não ficar escondida atrás daquele carrinho laranja do TikTok Shop."
        ),
        "duracao_esperada": "~14s"
    }
}

def gerar_vo(nome, texto, duracao_esperada):
    """Gera um VO em pt-BR e converte para WAV 48kHz mono."""
    print(f"\n[{nome}] Gerando VO ({duracao_esperada})...")
    print(f"  Texto: {texto[:60]}...")

    # Gerar MP3 com gTTS
    mp3_path = f"/tmp/{nome}.mp3"
    wav_path = os.path.join(TAKES_DIR, f"{nome}.wav")

    tts = gTTS(text=texto, lang="pt", tld="com.br", slow=False)
    tts.save(mp3_path)
    print(f"  ✓ MP3 gerado: {mp3_path}")

    # Converter para WAV 48kHz mono (padrão do projeto)
    cmd = [
        "ffmpeg", "-y",
        "-i", mp3_path,
        "-ar", "48000",
        "-ac", "1",
        "-acodec", "pcm_s16le",
        wav_path
    ]
    result = subprocess.run(cmd, capture_output=True, text=True)
    if result.returncode != 0:
        print(f"  ✗ Erro na conversão: {result.stderr[-200:]}")
        return None

    # Verificar duração
    dur_cmd = ["ffprobe", "-v", "quiet", "-show_entries", "format=duration",
               "-of", "csv=p=0", wav_path]
    dur_result = subprocess.run(dur_cmd, capture_output=True, text=True)
    duracao = float(dur_result.stdout.strip()) if dur_result.stdout.strip() else 0

    print(f"  ✓ WAV gerado: {wav_path}")
    print(f"  ✓ Duração: {duracao:.1f}s (esperado: {duracao_esperada})")

    # Limpar MP3 temporário
    os.remove(mp3_path)
    return wav_path

if __name__ == "__main__":
    print("🎙️  Gerando VOs faltantes para o Vídeo 2")
    print("=" * 60)
    print("Voz: gTTS pt-BR (substituto Fenrir)")
    print("Formato: WAV 48kHz mono PCM")
    print("=" * 60)

    gerados = []
    for nome, info in vos.items():
        resultado = gerar_vo(nome, info["texto"], info["duracao_esperada"])
        if resultado:
            gerados.append(resultado)

    print("\n" + "=" * 60)
    print(f"✅  {len(gerados)}/{len(vos)} VOs gerados com sucesso!")
    for path in gerados:
        print(f"   📄 {os.path.basename(path)}")
    print("=" * 60)
