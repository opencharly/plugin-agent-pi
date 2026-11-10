// Pi owns the RPC semantics and implementation. This version-pinned boundary
// schema owns every JSONL field Charly accepts or emits while delegating those
// messages unchanged to upstream runRpcMode.
#PiPlugin: {
	runtime:  "pi"
	contract: "pi-rpc-0.80.10"
}

#PiRPCCommand: {
	id?: string & !=""
	// S3: the words are rows of the `_commandType` table at the foot of this
	// file; the enum is `or()` of its derived word list, so the catalog has ONE
	// home.
	type:     or(_commandTypeWord)
	message?: string
	images?: [...]
	streamingBehavior?:  or(_streamingBehaviorWord)
	parentSession?:      string
	provider?:           string & !=""
	modelId?:            string & !=""
	level?:              string & !=""
	mode?:               or(_modeWord)
	customInstructions?: string
	enabled?:            bool
	command?:            string
	excludeFromContext?: bool
	outputPath?:         string
	sessionPath?:        string & !=""
	entryId?:            string & !=""
	since?:              string
	name?:               string & !=""
	value?:              string
	confirmed?:          bool
	cancelled?:          bool
}

#PiGetStateCommand: {
	id:   string & !=""
	type: "get_state"
}

#PiPromptCommand: {
	id:      string & !=""
	type:    "prompt"
	message: string & !=""
}

#PiAbortCommand: {
	type: "abort"
}

// Events are passed through losslessly. The discriminator and the response
// fields Charly interprets are closed and typed; event-specific upstream data
// remains opaque to the adapter.
#PiRPCEvent: {
	type:     string & !=""
	id?:      string
	command?: string
	success?: bool
	error?:   string
	data?:    _
	...
}

#PiRPCState: {
	model?:                _
	thinkingLevel:         string & !=""
	isStreaming:           bool
	isCompacting:          bool
	steeringMode:          or(_modeWord)
	followUpMode:          or(_modeWord)
	sessionFile?:          string @go(SessionFile)
	sessionId:             string & !=""
	sessionName?:          string
	autoCompactionEnabled: bool
	messageCount:          int & >=0
	pendingMessageCount:   int & >=0
}

#PiRPCStateResponse: {
	id?:     string
	type:    "response"
	command: "get_state"
	success: bool
	data?:   #PiRPCState @go(Data,type=*PiRPCState)
	error?:  string
}

// --- vocabulary tables (S3) --------------------------------------------------
// Every closed set of words is a table keyed by word, and its word list is
// derived from the table and used as `or()` of that list (§10.1 S3, D-PAT-3).
// The table and the enum it feeds therefore cannot disagree, and a new word is
// ONE row here. `@vocab` names the owner (§3.1): this set is compiled into THIS
// plugin, so the owner is the plugin's own word `pi`.
_commandType: {
	prompt: {}
	steer: {}
	follow_up: {}
	abort: {}
	new_session: {}
	get_state: {}
	set_model: {}
	cycle_model: {}
	get_available_models: {}
	set_thinking_level: {}
	cycle_thinking_level: {}
	set_steering_mode: {}
	set_follow_up_mode: {}
	compact: {}
	set_auto_compaction: {}
	set_auto_retry: {}
	abort_retry: {}
	bash: {}
	abort_bash: {}
	get_session_stats: {}
	export_html: {}
	switch_session: {}
	fork: {}
	clone: {}
	get_fork_messages: {}
	get_entries: {}
	get_tree: {}
	get_last_assistant_text: {}
	set_session_name: {}
	get_messages: {}
	get_commands: {}
	extension_ui_response: {}
} @vocab(pi)
_commandTypeWord: [for w, _ in _commandType {w}]

_streamingBehavior: {steer: {}, "followUp": {}} @vocab(pi)
_streamingBehaviorWord: [for w, _ in _streamingBehavior {w}]

// ONE table for the ONE upstream enum Pi renders in three fields: the command's
// `mode`, and the state's `steeringMode` / `followUpMode`. Extracting on the
// second occurrence keeps the single home.
_mode: {all: {}, "one-at-a-time": {}} @vocab(pi)
_modeWord: [for w, _ in _mode {w}]
