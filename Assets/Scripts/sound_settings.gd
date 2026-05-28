extends Control

@onready var master_vol_slider: HSlider = $SoundSetBackground/MasterVol_lbl/MasterVolSlider
@onready var sound_effects_slider: HSlider = $SoundSetBackground/SoundEffectsVol_lbl/SoundEffectsSlider
@onready var music_slider: HSlider = $SoundSetBackground/MusicVol_lbl/MusicSlider

func _ready() -> void:
	update_sound_settings()
	master_vol_slider.value = GlobalVariables.master_vol
	sound_effects_slider.value = GlobalVariables.sound_effects_vol
	music_slider.value = GlobalVariables.music_vol

func _on_master_vol_slider_value_changed(value: float) -> void:
	ConfigFileHandler.save_sound_settings("master_vol", master_vol_slider.value)
	update_sound_settings()


func _on_sound_effects_slider_value_changed(value: float) -> void:
	ConfigFileHandler.save_sound_settings("sound_effects_vol", sound_effects_slider.value)
	update_sound_settings()


func _on_music_slider_value_changed(value: float) -> void:
	ConfigFileHandler.save_sound_settings("music_vol", music_slider.value)
	update_sound_settings()

func _on_back_button_up() -> void:
	update_sound_settings()
	queue_free()

func update_sound_settings():
	GlobalVariables.update_sound_settings()
