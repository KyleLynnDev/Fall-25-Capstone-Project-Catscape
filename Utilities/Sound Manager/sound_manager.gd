extends Node

var ambient: AudioStreamPlayer

func _ready() -> void:
	ambient = AudioStreamPlayer.new()
	ambient.bus = "Ambience"  # make sure this bus exists in your Bus Layout
	add_child(ambient)

func play_ambient(stream: AudioStream, loop: bool = true) -> void:
	if stream == null: return
	if "loop" in stream:
		stream.loop = loop
	ambient.stream = stream
	ambient.play()

func stop_ambient() -> void:
	ambient.stop()
