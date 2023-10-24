extends Node3D

@export var contam_amount = 5
@onready var timer = $Timer

var player : Player
var active = false
func _on_area_3d_body_entered(body):
	if body is Player:
		
		active = true
		player = body
		

