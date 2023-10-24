extends Node3D

signal weapon_changed
signal update_ammo
signal update_weapon_stack

@onready var anim = $GunRig/GunAnims

@onready var bullet_point = $GunRig/Bullet_Point

@export var muzzflash : PackedScene

var current_weapon = null

var weapon_stack = [] #Array of weapons currently held by the player

var weapon_indicator = 0

var next_weapon: String

var weapon_list = {} #Dictionary with all weapons in the game

@export var weapon_resources: Array[WeaponResource]

@export var start_weapons: Array[String] #Weapons the player has when the game starts

enum {
	NULL,
	HITSCAN,
	PROJECTILE
}

var player: Player

func _ready():
	$GunRig/Pistol.hide()
	$GunRig/Rifle.hide()
	initialize(start_weapons)

func _input(event):
	if event.is_action_pressed("Wep1"):
		print_debug("Weapon 1")
		weapon_indicator = min(weapon_indicator+1, weapon_stack.size()-1)
		exit(weapon_stack[weapon_indicator])
	
	if event.is_action_pressed("Wep2"):
		print_debug("Weapon 2")
		weapon_indicator = max(weapon_indicator-1,0)
		exit(weapon_stack[weapon_indicator])
	
	if Input.is_action_just_pressed("quickturn"):
		anim.queue(current_weapon.activate_anim)
		
	if event.is_action_pressed("shoot"):
		shoot()
	
	if event.is_action_pressed("reload"):
		repair()
	
	if event.is_action_pressed("lockon"):
		lock_on()
		
func init(plr: Player):
	player = plr
	

func initialize(_start_weapons: Array):
	#Populates the dictionary so we can refer to our weapons
	for weapon in weapon_resources:
		weapon_list[weapon.weapon_name] = weapon
	
	#Add our starting weapons
	for i in start_weapons:
		weapon_stack.push_back(i) 
	
	#Set the first weapon in the stack as our current weapon
	current_weapon = weapon_list[weapon_stack[0]]
	emit_signal("update_weapon_stack", weapon_stack)
	enter()
	
func enter(): #Called when a new weapon is selected
	anim.queue(current_weapon.activate_anim)
	emit_signal("weapon_changed", current_weapon.weapon_name)
	emit_signal("update_ammo", current_weapon.current_condition )

func exit(_next_weapon : String): #Called before weapon change, make sure we can change
	if _next_weapon != current_weapon.weapon_name:
		if anim.get_current_animation() != current_weapon.deactivate_anim:
			anim.play(current_weapon.deactivate_anim)
			next_weapon= _next_weapon

func change_weapon(weapon_name : String):
	current_weapon = weapon_list[weapon_name]
	next_weapon = ""
	enter()


func _on_gun_anims_animation_finished(anim_name):
	if anim_name == current_weapon.deactivate_anim:
		change_weapon(next_weapon)
	
	if anim_name == current_weapon.reload_anim:
		
		emit_signal("update_ammo", current_weapon.current_condition)
	
	
	if anim_name == current_weapon.shoot_anim and current_weapon.auto_fire == true:
		
		if Input.is_action_pressed("shoot"):
			
			shoot()

func shoot():
	if current_weapon.current_condition > 0:
		if !anim.is_playing():
			#Lose "Ammo"
			current_weapon.current_condition -= randf_range(current_weapon.con_loss_min, current_weapon.con_loss_max)
			emit_signal("update_ammo", current_weapon.current_condition)
			anim.play(current_weapon.shoot_anim)
			AudioManager.play_sound(current_weapon.shoot_sound, -3)
			var muzz = muzzflash.instantiate()
			bullet_point.add_child(muzz)
			
			
			var cam_collision = get_camera_collision()
			match current_weapon.type:
				NULL:
					print_debug("Weapon type not chosen")
				HITSCAN:
					hitscan_position(cam_collision)
				PROJECTILE:
					pass
				

func repair():
	if !anim.is_playing() and current_weapon.current_condition < current_weapon.max_condition and player.repair_packs > 0:
		player.repair_packs -= 1
		print_debug(player.repair_packs)
		current_weapon.current_condition = current_weapon.max_condition
		
		anim.play(current_weapon.reload_anim)
		AudioManager.play_sound(current_weapon.reload_sound,-8)
		
func lock_on():
	if player.locked == true:
		player.locked = false
	var cam_collision = get_camera_collision()
	var bullet_direction = (cam_collision - bullet_point.get_global_transform().origin).normalized()
	var new_intersection = PhysicsRayQueryParameters3D.create(bullet_point.get_global_transform().origin,cam_collision+bullet_direction*2)
	
	var bullet_col = get_world_3d().direct_space_state.intersect_ray(new_intersection)
	
	if bullet_col and bullet_col.collider.is_in_group("Enemy"):
		player.lock_target = bullet_col.collider
		player.locked = true
		pass
		
func get_camera_collision()->Vector3:
	var camera = get_viewport().get_camera_3d()
	var viewport = get_viewport().get_size()
	
	var ray_origin = camera.project_ray_origin(viewport/2)
	var ray_end = ray_origin + camera.project_ray_normal(viewport/2) * current_weapon.weapon_range
	
	var new_intersection = PhysicsRayQueryParameters3D.create(ray_origin,ray_end)
	var intersection = get_world_3d().direct_space_state.intersect_ray(new_intersection)
	
	if not intersection.is_empty():
		var col_point = intersection.position
		return col_point
	else:
		return ray_end
		
func hitscan_position(collision_point):
	var bullet_direction = (collision_point - bullet_point.get_global_transform().origin).normalized()
	var new_intersection = PhysicsRayQueryParameters3D.create(bullet_point.get_global_transform().origin,collision_point+bullet_direction*2)
	
	var bullet_col = get_world_3d().direct_space_state.intersect_ray(new_intersection)
	
	if bullet_col:
		hit_scan_damage(bullet_col.collider, bullet_direction, bullet_col.position)
		
func hit_scan_damage(collider, direction, position):
	if collider.is_in_group("Target") and collider.has_method("hit"):
		collider.hit(current_weapon.damage, player, direction, position)
	if collider.is_in_group("Enemy") and collider.has_method("hit"):
		collider.hit(current_weapon.damage, player, direction, position)

