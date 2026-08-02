#!/usr/bin/env python3
"""
Gera os VOs CORRETOS para os Screen Recordings do Vídeo 2.
Textos extraídos diretamente do plano de takes (video2_plano_takes.md).
Cada VO é exclusivo para o seu SC — sem sobreposição com o áudio do Beto.
"""

from gtts import gTTS
import subprocess
import os

VO_DIR = "/home/ubuntu/Moviemoney/skill-movie-money/criativos/video_institucional_youtube/takes_v2_vos"
os.makedirs(VO_DIR, exist_ok=True)

# Textos EXATOS do plano de takes (video2_plano_takes.md)
VOS = [
    {
        "id": "vo_sc1",
        "texto": (
            "O TikTok não quer que o usuário saia do app. "
            "Se o seu vídeo grita anúncio falso, o usuário rola a tela em dois segundos. "
            "Retenção zero. CPM nas alturas."
        )
    },
    {
        "id": "vo_sc2",
        "texto": (
            "Isso aqui não é uma pastinha no Google Drive. "
            "É uma infraestrutura de engenharia. "
            "A gente mapeou tudo. "
            "Dá uma olhada nessa pasta aqui: Templates de Personagens."
        )
    },
    {
        "id": "vo_sc3",
        "texto": (
            "Esses cinco rostos cobrem noventa por cento dos nichos lucrativos. "
            "O Lucas pra tech. A Marina pra beleza. O Rafael pra fitness. "
            "A Beatriz pra produtividade. E o Diego pra produtos virais. "
            "Eles não são atores de banco de imagens. São personas consistentes."
        )
    },
    {
        "id": "vo_sc4",
        "texto": (
            "Ter um rosto bonito não serve de nada se o roteiro for fraco. "
            "O cérebro humano compra por emoção e justifica pela lógica. "
            "É por isso que a gente criou o Banco Narrativo."
        )
    },
    {
        "id": "vo_sc5",
        "texto": (
            "A gente analisou mais de trinta e quatro mil vídeos no TikTok. "
            "Nós mapeamos setenta dores reais do mercado brasileiro. "
            "A gente não inventa que o perfume tem notas amadeiradas. "
            "Ninguém liga pra isso."
        )
    },
    {
        "id": "vo_sc6",
        "texto": (
            "A gente escreve: Passei esse body splash de manhã e minha amiga "
            "perguntou o que eu tava usando às dez da noite. "
            "É assim que a gente estrutura o funil de atenção: "
            "Hook nos primeiros quatro segundos. Agitação. Causa. Solução. CTA."
        )
    },
    {
        "id": "vo_sc7",
        "texto": (
            "A esquerda é o que os gurus te ensinam a fazer. "
            "O lábio mexe, mas não forma as palavras. "
            "O cérebro do cliente detecta isso em milissegundos e aciona o alerta de golpe. "
            "A direita é a Movie Money. Sincronia labial perfeita. "
            "O prompt de geração recebe a fala exata. É indetectável."
        )
    },
    {
        "id": "vo_sc8",
        "texto": (
            "E não para por aí. Legendas. "
            "A gente queima as legendas em amarelo e branco no estilo karaokê. "
            "Mas repara na posição. "
            "A gente eleva as legendas trezentos e vinte pixels acima da borda inferior. "
            "Pra não ficar escondida atrás daquele carrinho laranja do TikTok Shop."
        )
    },
]

def gerar_vo(vo_id, texto):
    mp3_tmp = f"/tmp/{vo_id}.mp3"
    wav_out = os.path.join(VO_DIR, f"{vo_id}.wav")

    tts = gTTS(text=texto, lang="pt", tld="com.br", slow=False)
    tts.save(mp3_tmp)

    cmd = [
        "ffmpeg", "-y", "-i", mp3_tmp,
        "-ar", "48000", "-ac", "1",
        "-acodec", "pcm_s16le",
        wav_out
    ]
    subprocess.run(cmd, capture_output=True)
    os.remove(mp3_tmp)

    dur = subprocess.run(
        ["ffprobe", "-v", "quiet", "-show_entries", "format=duration",
         "-of", "csv=p=0", wav_out],
        capture_output=True, text=True
    ).stdout.strip()

    print(f"  ✓ {vo_id}.wav  ({float(dur):.1f}s)")
    return wav_out

if __name__ == "__main__":
    print("🎙️  Gerando VOs corretos para o Vídeo 2")
    print("=" * 55)
    for vo in VOS:
        gerar_vo(vo["id"], vo["texto"])
    print("=" * 55)
    print(f"✅  {len(VOS)} VOs gerados em: {VO_DIR}")
