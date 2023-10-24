extends Node

# Using enums for state names that way every script has the same interface
# while being more robust and less error prone than using strings
@onready var states = {
	EnemyState.State.Idle: $Idle,
	EnemyState.State.Walk: $Walk,
	EnemyState.State.Fall: $Fall,
	EnemyState.State.Jump: $Jump,
	EnemyState.State.Attack: $Attack
	
}

var current_state: EnemyState

func change_state(new_state: int) -> void:
	
	if current_state:
		current_state.exit()
	
	current_state = states[new_state]
	print_debug("Enemy entered ", current_state)
	current_state.enter()

# Initialize the state machine by giving each state a reference to the objects
# owned by the parent that they should be able to take control of
# and set a default state
func init(enemy: Enemy) -> void:
	
	for child in get_children():
		child.enemy = enemy
	
	# Initialize with a default state of idle
	change_state(EnemyState.State.Idle)
	
# Pass through functions for the Player to call,
# handling state changes as needed
func physics_process(delta: float) -> void:
	var new_state = current_state.physics_process(delta)
	if new_state != EnemyState.State.Null:
		change_state(new_state)

func input(event: InputEvent) -> void:
	var new_state = current_state.input(event)
	if new_state != EnemyState.State.Null:
		change_state(new_state)
