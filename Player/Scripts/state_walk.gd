class_name State_Walk extends State

#Will appear in the inspector on the right
@export var move_speed : float = 100.0

#We reference idle because sometimes the process in
#this current walk state returns null. We still need to return something
#When player is not walking.
@onready var idle: State = $"../Idle"


#What happens when player enters state?
func Enter() -> void:
	player.UpdateAnimation("walk")
	pass
	

#What happens when player exits state?
func Exit() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func Process( _delta : float ) -> State:
	#If any point player stops moving, we know they are not walking anymore.
	if player.direction == Vector2.ZERO:
		return idle
	player.velocity = player.direction * move_speed
	
	if player.SetDirection():
		player.UpdateAnimation("walk")
	return null
	

func Physics ( _delta : float ) -> State:
	return null

func HandleInput( event : InputEvent ) -> State:
	return null
	
