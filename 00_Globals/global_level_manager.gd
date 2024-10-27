extends Node

# Signals to return info on the status of loading a level
signal level_load_started
signal level_loaded

# Initial player spawn offset
var position_offset : Vector2

func _ready() -> void:
	await get_tree().process_frame
	level_loaded.emit()

func load_new_level(
		level_path : String,
		_position_offset : Vector2
) -> void:
	
	get_tree().paused = true
	position_offset = _position_offset
	
	await SceneTransition.fade_out()
	
	level_load_started.emit()
	
	get_tree().change_scene_to_file( level_path )
	
	await SceneTransition.fade_in()
	
	get_tree().paused = false
	
	level_loaded.emit()
	
	pass
	
	 
