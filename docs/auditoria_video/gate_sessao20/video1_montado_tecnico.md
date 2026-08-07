# Gate técnico audiovisual

| Campo | Valor |
|---|---|
| Arquivo | `/home/ubuntu/Moviemoney/skill-movie-money/criativos/video_institucional_youtube/video1_quebra_mitos_MONTADO.mp4` |
| SHA-256 | `777271a74b51e4a29078d6f39ff43a5441f2bf30014fd3f259c60493e83a8520` |
| Perfil | `youtube` |
| Duração | 87.500 s |
| Veredito técnico | **TECHNICALLY_REJECTED** |

| Critério | Status | Valor | Limite |
|---|---|---:|---:|
| integridade_decodificacao | **PASS** | 0 | 0 |
| resolucao | **PASS** | 2560x1440 | >=1280x720 |
| aspect_ratio | **PASS** | 1.7778 | 16:9 ±0,01 |
| fps | **PASS** | 30.000 | 24–60 fps |
| sample_rate | **PASS** | 48000 Hz | 48000 Hz |
| drift_duracao | **FAIL** | 7.453 s | <= 0.050 s |
| delta_inicio | **PASS** | 0.000 s | <= 0.020 s |
| cauda_silenciosa | **FAIL** | 7.453 s | <= 0.200 s |
| loudness_integrado | **FAIL** | -19.0 LUFS | -16.0 ± 1.0 LUFS |
| true_peak | **FAIL** | -0.9 dBTP | <= -1.0 dBTP |
| freeze_nao_intencional | **FAIL** | 12.533 s | <= 0.500 s |
| black_frame | **PASS** | 0.000 s | <= 0.200 s |

> Este gate não avalia realismo, lip sync perceptual, fidelidade do produto, narração ou compliance. A entrega só pode ocorrer após o certificado perceptual obrigatório.
