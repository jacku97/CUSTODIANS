extends EnemyState

var reached = false
func enter() -> void:
	enemy.anim.speed_scale = randf_range(1.2,2)
	enemy.anim.play(animName)
	#enemy.player_found = false
	pass
func physics_process(delta: float) -> int:
	update_target_location(enemy.player.global_transform.origin)
	var current_location = enemy.global_transform.origin
	var next_location = enemy.nav_agent.get_next_path_position()
	var new_vel = (next_location - current_location).normalized() * enemy.speed
	
	enemy.nav_agent.set_velocity(new_vel)
	
	
	
	enemy.look_at(enemy.player.global_transform.origin, Vector3.UP)
	
	if reached == true and enemy.can_jump == true:
		enemy.jumptimer.start()
		enemy.can_jump = false
		return State.Jump
#	if !enemy.is_on_floor():
#		return State.Fall
	
	return State.Null
	
func update_target_location(target_location):
	enemy.nav_agent.target_position=target_location


func exit() -> void:
	reached = false


func _on_navigation_agent_3d_target_reached():
	reached = true


func _on_navigation_agent_3d_velocity_computed(safe_velocity):
	enemy.velocity = enemy.velocity.move_toward(safe_velocity , 0.25)
	enemy.move_and_slide()
