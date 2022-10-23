class_name FSM, "icons/stack.png"
extends Node


# ----------------------------------------------------------------------------
signal changed(previous_state, next_state)

export (NodePath) var actor_node_path: NodePath
export (NodePath) var initial_state: NodePath

var actor: Node
var blackboard: Dictionary

var _current_fsm_state: Node # class FSMState
var _state_machine: Dictionary


# ----------------------------------------------------------------------------
func _init() -> void:
	actor = null
	blackboard.clear()
	_current_fsm_state = null
	_state_machine.clear()


# ----------------------------------------------------------------------------
func _ready() -> void:
	if not actor_node_path.is_empty():
		actor = get_node_or_null(actor_node_path)
	else:
		actor = get_parent()
	assert(actor, "actor must not be null")

	if get_child_count():
		for child in get_children():
			assert(child is FSMState, "node must be FSMState type")
			assert(not _state_machine.has(child.name), "duplicated state")
			child.setup(self)
			_state_machine[child.name] = child
	assert(_state_machine.size() > 0, "FSM must have at least one FSMState child")

	var state: Node
	if not initial_state.is_empty():
		state = get_node_or_null(initial_state)
	else:
		state = get_child(0)
	assert(state, "state must not be null")

	yield(actor, "ready")
	change_to(state.name)


# ----------------------------------------------------------------------------
func _process(delta: float) -> void:
	assert(is_instance_valid(_current_fsm_state))
	_current_fsm_state.on_process(delta)


# ----------------------------------------------------------------------------
func _physics_process(delta: float) -> void:
	assert(is_instance_valid(_current_fsm_state))
	_current_fsm_state.on_physics_process(delta)


# ----------------------------------------------------------------------------
func _input(event: InputEvent) -> void:
	assert(is_instance_valid(_current_fsm_state))
	_current_fsm_state.on_input(event)


# ----------------------------------------------------------------------------
func _unhandled_input(event: InputEvent) -> void:
	assert(is_instance_valid(_current_fsm_state))
	_current_fsm_state.on_unhandled_input(event)


# ----------------------------------------------------------------------------
func change_to(next_state: String) -> void:
	assert(_state_machine.has(next_state), "state not found")
	var previous_state: String = ""
	if _current_fsm_state:
		_current_fsm_state.on_exit(next_state)
		previous_state = _current_fsm_state.name
	_current_fsm_state = _state_machine[next_state]
	_current_fsm_state.on_enter(previous_state)
	emit_signal("changed", previous_state, next_state)
