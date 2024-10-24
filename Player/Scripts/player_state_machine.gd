class_name PlayerStateMachine extends Node

#This variable stores an array of State objects.
var states : Array[ State ]

var prev_state : State
var current_state : State

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#Process requires a delta and returns either null or a state.
	#This line notifies the machine if state changed or not.
	ChangeState( current_state.Process( delta )  )
	pass
	
func _physics_process(delta: float) -> void:
	#Process requires a delta and returns either null or a state.
	#This line notifies the machine if state changed or not.
	ChangeState( current_state.Process( delta )  )
	pass

func Initialize( _player : Player ) -> void:
	states = []
	#examine each child node of StateMachine.
	for c in get_children():
		#If this c is a State object, it is added to states array.
		if c is State:
			states.append(c)
	if states.size() > 0:
		#Set the player to whatever player object is passed in.
		states[0].player = _player
		ChangeState( states[0] )
		process_mode = Node.PROCESS_MODE_INHERIT
	

func ChangeState( new_state : State ) -> void:
	#Make sure the state we pass in is valid,Make sure the state we pass in is DIFFERENT than current.
	if new_state == null || new_state == current_state:
		return
	if current_state :
		current_state.Exit()
	
	prev_state = current_state
	current_state = new_state
	#Does whatever the current state behavior is
	current_state.Enter()
