class_name Player extends CharacterBody2D

# Animation variables. 

	# Establishes default direction for character in animation.
var cardinal_direction : Vector2 = Vector2.DOWN
#These are our four cardinal directions.
const DIR_4 = [ Vector2.RIGHT, Vector2.DOWN,Vector2.LEFT,Vector2.UP ]

	#Hold ctrl and drag the AnimationPlayer on the top right to create this:
@onready var animation_player: AnimationPlayer = $AnimationPlayer
	#Same thing for our sprite:
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var state_machine: PlayerStateMachine = $StateMachine




#Overall Variables (This is used both for movement and animation.

	# Vector2 is a vector type that contains two numbers, representing X and Y.
	#The x and y are defined in functions below.
var direction : Vector2 = Vector2.ZERO


#FUNCTIONS BELOW#####################################################

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Self refers to the player object.
	state_machine.Initialize(self)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	#Movement functionality############
	
	#If player presses right arrow key, direction.x will end up as 1. If press left, it will be -1.
	#If they push both it will be zero.
	#irection.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	
	#Do same for y
	#irection.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	
	#This is a better implementation with normalization.
	#If this line is not here, diagonal speed would be higher than single direction.
	direction = Vector2(Input.get_axis("left","right"),Input.get_axis("up","down")).normalized()
		
	pass

#Called every physics tick.
func _physics_process( delta ):
	
	#Built in method, it tells character body to actually move according to velocity.
	move_and_slide()
	
# The arrow means this fuction is expected to return a bool. Purpose of function:
#IF we actually change the direction, it returns true. (Make sure animation is not updated constantly)
func SetDirection() -> bool:
	#If the player is not moving, return false.
	if direction == Vector2.ZERO:
		return false
	#He explains this part in the 'addressing issues' video, of fixing moonwalk.
	var direction_id : int = int( round( ( direction).angle() / TAU * DIR_4.size() )  )
	var new_dir = DIR_4[ direction_id ]
	
	if new_dir == cardinal_direction:
		return false
		
	cardinal_direction = new_dir
	
	#Flips the scale depending on whether player is facing left or right.
	#(Because we have symmetrical character and did NOT make a separate left and right animation)
	sprite_2d.scale.x = -1 if cardinal_direction == Vector2.LEFT else 1
	
	return true
	
#Turns vector2 objects into simple directional strings.
func AnimDirection() -> String:
	if cardinal_direction == Vector2.DOWN:
		return "down"
	elif cardinal_direction == Vector2.UP:
		return "up"
	else:
		return "side"

func UpdateAnimation( state : String ) -> void:
	#State holds values such as idle, decides which animation category (ie idle,walk) to play.
	animation_player.play( state + "_" + AnimDirection())
	pass









#When done, drag the script file from the bottom left file navigator onto the "Player" 
#Item on the top right.
