extends BaseState

@export var sound : AudioStream
@export var sound2 : AudioStream

func enter() -> void:
	AudioManager.play_sound(sound, 0)
	#AudioManager.play_sound(sound2, -5)
	pass

func physics_process(delta: float) -> int:
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (player.head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	player.velocity.x = direction.x * 10
	player.velocity.z = direction.z * 10
	player.velocity.y = 2
	player.move_and_slide()
	return State.Fall
	return State.Null
