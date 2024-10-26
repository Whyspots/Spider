class_name State_Idle extends State

@onready var walk: State = $"../Walk"
@onready var attack: State = $"../Attack"


#What happens when player enters state?
func Enter() -> void:
	player.UpdateAnimation("idle")
	pass
	

#What happens when player exits state?
func Exit() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func Process( _delta : float ) -> State:
	if player.direction != Vector2.ZERO:
		return walk
	player.velocity = Vector2.ZERO
	return null
	

func Physics ( _delta : float ) -> State:
	return null

func HandleInput( _event : InputEvent ) -> State:
	#If the player presses attack key Z in idle state
	if _event.is_action_pressed("attack"):
		return attack
	return null
	
