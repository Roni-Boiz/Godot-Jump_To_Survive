extends Button

func _on_button_up() -> void:
	get_tree().paused = false
	PlayerData.score = 0
	get_tree().reload_current_scene()

