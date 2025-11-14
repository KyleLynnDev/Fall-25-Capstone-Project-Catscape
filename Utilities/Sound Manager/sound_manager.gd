# res://Utilities/Settings/sound_manager.gd
extends Node

# ---- Configure these to match your Audio Bus Layout ----
const BUSES := ["Master", "SFX", "Ambience"]    # add/remove as needed
const SAVE_PATH := "user://audio.cfg"

signal volumes_changed(vols: Dictionary)

var ambient: AudioStreamPlayer

func _ready() -> void:
	# Your existing ambient player
	ambient = AudioStreamPlayer.new()
	ambient.bus = "Ambience"            # must exist in your Bus Layout
	add_child(ambient)

	# Load saved volumes/mutes at boot
	load_settings()
	_emit()  # let any UI know current values

# ---------- Helpers ----------
func _bus(name: String) -> int:
	return AudioServer.get_bus_index(name)

func _emit() -> void:
	var d := {}
	for b in BUSES:
		d[b] = {
			"vol": get_volume_linear(b),
			"mute": is_muted(b)
		}
	emit_signal("volumes_changed", d)

# ---------- Public API called by UI/game ----------
# Volumes are linear 0..1 in the API (UI-friendly), converted to dB internally.

func set_volume_linear(bus_name: String, lin: float) -> void:
	lin = clamp(lin, 0.0, 1.0)
	AudioServer.set_bus_volume_db(_bus(bus_name), linear_to_db(lin))
	_emit()

func get_volume_linear(bus_name: String) -> float:
	return db_to_linear(AudioServer.get_bus_volume_db(_bus(bus_name)))

func set_mute(bus_name: String, mute: bool) -> void:
	AudioServer.set_bus_mute(_bus(bus_name), mute)
	_emit()

func is_muted(bus_name: String) -> bool:
	return AudioServer.is_bus_mute(_bus(bus_name))

func save_settings() -> void:
	var cfg := ConfigFile.new()
	for b in BUSES:
		cfg.set_value("audio", "%s_volume" % b, get_volume_linear(b))
		cfg.set_value("audio", "%s_mute" % b, is_muted(b))
	cfg.save(SAVE_PATH)

func load_settings() -> void:
	var cfg := ConfigFile.new()
	if cfg.load(SAVE_PATH) != OK:
		return
	for b in BUSES:
		if cfg.has_section_key("audio", "%s_volume" % b):
			set_volume_linear(b, float(cfg.get_value("audio", "%s_volume" % b)))
		if cfg.has_section_key("audio", "%s_mute" % b):
			set_mute(b, bool(cfg.get_value("audio", "%s_mute" % b)))

# ---------- Your existing playback helpers ----------
func play_ambient(stream: AudioStream, loop: bool = true) -> void:
	if stream == null:
		return
	if "loop" in stream:  # only for stream types that expose loop
		stream.loop = loop
	ambient.stream = stream
	ambient.play()

func stop_ambient() -> void:
	ambient.stop()
