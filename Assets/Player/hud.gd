extends CanvasLayer

@onready var current_weapon_label = $VBoxContainer/HBoxContainer/CurrentWeaponLabel
@onready var condition_bar = $WeaponCondition
@onready var weapon_stack = $VBoxContainer/HBoxContainer3/WeaponStack
@onready var repairs_label = $VBoxContainer/HBoxContainer4/RepairPacks
@onready var dashes = $VBoxContainer/HBoxContainer5/Dashes
@onready var dashcd = $VBoxContainer/HBoxContainer5/Dashcool
@onready var contam_label = $HBoxContainer6/Contam
@onready var anim = $AnimationPlayer
@onready var selfd_label = $SeldDTime
@onready var locked = $locked
var player : Player

func init(plr : Player):
	$Contaminated.hide()
	$SelfD.hide()
	$SeldDTime.hide()
	player = plr
	dashes.text = str(player.dashes)
	
func _process(delta):
	dashcd.text = str(int(player.dash_cd.time_left))
	dashes.text = str(player.dashes)
	if player.contaminated:
		$SelfD.show()
		$SeldDTime.show()
		selfd_label.text = str(player.self_destruct.time_left)
	if player.locked == true:
		locked.show()
	else:
		locked.hide()
func _on_weapon_manager_update_ammo(condition):
	condition_bar.value = condition
	
	


func _on_weapon_manager_update_weapon_stack(new_weapon_stack):
	weapon_stack.set_text("")
	for i in new_weapon_stack:
		weapon_stack.text += "\n"+i


func _on_weapon_manager_weapon_changed(weapon_name):
	current_weapon_label.set_text(weapon_name)


func _on_player_contam():
	anim.play("contaminated_anim")


func _on_player_contam_updated(contam):
	contam_label.text = str(contam)
