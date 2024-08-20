extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$VBoxContainer/MasterSlider.value=db_to_linear(AudioServer.get_bus_volume_db(0))
	$VBoxContainer/SFXSlider.value=db_to_linear(AudioServer.get_bus_volume_db(1))
	$VBoxContainer/MusicSlider.value=db_to_linear(AudioServer.get_bus_volume_db(2))
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float):
	pass


func _on_music_slider_mouse_exited():
	release_focus()


func _on_sfx_slider_mouse_exited():
	release_focus()


func _on_master_slider_mouse_exited():
	release_focus()
