# Gate técnico audiovisual

| Campo | Valor |
|---|---|
| Arquivo | `/home/ubuntu/Moviemoney/skill-movie-money/templates/videos/beto_institucional_final.mp4` |
| SHA-256 | `20dbc8fa3a2356e90e3cf2563d01ea09248e2d2d965c32099874777d3e5d2fbc` |
| Perfil | `youtube` |
| Duração | 27.049 s |
| Veredito técnico | **TECHNICALLY_REJECTED** |

| Critério | Status | Valor | Limite |
|---|---|---:|---:|
| integridade_decodificacao | **PASS** | 0 | 0 |
| resolucao | **FAIL** | 720x1280 | >=1280x720 |
| aspect_ratio | **FAIL** | 0.5625 | 16:9 ±0,01 |
| fps | **PASS** | 24.000 | 24–60 fps |
| sample_rate | **PASS** | 48000 Hz | 48000 Hz |
| drift_duracao | **PASS** | 0.008 s | <= 0.050 s |
| delta_inicio | **PASS** | 0.000 s | <= 0.020 s |
| cauda_silenciosa | **FAIL** | 0.871 s | <= 0.200 s |
| loudness_integrado | **FAIL** | -19.1 LUFS | -16.0 ± 1.0 LUFS |
| true_peak | **PASS** | -3.4 dBTP | <= -1.0 dBTP |
| freeze_nao_intencional | **PASS** | 0.000 s | <= 0.500 s |
| black_frame | **PASS** | 0.000 s | <= 0.200 s |

> Este gate não avalia realismo, lip sync perceptual, fidelidade do produto, narração ou compliance. A entrega só pode ocorrer após o certificado perceptual obrigatório.
