class_name Player extends CharacterBody2D

# Movement variables. 

	#The velocity modifyer.
var move_speed : float = 100.0

# Animation variables. 

	# Establishes default direction for character in animation.
var cardinal_direction : Vector2 = Vector2.DOWN

	#Establishes the default state of the character.
var state : String = "idle"

	#Hold ctrl and drag the AnimationPlayer on the top right to create this:
@onready var animation_player: AnimationPlayer = $AnimationPlayer
	#Same thing for our sprite:
@onready var sprite_2d: Sprite2D = $Sprite2D




#Overall Variables (This is used both for movement and animation.

	# Vector2 is a vector type that contains two numbers, representing X and Y.
	#The x and y are defined in functions below.
var direction : Vector2 = Vector2.ZERO


#FUNCTIONS BELOW#####################################################

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	#Movement functionality############
	
	#If player presses right arrow key, direction.x will end up as 1. If press left, it will be -1.
	#If they push both it will be zero.
	direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	
	#Do same for y
	direction.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	
	#Velocity is an inherent property for characterbody2d.
	velocity = direction * move_speed
	
	#Animation functionality#############
	#If either state OR direction changes, update the animation.
	if SetState() == true || SetDirection() == true:
		UpdateAnimation()
		
	pass

#Called every physics tick.
func _physics_process( delta ):
	
	#Built in method, it tells character body to actually move according to velocity.
	move_and_slide()
	
# The arrow means this fuction is expected to return a bool. Purpose of function:
#IF we actually change the direction, it returns true. (Make sure animation is not updated constantly)
func SetDirection() -> bool:
	var new_dir : Vector2 = cardinal_direction
	#If the player is not moving, return false.
	if direction == Vector2.ZERO:
		return false
		
	#What do we do if the player is pressing two movement keys at the same time?
	if direction.y == 0:
		#If the input is like "slightly left" ie -0.5, then we categorize it as pure left.
		#Vector2.LEFT looks like: Vector2(-1,0).
		#If our game is ONLY keyboard, this step is not required. More of joystick consideration.
		new_dir = Vector2.LEFT if direction.x < 0 else Vector2.RIGHT
	elif direction.x == 0:
		new_dir = Vector2.UP if direction.y < 0 else Vector2.DOWN
		
	if new_dir == cardinal_direction:
		return false
		
	cardinal_direction = new_dir
	
	#Flips the scale depending on whether player is facing left or right.
	#(Because we have symmetrical character and did NOT make a separate left and right animation)
	sprite_2d.scale.x = -1 if cardinal_direction == Vector2.LEFT else 1
	
	return true

#IF we actually change the state, it returns true.
func SetState() -> bool:
	#If we are not moving, the state is idle. else, it is walk.
	var new_state : String = "idle" if direction == Vector2.ZERO else "walk"
	
	if new_state == state:
		return false
		
	state = new_state
	return true
	
#Turns vector2 objects into simple directional strings.
func AnimDirection() -> String:
	if cardinal_direction == Vector2.DOWN:
		return "down"
	elif cardinal_direction == Vector2.UP:
		return "up"
	else:
		return "side"

func UpdateAnimation() -> void:
	#State holds values such as idle, decides which animation category (ie idle,walk) to play.
	animation_player.play( state + "_" + AnimDirection())
	pass









#When done, drag the script file from the bottom left file navigator onto the "Player" 
#Item on the top right.
