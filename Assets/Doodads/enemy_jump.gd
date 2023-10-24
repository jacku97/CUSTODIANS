extends EnemyState

func enter() -> void:
	
	enemy.anim.play(animName)
	enemy.velocity.x *=2.5
	enemy.velocity.z *=2.5
	enemy.velocity.y = 3


func physics_process(delta: float) -> int:
	enemy.move_and_slide()
	return State.Fall
	
	return State.Null
