class_name State extends Node

#refers to a player object this state belongs to.
static var player : Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


#What happens when player enters state?
func Enter() -> void:
	pass
	

#What happens when player exits state?
func Exit() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func Process( _delta : float ) -> State:
	return null

func HandleInput( event : InputEvent ) -> State:
	return null
