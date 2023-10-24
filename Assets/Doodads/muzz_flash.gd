extends Node3D

@onready var parts = $GPUParticles3D
var lifetime : float

# Called when the node enters the scene tree for the first time.
func _ready():
	lifetime = parts.lifetime
	parts.emitting = true
	await get_tree().create_timer(lifetime).timeout
	queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
