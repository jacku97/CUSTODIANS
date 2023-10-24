extends BaseState

@export var sound : AudioStream
@export var sound2: AudioStream

func enter() -> void:
	player.velocity.y = 8
	AudioManager.play_sound(sound, 0)
	#AudioManager.play_sound(sound2, -5)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func physics_process(delta: float) -> int:
	player.move_and_slide()
	return State.Fall
	return State.Null
