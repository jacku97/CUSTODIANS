extends EnemyState

func physics_process(delta: float) -> int:
	enemy.velocity.y -= enemy.gravity * delta
	if enemy.is_on_floor():
		return State.Idle
	enemy.move_and_slide()
		
	return State.Null
