# AGENTS.md — plugin-agent-pi

Standalone plugin repo for the `pi` agent runtime (`agent-runtime:pi`). The
plugin is a Go module at `candy/plugin-agent-pi/` (module path
`github.com/opencharly/plugin-agent-pi/candy/plugin-agent-pi`); the root
`charly.yml` only declares `discover: candy` so the repo is a project and its
candy is scanned.

Canonical files:

- `candy/plugin-agent-pi/charly.yml` — the `plugin-agent-pi:` candy entity
  (`plugin:` block, `require:` of the Pi runtime layer, `plan:` check).
- `candy/plugin-agent-pi/plugin.go` — the provider + `Provider.Channel` streaming.
- `candy/plugin-agent-pi/schema/pi.cue` — the version-pinned Pi RPC boundary
  schema (`#PiPlugin`, `#PiRPCCommand`, `#PiRPCState`).
- `.github/workflows/tag-on-merge.yml` — CalVer tag + `CHANGELOG/` on merge.
- `README.md` — user overview only; never agent guidance.

## Load these skills first (R0)

- `/charly-automation:agent` — the agent control-plane surface, including the
  `pi` native/orchestrator modes and the generic `Provider.Channel` streaming.
  Load before changing runtime behaviour.
- `/charly-internals:plugin` — the plugin authoring reference: the `plugin:`
  block, the unified Provider model, the per-plugin CUE-schema contract. Load
  before touching the provider or schema.
- `/charly-internals:git-workflow` — before any git/PR action.

## Build / validate / test

- `go build ./...` in `candy/plugin-agent-pi/` — compile the plugin module.
- `go test ./...` in `candy/plugin-agent-pi/` — the plugin's Go tests.
- `charly box validate` at the repo root — the structural check (the candy +
  `plugin:` block, CUE schema).
- The merge gate is the **org-wide** `charly/pr-validator` (required check
  `validate / validate`, defined in `opencharly/.github`); this repo has **no**
  per-repo candy gate.

## Modify this repo

- Edit the `plugin-agent-pi:` candy entity, the Go source, and `schema/pi.cue`
  **together** — the schema is the version-pinned boundary contract for the Pi
  JSONL, so a field change not mirrored there desyncs the generated types.
- The runtime is provided by the required `opencharly/layer-pi-agent` candy; keep
  the `require:` pin in step with it.

## Landing

- PR-only. Every change lands through a pull request; the org-required
  `charly/pr-validator` validates the diff and body and arms native auto-merge on
  PASS. Direct pushes to `main` are blocked.
- History lives in `CHANGELOG/` (written by `tag-on-merge` at merge time); the PR
  body IS the changelog.
- The authoritative rulebook is the umbrella `AGENTS.md` in
  `opencharly/opencharly` and `charly/AGENTS.md` in the charly repo. Do not
  restate its rules here.
