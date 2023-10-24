class_name BaseState
extends Node


# This enum is used so that each child state can reference each other for its return value
enum State {
	Null,
	Idle,
	Walk,
	Fall,
	Jump,
	Dash
}

var player: Player

func enter() -> void:
	pass

func exit() -> void:
	pass

# Enums are internally stored as ints, so that is the expected return type
func input(event: InputEvent) -> int:
	return State.Null

func process(delta: float) -> int:
	return State.Null

func physics_process(delta: float) -> int:
	return State.Null
