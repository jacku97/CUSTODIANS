class_name Player
extends CharacterBody3D

signal contam
signal contam_updated

#SOUNDS#
@onready var footstep = $SFX/footstep
@onready var rotsfx = $SFX/rotation
@onready var contsfx = $SFX/contamina
@onready var hitsfx = $SFX/hit


@onready var states = $StateManager
@onready var head = $Head
@onready var camera = $Head/Camera3D
@onready var anim = $AnimationPlayer
@onready var gunman = $Head/Camera3D/WeaponManager
@onready var repairs_label = $Hud/VBoxContainer/HBoxContainer4/RepairPacks
@onready var hud = $Hud
@onready var hud_anim = $Hud/AnimationPlayer2
@onready var dash_cd = $DashCD
@onready var gunspot = $Head/Camera3D/WeaponManager/GunRig/Bullet_Point/SpotLight3D
@onready var self_destruct = $SelfDestruct

@export var speed = 5
@export var gravity = 9.8
@export var sensitivity = 0.003
@export var cam_speed = 0.008
@export var cam_fast = 0.05
@export var cam_norm = 0.008
@export var cam_slow = 0.003

@export var contamination = 0
@export var contamination_chance = 0
var contaminated = false
var locked = false
var lock_target

var dashes = 3
var repair_packs = 5


#Head Bob
const BOB_FREQ = 2.0
const BOB_AMP = 0.08
var t_bob = 0.0

var can_play : bool = true
signal step

func _ready() -> void:
	# Initialize the state machine, passing a reference of the player to the states,
	# that way they can move and react accordingly
	states.init(self)
	gunman.init(self)
	hud.init(self)
	repairs_label.text = str(repair_packs)
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_pressed("exit"):
		get_tree().quit()
	states.input(event)
	
	
	
	if Input.is_action_just_pressed("quickturn"):
		head.rotate_y(deg_to_rad(180))
	
	if Input.is_action_just_pressed("camfast"):
		cam_speed = cam_fast
	
	if Input.is_action_just_pressed("camnorm"):
		cam_speed = cam_norm
	
	if Input.is_action_just_pressed("camslow"):
		cam_speed = cam_slow
	
	
	#MOUSE LOOK#
#	if event is InputEventMouseMotion:
#		head.rotate_y(-event.relative.x * sensitivity)
#		camera.rotate_x(-event.relative.y * sensitivity)
#		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-40), deg_to_rad(60))

func _process(delta):
	#Handle Repair Label
	repairs_label.text = str(repair_packs)
	if dashes < 3 and dash_cd.is_stopped():
		dash_cd.start()
	
	
	
func _physics_process(delta):
	states.physics_process(delta)
	#KEYBOARD LOOK#
	if Input.is_action_pressed("rleft") and locked == false:
		head.rotate_y(cam_speed)
		rotsfx.play()
	if Input.is_action_pressed("rright")and locked == false:
		head.rotate_y(-cam_speed)
		rotsfx.play()
	if Input.is_action_pressed("rup") and locked == false:
		camera.rotate_x(cam_speed)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-40), deg_to_rad(60))
		rotsfx.play()
	if Input.is_action_pressed("rdown")and locked == false:
		camera.rotate_x(-cam_speed)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-40), deg_to_rad(60))
		rotsfx.play()

	if locked == true:
		if is_instance_valid(lock_target):
			var head_target = Vector3(0,lock_target.lock_point.global_transform.origin.y, 0)
			var cam_target = Vector3(lock_target.lock_point.global_transform.origin.x, 0 , 0)
			head.look_at(lock_target.lock_point.global_transform.origin)
			#camera.look_at(cam_target)
			
			
		else:
			locked = false
	
	#Head bob
	t_bob += delta * velocity.length()* float(is_on_floor())
	camera.transform.origin = _headbob(t_bob)
	
	
func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	
	var low_pos = BOB_AMP - 0.05
	if pos.y > -low_pos:
		can_play = true
		
	if pos.y < -low_pos and can_play:
		footstep.play()
		can_play = false
	
	return pos


func hit():
	hud_anim.play("hit")
	hitsfx.pitch_scale = randf_range(0.8, 1.2)
	hitsfx.play()
	if not contaminated:
		print_debug("Player hit")
		print_debug("contamination: ",contamination, " Contamination chance: ", contamination_chance)
	#When the player gets hit
	#Check to see if contaminated
		var cont_check = randi_range(0,100)
		contamination = randi_range(contamination, (contamination + 8))
	#If contaminated, run contaminated state
		if cont_check < contamination_chance:
			contaminated = true
			emit_signal("contam")
			contsfx.play()
			self_destruct.start()
	#If not contaminated, increase contamination chance
		else:
			contamination_chance += contamination
		emit_signal("contam_updated", contamination_chance)
	else:
		pass

func contamination_up(amount):
	if not contaminated:
		print_debug("Player hit")
		print_debug("contamination: ",contamination, " Contamination chance: ", contamination_chance)
	#When the player gets hit
	#Check to see if contaminated
		var cont_check = randi_range(0,100)
		contamination = amount
	#If contaminated, run contaminated state
		if cont_check < contamination_chance:
			contaminated = true
			emit_signal("contam")
			contsfx.play()
			self_destruct.start()
	#If not contaminated, increase contamination chance
		else:
			contamination_chance += contamination
		emit_signal("contam_updated", contamination_chance)
	

func _on_dash_cd_timeout():
	dashes += 1


func _on_self_destruct_timeout():
	get_tree().quit()
