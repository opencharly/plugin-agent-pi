# plugin-agent-pi

The Pi agent runtime for OpenCharly — the `agent-runtime:pi` provider.

The plugin launches the ephemeral native Pi SDK runner, carries Pi's upstream
`runRpcMode` JSONL over the generic CUE-generated `Provider.Channel`, persists
through the SessionManager, and exits at Pi's deterministic `agent_end` event.
There is no daemon and no listener. An opt-in adapter delegates to the official
experimental Pi orchestrator `rpc-stream` CLI without duplicating its socket
protocol.

## What it provides

| Capability | Surface |
|---|---|
| `agent-runtime:pi` | the `pi` agent runtime — `charly agent runtime status pi --class agent-runtime` reports `"streaming":true` |

## How to use it

Compose the plugin candy in a box's `candy:` list alongside the Pi runtime layer
(the candy `require:`s `@github.com/opencharly/layer-pi-agent`):

```yaml
- '@github.com/opencharly/plugin-agent-pi/candy/plugin-agent-pi:<tag>'
```

Then create a session on the runtime:

```bash
charly agent session create pi
charly agent runtime status pi --class agent-runtime
```

## Layout

- `candy/plugin-agent-pi/` — the plugin module: `plugin.go` (the provider +
  `Provider.Channel` streaming), `schema/pi.cue` (the version-pinned
  `#PiPlugin` / `#PiRPCCommand` / `#PiRPCState` boundary schema),
  `params/cue_types_gen.go`, `cmd/serve/main.go`.
- `candy/plugin-agent-pi/charly.yml` — the `plugin-agent-pi:` candy entity
  (`plugin:`, `require:`, `plan:` check).
- `charly.yml` — the root project manifest (`discover: candy`).
- `.github/workflows/tag-on-merge.yml` — CalVer tag + `CHANGELOG/` on merge.

## Related

- Owning skill: `/charly-automation:agent` — the agent control-plane surface,
  including the `pi` native/orchestrator modes. This candy carries no `skill:`
  entity of its own; the gap is tracked in
  [opencharly/opencharly#291](https://github.com/opencharly/opencharly/issues/291).
- Runtime layer: [`opencharly/layer-pi-agent`](https://github.com/opencharly/layer-pi-agent) — the Pi runtime candy this plugin `require:`s.
- `/charly-internals:plugin` — the plugin/provider model.
- [`opencharly/charly`](https://github.com/opencharly/charly) — the charly CLI.
