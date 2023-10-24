extends EnemyState

func enter() -> void:
	enemy.velocity = Vector3.ZERO
	enemy.anim.play(animName)

func physics_process(delta: float) -> int:
	if enemy.player_found == true:
		return State.Walk
#	if !enemy.is_on_floor():
#		return State.Fall
	return State.Null



