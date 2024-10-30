class_name State_Attack extends State

#Are we still attacking?
var attacking : bool = false

@export var attack_sound : AudioStream
@onready var audio: AudioStreamPlayer2D = $"../../Audio/AudioStreamPlayer2D"

@onready var walk: State = $"../Walk"
@onready var idle: State = $"../Idle"

@onready var hurt_box: HurtBox = $"../../Interactions/HurtBox"



#ctrl drag the AnimationPlayer in for player attack animation
@onready var animation_player : AnimationPlayer = $"../../AnimationPlayer"

#ctrl drag in sword swoosh fx animation
@onready var fx_anim : AnimationPlayer = $"../../Sprite2D/AttackEffectSprite/AnimationPlayer"

#Slider adjustible. first number is min, second is max, third is increment size.
#Purpose of this is to make player walk slower when attacking.
#again export variables make it so that you can see it on inspect panel when
#You click on corresponding node.
@export_range(1 , 20 , 0.5) var decelerate_speed : float = 10.0


#What happens when player enters state?
func Enter() -> void:
	#Configure the players attack animation.
	player.UpdateAnimation("attack")
	
	#Configure the sword swoop fx's animation.
	fx_anim.play("attack_" + player.AnimDirection() )
	
	#Once the animation finishes playing.... link the signal to our endattack function.
	animation_player.animation_finished.connect( EndAttack )
	
	#Play attack audio when attacking
	audio.stream = attack_sound
	#Randomize the pitch for fun each attack
	audio.pitch_scale = randf_range(8.9, 1.1)
	audio.play()
	
	#Set attacking to true 
	attacking = true
	
	await get_tree().create_timer( 0.075 ).timeout
	hurt_box.monitoring = true
	pass
	

#What happens when player exits state?
func Exit() -> void:
	#Disconnect the signal when we are not in attack state. set attack state to false upon exit.
	animation_player.animation_finished.disconnect( EndAttack )
	attacking = false
	hurt_box.monitoring = false
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func Process( _delta : float ) -> State:
	#Subtract a certain amount of speed when you attack while walking.
	player.velocity -= player.velocity * decelerate_speed * _delta
	
	#If attack animation ends:
	if attacking == false:
		if player.direction == Vector2.ZERO:
			return idle
		else:
			return walk
		
	return null
	

func Physics ( _delta : float ) -> State:
	return null

func HandleInput( _event : InputEvent ) -> State:
	return null
	

func EndAttack( _newAnimName : String ) -> void:
	attacking = false
