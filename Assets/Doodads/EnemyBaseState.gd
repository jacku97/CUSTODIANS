extends Node

class_name EnemyState

enum State {
	Null,
	Idle,
	Walk,
	Fall,
	Jump,
	Attack
	
	
}

var enemy: Enemy

@export var animName = ""

func enter() -> void:
	#enemy.anim.play(animName)
	pass

func exit() -> void:
	#enemy.anim.stop()
	pass

# Enums are internally stored as ints, so that is the expected return type
func input(event: InputEvent) -> int:
	return State.Null

func process(delta: float) -> int:
	return State.Null

func physics_process(delta: float) -> int:
	return State.Null

