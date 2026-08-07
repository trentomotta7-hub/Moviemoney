"""Gate técnico obrigatório para masters Movie Money.

O script mede integridade, formato, drift, silêncio terminal, loudness,
black frames e congelamentos. Ele nunca aprova realismo, lip sync, produto
ou compliance; esses critérios exigem o certificado perceptual separado.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import math
import re
import subprocess
import sys
from dataclasses import dataclass, asdict
from pathlib import Path


@dataclass
class Check:
    name: str
    status: str
    value: str
    limit: str
    detail: str = ""


def run(args: list[str]) -> subprocess.CompletedProcess[str]:
    return subprocess.run(args, capture_output=True, text=True, shell=False)


def ffprobe(video: Path) -> dict:
    result = run(
        [
            "ffprobe",
            "-v",
            "error",
            "-print_format",
            "json",
            "-show_format",
            "-show_streams",
            str(video),
        ]
    )
    if result.returncode != 0:
        raise RuntimeError(result.stderr.strip() or "ffprobe falhou")
    return json.loads(result.stdout)


def parse_rate(value: str) -> float:
    if not value or value == "0/0":
        return 0.0
    if "/" in value:
        numerator, denominator = value.split("/", 1)
        return float(numerator) / float(denominator)
    return float(value)


def duration(stream: dict, fallback: float) -> float:
    raw = stream.get("duration")
    if raw not in (None, "N/A"):
        return float(raw)
    return fallback


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def detect_silence(video: Path, video_duration: float, audio_duration: float) -> tuple[float, str]:
    result = run(
        [
            "ffmpeg",
            "-hide_banner",
            "-nostats",
            "-i",
            str(video),
            "-af",
            "silencedetect=noise=-35dB:d=0.10",
            "-f",
            "null",
            "-",
        ]
    )
    output = result.stderr
    events: list[tuple[str, float]] = []
    pattern = re.compile(r"silence_(start|end):\s*([0-9.]+)")
    for kind, value in pattern.findall(output):
        events.append((kind, float(value)))

    trailing = max(0.0, video_duration - audio_duration)
    last_start = None
    last_end = None
    for kind, value in events:
        if kind == "start":
            last_start = value
        else:
            last_end = value

    if last_start is not None:
        if last_end is None or last_start > last_end:
            trailing = max(trailing, video_duration - last_start)
        elif last_end >= audio_duration - 0.05:
            trailing = max(trailing, video_duration - last_start)

    return trailing, output


def detect_loudness(video: Path) -> tuple[float | None, float | None, float | None, str]:
    result = run(
        [
            "ffmpeg",
            "-hide_banner",
            "-nostats",
            "-i",
            str(video),
            "-af",
            "loudnorm=I=-16:TP=-1.5:LRA=11:print_format=summary",
            "-f",
            "null",
            "-",
        ]
    )
    output = result.stderr

    def value(label: str) -> float | None:
        match = re.search(rf"{re.escape(label)}:\s*([-0-9.]+)", output)
        return float(match.group(1)) if match else None

    return value("Input Integrated"), value("Input True Peak"), value("Input LRA"), output


def detect_visual_stalls(video: Path) -> tuple[float, float, str]:
    result = run(
        [
            "ffmpeg",
            "-hide_banner",
            "-nostats",
            "-i",
            str(video),
            "-vf",
            "blackdetect=d=0.10:pix_th=0.10,freezedetect=n=-50dB:d=0.50",
            "-an",
            "-f",
            "null",
            "-",
        ]
    )
    output = result.stderr
    freezes = [float(item) for item in re.findall(r"freeze_duration:\s*([0-9.]+)", output)]
    blacks = [float(item) for item in re.findall(r"black_duration:([0-9.]+)", output)]
    return max(freezes, default=0.0), max(blacks, default=0.0), output


def add(checks: list[Check], name: str, passed: bool, value: str, limit: str, detail: str = "") -> None:
    checks.append(Check(name, "PASS" if passed else "FAIL", value, limit, detail))


def build_report(args: argparse.Namespace) -> tuple[dict, int]:
    video = args.video.resolve()
    if not video.exists() or not video.is_file():
        raise RuntimeError(f"Vídeo inexistente: {video}")

    metadata = ffprobe(video)
    format_data = metadata.get("format", {})
    streams = metadata.get("streams", [])
    video_stream = next((item for item in streams if item.get("codec_type") == "video"), None)
    audio_stream = next((item for item in streams if item.get("codec_type") == "audio"), None)
    if not video_stream or not audio_stream:
        raise RuntimeError("O master precisa conter streams de vídeo e áudio.")

    format_duration = float(format_data.get("duration", 0.0))
    video_duration = duration(video_stream, format_duration)
    audio_duration = duration(audio_stream, format_duration)
    drift = abs(video_duration - audio_duration)
    start_delta = abs(float(video_stream.get("start_time", 0.0)) - float(audio_stream.get("start_time", 0.0)))
    width = int(video_stream.get("width", 0))
    height = int(video_stream.get("height", 0))
    fps = parse_rate(video_stream.get("avg_frame_rate") or video_stream.get("r_frame_rate", "0/0"))
    sample_rate = int(audio_stream.get("sample_rate", 0))

    checks: list[Check] = []
    decode = run(["ffmpeg", "-v", "error", "-i", str(video), "-f", "null", "-"])
    add(checks, "integridade_decodificacao", decode.returncode == 0, str(decode.returncode), "0", decode.stderr.strip())

    if args.format == "short":
        aspect = width / height if height else 0.0
        add(checks, "resolucao", width >= 720 and height >= 1280, f"{width}x{height}", ">=720x1280")
        add(checks, "aspect_ratio", abs(aspect - 9 / 16) <= 0.01, f"{aspect:.4f}", "9:16 ±0,01")
    else:
        aspect = width / height if height else 0.0
        add(checks, "resolucao", width >= 1280 and height >= 720, f"{width}x{height}", ">=1280x720")
        add(checks, "aspect_ratio", abs(aspect - 16 / 9) <= 0.01, f"{aspect:.4f}", "16:9 ±0,01")

    add(checks, "fps", 24.0 <= fps <= 60.0, f"{fps:.3f}", "24–60 fps")
    add(checks, "sample_rate", sample_rate == 48000, f"{sample_rate} Hz", "48000 Hz")
    add(checks, "drift_duracao", drift <= args.max_drift, f"{drift:.3f} s", f"<= {args.max_drift:.3f} s")
    add(checks, "delta_inicio", start_delta <= args.max_start_delta, f"{start_delta:.3f} s", f"<= {args.max_start_delta:.3f} s")

    trailing_silence, _ = detect_silence(video, video_duration, audio_duration)
    add(checks, "cauda_silenciosa", trailing_silence <= args.max_tail, f"{trailing_silence:.3f} s", f"<= {args.max_tail:.3f} s")

    integrated, true_peak, lra, _ = detect_loudness(video)
    loudness_ok = integrated is not None and abs(integrated - args.target_lufs) <= args.lufs_tolerance
    add(
        checks,
        "loudness_integrado",
        loudness_ok,
        "N/A" if integrated is None else f"{integrated:.1f} LUFS",
        f"{args.target_lufs:.1f} ± {args.lufs_tolerance:.1f} LUFS",
    )
    peak_ok = true_peak is not None and true_peak <= args.max_true_peak
    add(
        checks,
        "true_peak",
        peak_ok,
        "N/A" if true_peak is None else f"{true_peak:.1f} dBTP",
        f"<= {args.max_true_peak:.1f} dBTP",
    )

    max_freeze, max_black, _ = detect_visual_stalls(video)
    add(checks, "freeze_nao_intencional", max_freeze <= args.max_freeze, f"{max_freeze:.3f} s", f"<= {args.max_freeze:.3f} s")
    add(checks, "black_frame", max_black <= args.max_black, f"{max_black:.3f} s", f"<= {args.max_black:.3f} s")

    failures = [asdict(item) for item in checks if item.status == "FAIL"]
    report = {
        "video": str(video),
        "sha256": sha256(video),
        "format_profile": args.format,
        "duration_seconds": format_duration,
        "video_duration_seconds": video_duration,
        "audio_duration_seconds": audio_duration,
        "width": width,
        "height": height,
        "fps": fps,
        "sample_rate": sample_rate,
        "integrated_lufs": integrated,
        "true_peak_dbtp": true_peak,
        "lra_lu": lra,
        "checks": [asdict(item) for item in checks],
        "technical_verdict": "TECHNICALLY_APPROVED" if not failures else "TECHNICALLY_REJECTED",
        "failures": failures,
        "mandatory_next_gate": "Auditoria perceptual e de compliance; este script não autoriza entrega sozinho.",
    }
    return report, 0 if not failures else 1


def render_markdown(report: dict) -> str:
    rows = ["| Critério | Status | Valor | Limite |", "|---|---|---:|---:|"]
    for item in report["checks"]:
        rows.append(f"| {item['name']} | **{item['status']}** | {item['value']} | {item['limit']} |")
    table = "\n".join(rows)
    return f"""# Gate técnico audiovisual

| Campo | Valor |
|---|---|
| Arquivo | `{report['video']}` |
| SHA-256 | `{report['sha256']}` |
| Perfil | `{report['format_profile']}` |
| Duração | {report['duration_seconds']:.3f} s |
| Veredito técnico | **{report['technical_verdict']}** |

{table}

> Este gate não avalia realismo, lip sync perceptual, fidelidade do produto, narração ou compliance. A entrega só pode ocorrer após o certificado perceptual obrigatório.
"""


def main() -> int:
    parser = argparse.ArgumentParser(description="Gate técnico audiovisual Movie Money")
    parser.add_argument("video", type=Path)
    parser.add_argument("--format", choices=["short", "youtube"], required=True)
    parser.add_argument("--report", type=Path, required=True)
    parser.add_argument("--json-report", type=Path)
    parser.add_argument("--max-drift", type=float, default=0.05)
    parser.add_argument("--max-start-delta", type=float, default=0.02)
    parser.add_argument("--max-tail", type=float, default=0.20)
    parser.add_argument("--target-lufs", type=float, default=-16.0)
    parser.add_argument("--lufs-tolerance", type=float, default=1.0)
    parser.add_argument("--max-true-peak", type=float, default=-1.0)
    parser.add_argument("--max-freeze", type=float, default=0.50)
    parser.add_argument("--max-black", type=float, default=0.20)
    args = parser.parse_args()

    report, exit_code = build_report(args)
    args.report.parent.mkdir(parents=True, exist_ok=True)
    args.report.write_text(render_markdown(report), encoding="utf-8")
    if args.json_report:
        args.json_report.parent.mkdir(parents=True, exist_ok=True)
        args.json_report.write_text(json.dumps(report, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")

    print(report["technical_verdict"])
    print(f"Relatório: {args.report}")
    return exit_code


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except Exception as error:
        print(f"ERRO: {error}", file=sys.stderr)
        raise SystemExit(2)
