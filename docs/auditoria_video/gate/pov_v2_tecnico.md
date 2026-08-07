# Gate técnico audiovisual

| Campo | Valor |
|---|---|
| Arquivo | `/home/ubuntu/Moviemoney/auditoria_video/masters/sunscreen_pov_v2.mp4` |
| SHA-256 | `de1474c8826d09001d6f1d761a0bf135e202e952695bf1807b52086d207b4e75` |
| Perfil | `short` |
| Duração | 29.000 s |
| Veredito técnico | **TECHNICALLY_REJECTED** |

| Critério | Status | Valor | Limite |
|---|---|---:|---:|
| integridade_decodificacao | **PASS** | 0 | 0 |
| resolucao | **PASS** | 720x1280 | >=720x1280 |
| aspect_ratio | **PASS** | 0.5625 | 9:16 ±0,01 |
| fps | **PASS** | 30.000 | 24–60 fps |
| sample_rate | **FAIL** | 96000 Hz | 48000 Hz |
| drift_duracao | **PASS** | 0.000 s | <= 0.050 s |
| delta_inicio | **PASS** | 0.000 s | <= 0.020 s |
| cauda_silenciosa | **PASS** | 0.147 s | <= 0.200 s |
| loudness_integrado | **PASS** | -16.7 LUFS | -16.0 ± 1.0 LUFS |
| true_peak | **PASS** | -1.3 dBTP | <= -1.0 dBTP |
| freeze_nao_intencional | **PASS** | 0.000 s | <= 0.500 s |
| black_frame | **PASS** | 0.000 s | <= 0.200 s |

> Este gate não avalia realismo, lip sync perceptual, fidelidade do produto, narração ou compliance. A entrega só pode ocorrer após o certificado perceptual obrigatório.
