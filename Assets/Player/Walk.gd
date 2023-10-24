extends BaseState




func input(event: InputEvent) -> int:
	if Input.is_action_just_pressed("jump"):
		return State.Jump
	
	if Input.is_action_just_pressed("dash") and player.dashes > 0:
		player.dashes -= 1
		return State.Dash
	return State.Null


func physics_process(delta: float) -> int:
	
	if !player.is_on_floor():
		return State.Fall
	
	
	if Input.is_action_just_pressed("jump"):
		return State.Jump
	
	
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (player.head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		player.velocity.x = direction.x * player.speed
		player.velocity.z = direction.z * player.speed
	else:
		player.velocity.x = move_toward(player.velocity.x, 0 , player.speed)
		player.velocity.z = move_toward(player.velocity.z, 0 , player.speed)
		return State.Idle
		
	player.move_and_slide()
	
	return State.Null



	
