extends CanvasLayer

func _ready() -> void:
	PlayerManager.player.visible = false
	
func _on_restart_pressed():
	#on restart, start a new game
	get_tree().change_scene_to_file("res://Levels/Level_00/level_00.tscn")

func _on_quit_pressed():
	#on quit, go to the menu
	get_tree().change_scene_to_file("res://title_scene/title_scene.tscn")
