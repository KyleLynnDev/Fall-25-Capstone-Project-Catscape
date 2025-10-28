extends Control

@onready var master       : HSlider = %Master
@onready var sfx          : HSlider = %SFX
@onready var apply_button : Button  = %ApplyButton

func _ready() -> void:
	# init from autoload
	master.value = SoundManager.get_volume_linear("Master")
	sfx.value    = SoundManager.get_volume_linear("SFX")

	# live update
	master.value_changed.connect(func(v):
		SoundManager.set_volume_linear("Master", v)
		SoundManager.save_settings()
	)
	sfx.value_changed.connect(func(v):
		SoundManager.set_volume_linear("SFX", v)
		SoundManager.save_settings()
	)

	apply_button.pressed.connect(SoundManager.save_settings)
