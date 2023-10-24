extends Node

func play_sound(stream: AudioStream, volume):
	var instance = AudioStreamPlayer.new()
	instance.stream = stream
	instance.volume_db = volume
	instance.finished.connect(remove_node.bind(instance))
	add_child(instance)
	instance.play()

func remove_node(instance: AudioStreamPlayer):
	instance.queue_free()
