# Gate técnico audiovisual

| Campo | Valor |
|---|---|
| Arquivo | `/home/ubuntu/Moviemoney/skill-movie-money/criativos/sunscreen_stick_spf/POV/montagem/video_normalizado.mp4` |
| SHA-256 | `4d3d30c8b5789285dfb8fd8457838d44b5197057a32d54100a3da283bbeb8d6f` |
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
