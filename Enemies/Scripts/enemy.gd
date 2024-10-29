class_name Enemy extends CharacterBody2D

signal direction_changed( new_direction : Vector2 )
signal enemy_damaged()
signal enemy_fear_instilled()

const DIR_4 = [ Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP ]


@onready var fear_meter : FearMeter = $FearMeter

# Fear variables
@export_group("Fear")
## The maximum fear value of this [Enemy]
@export var max_fear : float
## (fear / s) The base decay rate for fear on this [Enemy] 
@export var fear_decay : float
## (s / fear) The number of seconds that fear decay will be paused for each unit of
## increased fear. It is the ratio seconds : fear and is unit
@export var decay_ratio : float
## (s) The amount of time that the [FearMeter] will remain full before decaying
## again after hitting the maximum. Acts as a window for the [Player]
## to kill the [Enemy] 
@export var kill_window : float

var cardinal_direction : Vector2 = Vector2.DOWN
var direction : Vector2 = Vector2.ZERO
var player : Player
var invulnerable : bool = false

@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var sprite : Sprite2D = $Sprite2D
#@onready var hit_box : HitBox = $HitBox
@onready var state_machine : EnemyStateMachine = $EnemyStateMachine

func _ready() -> void:
	state_machine.initialize(self)
	player = PlayerManager.player 
	
	pass
	
func _process(_delta: float) -> void:
	pass
	
func _physics_process(_delta: float) -> void:
	move_and_slide()
	
## Taken from player's set_direction, with param for direction setting
func set_direction(_new_direction : Vector2) -> bool:
	direction = _new_direction
	if direction == Vector2.ZERO:
		return false
	
	var direction_id : int = int( round( ( direction).angle() / TAU * DIR_4.size() )  )
	var new_dir = DIR_4[ direction_id ]
	
	if new_dir == cardinal_direction:
		return false
		
	cardinal_direction = new_dir
	direction_changed.emit( new_dir )
	sprite.scale.x = -1 if cardinal_direction == Vector2.LEFT else 1
	
	return true

func update_animation(state : String) -> void:
	animation_player.play(state + "_" + anim_direction())
	pass
	
func anim_direction() -> String:
	if cardinal_direction == Vector2.DOWN:
		return "down"
	elif cardinal_direction == Vector2.UP:
		return "up"
	else:
		return "side"
