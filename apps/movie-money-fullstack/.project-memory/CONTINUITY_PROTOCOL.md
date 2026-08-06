# Continuity Protocol — Operational Workflow

## Automação deste repositório

O repositório usa um hook versionado em `.githooks/pre-commit`. Antes de cada commit com alterações preparadas, ele executa `scripts/create-continuity-checkpoint.sh`, cria um checkpoint timestampado com o resumo do índice e adiciona esse arquivo ao mesmo commit. A configuração local necessária é `git config core.hooksPath .githooks`.

Use `SKIP_CONTINUITY_CHECKPOINT=1 git commit ...` somente em recuperação emergencial, documentando a exceção no checkpoint manual seguinte. O hook registra nomes e estatísticas de arquivos; ele não lê nem grava valores de segredos.

## Checkpoint Creation

Create a checkpoint after:
1. Completing a major feature or phase
2. Resolving a significant bug or blocker
3. Making architectural decisions
4. Generating or processing large assets
5. Before handing off to another developer
6. At the end of each development session

## Checkpoint File Format

**Location:** `.project-memory/checkpoints/YYYYMMDD-HHMMSS-description.md`

**Template:**
```markdown
# Checkpoint — [Description]
**Date:** [ISO 8601]  
**Status:** ✅ Completed / 🔄 In Progress / ⚠️ Blocked

## What was done
[List of completed work]

## Assets produced/modified
| Asset | File | Status |
|-------|------|--------|

## Key decisions
- [Decision]: [Rationale]

## Known issues
- [Issue]: [Impact and workaround]

## Next actions
- [ ] [Action 1]
- [ ] [Action 2]
```

## Developer Workflow

**Start session:**
1. Read ONBOARDING.md
2. Read latest checkpoint
3. Read next-actions.md
4. Begin work

**During development:**
- Commit frequently with clear messages
- Use conventional commits: feat:, fix:, chore:, docs:
- Create branches: feature/[name], bugfix/[name]

**After logical unit:**
- Create checkpoint
- Fill in template
- Commit: `git add . && git commit -m "chore: [description] + checkpoint"`

**End session:**
- Update current-context.md
- Update next-actions.md
- Commit and push

## Handoff Procedure

1. Create final checkpoint summarizing entire project
2. Update current-context.md
3. Add "Handoff Notes" to ONBOARDING.md
4. Ensure PERMISSIONS.md is current
5. Schedule 15-30 min sync
6. Make yourself available for 2-3 days

---

For more details, see SKILL.md in the project-continuity-protocol skill.
