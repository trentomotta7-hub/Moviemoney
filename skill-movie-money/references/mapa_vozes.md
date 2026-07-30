# Mapa de Vozes Oficiais — Movie Money

Cada personagem tem uma voz fixa do catálogo TTS + instruções de estilo padrão. Todo áudio futuro DEVE usar esta combinação exata para garantir consistência entre sessões.

| Personagem | Voz | Justificativa | Instrução de estilo padrão (inglês, antes dos dois-pontos) |
|------------|-----|---------------|------------------------------------------------------------|
| **Beto** (rosto da marca) | **Fenrir** (masc., excitável) | Alta energia, assertivo, pitch de vendas | "You are a confident, high-energy Brazilian digital entrepreneur delivering a direct sales pitch to camera. Speak in Brazilian Portuguese with an assertive, fast-paced, persuasive tone, informal street-smart delivery" |
| **Lucas Ferreira** (27, tech) | **Zubenelgenubi** (masc., casual) | O amigo casual mandando áudio | "You are a young Brazilian guy excitedly telling his best friend about a product he just discovered, like a casual voice message. Speak in Brazilian Portuguese, informal, medium-fast pace, rising excitement" |
| **Marina Costa** (24, beleza) | **Leda** (fem., jovem) | Jovem, íntima, "conversa entre amigas" | "You are a young Brazilian woman sharing a skincare secret with her close friends, warm and intimate like a confession. Speak in Brazilian Portuguese, cozy tone, slower on confessions, excited on reveals" |
| **Rafael Santos** (32, fitness) | **Alnilam** (masc., firme) | Grave, pausado, autoridade calma | "You are a calm, authoritative Brazilian fitness expert giving an honest product analysis. Speak in Brazilian Portuguese with a deep, measured, confident tone, short assertive sentences, unhurried" |
| **Beatriz Oliveira** (29, produtividade) | **Erinome** (fem., clara) | Articulada, objetiva, profissional | "You are a sharp, articulate Brazilian professional woman recommending a product she thoroughly tested. Speak in Brazilian Portuguese, clear and objective, warm but efficient, data-driven confidence" |
| **Diego Almeida** (22, virais) | **Sadachbia** (masc., vivaz) | Rápido, reativo, expressivo Gen Z | "You are an expressive Brazilian Gen Z content creator reacting genuinely to a surprising product. Speak in Brazilian Portuguese, fast and reactive with big dynamic variation, whispers to exclamations, authentic unscripted energy" |

**Regras:** `language_code` sempre `pt-BR`. Amostras oficiais salvas em `templates/vozes/{nome}.wav`. Texto da amostra = hook-assinatura + 2 frases no estilo do personagem.
