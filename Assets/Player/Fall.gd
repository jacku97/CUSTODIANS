extends BaseState

@export var sound : AudioStream

func enter() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func physics_process(delta: float) -> int:
	player.velocity.y -= player.gravity * delta
	if Input.is_action_just_pressed("dash") and player.dashes > 0:
		player.dashes -= 1
		return State.Dash
	if player.is_on_floor():
		AudioManager.play_sound(sound, -5)
		return State.Idle
	player.move_and_slide()
	
	
	
	return State.Null
	
func exit() -> void:
#	player.velocity.x = 0
#	player.velocity.z = 0
	pass
