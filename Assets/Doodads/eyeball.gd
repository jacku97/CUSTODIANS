extends CharacterBody3D

var player

func _ready():
	var p = get_tree().get_nodes_in_group("player")
	player = p[0]
	
func _process(delta):
	look_at(player.global_transform.origin, Vector3.UP)
