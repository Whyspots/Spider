class_name Level extends Node2D

@onready var music_player: AudioStreamPlayer = $MusicPlayer
@onready var scientist: Enemy = $Scientist

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.y_sort_enabled = true
	PlayerManager.set_as_parent( self )
	LevelManager.level_load_started.connect( _free_level )
	
	scientist.kill.connect(_death_screen)

# Free the level on exit (remove player as child to keep the player existing)
func _free_level() -> void:
	PlayerManager.unparent_player( self )
	queue_free()

func _death_screen() -> void:
	_free_level()
	LevelManager.load_new_level("res://gameover/gameover.tscn", Vector2.ZERO)
