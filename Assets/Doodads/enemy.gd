extends CharacterBody3D
class_name Enemy


@onready var nav_agent = $NavigationAgent3D
@onready var states = $StateMachine
@onready var jumptimer = $JumpTimer
@onready var hit_box = $Hitbox
@onready var hbox_timer = $HboxTimer
@onready var anim = $Enemy_01/AnimationPlayer
@onready var alert = $Alert
@onready var lock_point = $LockPoint


@onready var sfx_scream = $Scream
@onready var sfx_footstep = $Footstep
@onready var sfx_dead = $Dead
@onready var sfx_hit = $Hit


@export var health = 10
@export var speed = 8 
var gravity = 9.8



var allies = [Enemy]
var player_found = false
var can_jump = true
var can_attack = true
var player : Player
var dead = false

var target_reached = false

func _ready() -> void:
	states.init(self)


	

func _physics_process(delta):
	states.physics_process(delta)
	
	

func hit(damage, source : Player, _direction := Vector3.ZERO, _position:= Vector3.ZERO):
	if !player_found:
		for ally in allies:
			ally.alerted(source)
		
	var hit_pos = _position - get_global_transform().origin
	player = source
	player_found = true
	health -= damage
	print_debug("Target hit")
	if health <= 0:
		print_debug("I died")
		queue_free()
		anim.play("death")
		sfx_dead.pitch_scale = randf_range(0.8, 1.2)
		sfx_dead.play()
		
		
	else:
		sfx_hit.pitch_scale = randf_range(0.8, 1.2)
		sfx_hit.play()
		
	
	if _direction != Vector3.ZERO:
		#apply_impulse((_direction*damage), hit_pos)
		velocity.x += -1 * damage
		velocity.z += -1 * damage


func _on_detection_body_entered(body):
	
	if body is Player:
		player_found = true
		player = body


func _on_jump_timer_timeout():
	can_jump = true


func _on_hbox_timer_timeout():
	print_debug("hbox timer")
	can_attack = true


func _on_hitbox_body_entered(body):
	if body is Player and can_attack:
		body.hit()
		can_attack = false
		hbox_timer.start()

func footstep():
	sfx_footstep.pitch_scale = randf_range(0.8, 1.2)
	sfx_footstep.play()

func scream():
	sfx_scream.pitch_scale = randf_range(0.8, 1.2)
	sfx_scream.play()

func alerted(target: Player):
	player_found = true
	player = target



func _on_alert_body_entered(body):
	if body is Enemy:
		allies.append(body)
		print_debug("Ally found")





func _on_animation_player_animation_finished(anim_name):
	if anim_name == "death":
		queue_free()
