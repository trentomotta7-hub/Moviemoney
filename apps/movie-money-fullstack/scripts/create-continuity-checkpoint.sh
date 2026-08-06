#!/usr/bin/env bash

set -euo pipefail

if [[ "${SKIP_CONTINUITY_CHECKPOINT:-0}" == "1" ]]; then
  exit 0
fi

repo_root="$(git rev-parse --show-toplevel)"
cd "$repo_root"

if git diff --cached --quiet; then
  exit 0
fi

timestamp="$(date -u +%Y%m%d-%H%M%S)"
iso_date="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
branch="$(git branch --show-current 2>/dev/null || true)"
branch="${branch:-detached-head}"
safe_branch="$(printf '%s' "$branch" | tr '/ ' '--' | tr -cd '[:alnum:]_.-')"
checkpoint_dir="$repo_root/.project-memory/checkpoints"
checkpoint="$checkpoint_dir/${timestamp}-auto-${safe_branch}.md"

mkdir -p "$checkpoint_dir"

if [[ -e "$checkpoint" ]]; then
  checkpoint="$checkpoint_dir/${timestamp}-auto-${safe_branch}-$$.md"
fi

previous_commit="$(git rev-parse --short HEAD 2>/dev/null || printf 'initial')"
changed_files="$(git diff --cached --name-status -- . ':(exclude).project-memory/checkpoints/*' || true)"
change_summary="$(git diff --cached --stat -- . ':(exclude).project-memory/checkpoints/*' || true)"

{
  printf '# Checkpoint automático — commit em preparação\n\n'
  printf '**Data:** %s  \n' "$iso_date"
  printf '**Status:** Em progresso  \n'
  printf '**Branch:** `%s`  \n' "$branch"
  printf '**Commit anterior:** `%s`\n\n' "$previous_commit"
  printf '## O que mudou\n\n'
  if [[ -n "$change_summary" ]]; then
    printf '```text\n%s\n```\n\n' "$change_summary"
  else
    printf 'Alterações versionadas sem resumo estatístico disponível.\n\n'
  fi
  printf '## Arquivos preparados\n\n'
  if [[ -n "$changed_files" ]]; then
    printf '```text\n%s\n```\n\n' "$changed_files"
  else
    printf 'Nenhum arquivo de produto além da memória de continuidade.\n\n'
  fi
  printf '## Decisões e contexto\n\n'
  printf 'Consulte `current-context.md`, `next-actions.md` e o checkpoint manual mais recente para as decisões funcionais e o próximo passo.\n\n'
  printf '## Próximas ações\n\n'
  printf 'Retomar a primeira ação incompleta em `.project-memory/next-actions.md`.\n'
} > "$checkpoint"

git add "$checkpoint"
printf 'Checkpoint de continuidade adicionado: %s\n' "${checkpoint#$repo_root/}"
