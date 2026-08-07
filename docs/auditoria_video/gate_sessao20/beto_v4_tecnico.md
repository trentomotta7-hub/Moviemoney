# Gate técnico audiovisual

| Campo | Valor |
|---|---|
| Arquivo | `/home/ubuntu/Moviemoney/skill-movie-money/templates/videos/beto_institucional_v4.mp4` |
| SHA-256 | `2bfb903417421024481d2e9b033fcc8b0f4447c5000e1c0cc7fc09bac820b493` |
| Perfil | `youtube` |
| Duração | 26.500 s |
| Veredito técnico | **TECHNICALLY_REJECTED** |

| Critério | Status | Valor | Limite |
|---|---|---:|---:|
| integridade_decodificacao | **PASS** | 0 | 0 |
| resolucao | **FAIL** | 1080x1920 | >=1280x720 |
| aspect_ratio | **FAIL** | 0.5625 | 16:9 ±0,01 |
| fps | **PASS** | 30.000 | 24–60 fps |
| sample_rate | **PASS** | 48000 Hz | 48000 Hz |
| drift_duracao | **PASS** | 0.001 s | <= 0.050 s |
| delta_inicio | **PASS** | 0.000 s | <= 0.020 s |
| cauda_silenciosa | **FAIL** | 0.394 s | <= 0.200 s |
| loudness_integrado | **FAIL** | -20.1 LUFS | -16.0 ± 1.0 LUFS |
| true_peak | **PASS** | -3.8 dBTP | <= -1.0 dBTP |
| freeze_nao_intencional | **PASS** | 0.000 s | <= 0.500 s |
| black_frame | **PASS** | 0.000 s | <= 0.200 s |

> Este gate não avalia realismo, lip sync perceptual, fidelidade do produto, narração ou compliance. A entrega só pode ocorrer após o certificado perceptual obrigatório.
