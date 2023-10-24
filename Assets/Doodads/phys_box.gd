extends RigidBody3D

var health = 100

func hit(damage, source : Player, _direction := Vector3.ZERO, _position:= Vector3.ZERO):
	var hit_pos = _position - get_global_transform().origin
	
	health -= damage
	print_debug("Target hit")
	if health <= 0:
		queue_free() 
	
	if _direction != Vector3.ZERO:
		apply_impulse((_direction*damage), hit_pos)
