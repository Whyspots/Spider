extends CanvasLayer

@export_file() var restart_level : String

func _ready() -> void:
	PlayerManager.player.visible = false
	
func _on_restart_pressed():
	#on restart, start a new game
	LevelManager.load_new_level("res://Levels/Level_00/level_00.tscn", Vector2.ZERO)
	PlayerManager.player.visible = true

func _on_quit_pressed():
	#on quit, go to the menu
	LevelManager.load_new_level("res://title_scene/title_scene.tscn", Vector2.ZERO)
