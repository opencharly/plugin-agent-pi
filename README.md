# plugin-agent-pi

The `plugin-agent-pi` plugin candy of the [opencharly/charly](https://github.com/opencharly/charly)
candy library, as a standalone repo (the candy de-submodule cutover, plugin
kind). The Go module lives at `candy/plugin-agent-pi/` with module path
`github.com/opencharly/plugin-agent-pi/candy/plugin-agent-pi`; the charly resolver fetches this repo at the pinned tag and
the compiled-in wiring imports the module at that path.
