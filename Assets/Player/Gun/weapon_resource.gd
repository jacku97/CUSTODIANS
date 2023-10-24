extends Resource

class_name WeaponResource

@export var weapon_name: String
@export var activate_anim: String
@export var deactivate_anim: String
@export var shoot_anim: String
@export var reload_anim: String

@export var current_condition: float
@export var max_condition: float
@export var con_loss_min: float
@export var con_loss_max: float

@export var auto_fire: bool
@export var shoot_sound : AudioStream
@export var reload_sound : AudioStream

@export_flags("Hitscan", "Projectile") var type
@export var weapon_range : int
@export var damage: int


