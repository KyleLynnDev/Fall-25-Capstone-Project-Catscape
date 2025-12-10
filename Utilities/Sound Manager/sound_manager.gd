# res://Utilities/Settings/sound_manager.gd
extends Node

# ---- Configure these to match your Audio Bus Layout ----
const BUSES := ["Master", "SFX", "Ambience"]    # add/remove as needed
const SAVE_PATH := "user://audio.cfg"

signal volumes_changed(vols: Dictionary)

# ---------- Audio Players ----------
var ambient: AudioStreamPlayer

# SFX system (2D pooled players for overlapping one-shots)
const SFX_POOL_SIZE := 8
var sfx_pool: Array[AudioStreamPlayer] = []
var _sfx_index := 0

# ---------- Ready ----------
func _ready() -> void:
	# --- Ambient player setup ---
	ambient = AudioStreamPlayer.new()
	ambient.bus = "Ambience"
	add_child(ambient)

	# --- SFX pool setup ---
	for i in SFX_POOL_SIZE:
		var p := AudioStreamPlayer.new()
		p.bus = "SFX"
		add_child(p)
		sfx_pool.append(p)

	# --- Load saved settings ---
	load_settings()
	_emit()  # notify UI of current values

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

# ---------- Volume / Mute API ----------
# Volumes are linear 0..1 for UI friendliness; converted to dB internally.

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

# ---------- Playback Helpers ----------

# Ambient looped music/background
func play_ambient(stream: AudioStream, loop: bool = true) -> void:
	if stream == null:
		return
	if "loop" in stream:  # only for stream types that expose loop
		stream.loop = loop
	ambient.stream = stream
	ambient.play()

func stop_ambient() -> void:
	ambient.stop()

# ---------- NEW: SFX Playback ----------
# Plays a short 2D sound on the SFX bus (footsteps, UI clicks, etc.)
func play_sfx(stream: AudioStream, pitch: float = 1.0, volume_linear: float = 1.0) -> void:
	if stream == null or sfx_pool.is_empty():
		return

	var player := sfx_pool[_sfx_index]
	_sfx_index = (_sfx_index + 1) % SFX_POOL_SIZE

	player.stop()
	player.stream = stream
	player.pitch_scale = pitch
	player.volume_db = linear_to_db(clamp(volume_linear, 0.0, 1.0))
	player.play()

# Optional helper for random pick among variants
func play_sfx_from(streams: Array, pitch_jitter: float = 0.04, volume_linear: float = 1.0) -> void:
	if streams.is_empty():
		return
	var s: AudioStream = streams[randi() % streams.size()]
	play_sfx(s, 1.0 + randf_range(-pitch_jitter, pitch_jitter), volume_linear)
