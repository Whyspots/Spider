extends Node


const PLAYER = preload("res://Player/player.tscn")

var player : Player
var player_spawned : bool = false


# Callable onready
func _ready() -> void:
	add_player_instance()
	

# Adds a new player instance to the node calling this function
func add_player_instance() -> void:
	player = PLAYER.instantiate()
	add_child( player )
	pass

# Sets the player's position to the input vector
func set_player_position( _new_pos : Vector2) -> void:
	player.global_position = _new_pos
	pass

func set_as_parent( _p : Node2D ) -> void:
	if player.get_parent():
		player.get_parent().remove_child( player )
	_p.add_child( player )
	
func unparent_player( _p : Node2D) -> void:
	_p.remove_child( player )
