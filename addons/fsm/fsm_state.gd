class_name FSMState, "icons/play-button.png"
extends Node


# ----------------------------------------------------------------------------
var _fsm: Node # class FSM


# ----------------------------------------------------------------------------
func setup(fsm) -> void:
	_fsm = fsm


# ----------------------------------------------------------------------------
func on_process(_delta: float) -> void:
	pass


# ----------------------------------------------------------------------------
func on_physics_process(_delta: float) -> void:
	pass


# ----------------------------------------------------------------------------
func on_input(_event: InputEvent) -> void:
	pass


# ----------------------------------------------------------------------------
func on_unhandled_input(_event: InputEvent) -> void:
	pass


# ----------------------------------------------------------------------------
func on_enter(_previous_state: String) -> void:
	pass


# ----------------------------------------------------------------------------
func on_exit(_next_state: String) -> void:
	pass
