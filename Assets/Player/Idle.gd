extends BaseState


func enter() -> void:
	pass

func input(event: InputEvent) -> int:
	if Input.is_action_pressed("left") or Input.is_action_pressed("right") or Input.is_action_pressed("forward") or Input.is_action_pressed("backward"):
		
		return State.Walk
	elif Input.is_action_just_pressed("jump"):
		return State.Jump
	else:
		player.velocity.x = 0
		player.velocity.y = 0
	return State.Null

func physics_process(delta: float) -> int:
	if !player.is_on_floor():
		
		return State.Fall
	player.move_and_slide()
	return State.Null
