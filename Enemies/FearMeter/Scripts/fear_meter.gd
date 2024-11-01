## This class is a meter that extends [ProgressBar] and
## keeps track of and regulates an enemy's fear levels
class_name FearMeter extends ProgressBar

@onready var _timer = $Timer
@onready var _damage_bar = $DamageBar
@onready var _decay_delay_timer: Timer = $DecayDelayTimer

@onready var _animation_player: AnimationPlayer = $AnimationPlayer
@onready var _fear_meter_full: AudioStreamPlayer2D = $FearMeterFull
var has_played_full_sound: bool = false


'''
The Fear Bar representing how much fear the npc is experiencing. 
Consists of a Fear Meter and a Damage Bar. 
The damage bar ui increases when the fear increases. 
The fear meter ui follows suit with a small delay. 
Any decrease in fear results in an instant change for both the damage and fear bars. 
'''

## The fear value of this [FearMeter]
var fear : float = 0 : set = _update_fear
## The base fear decay rate of this [FearMeter]
var base_decay_rate : float
## The current decay rate for this [FearMeter]
var current_decay_rate : float
## The scaling for how long fear decay will be paused when added
var decay_scale : float
## The time during which the enemy will be vulnerable
var kill_window : float
## Is the kill window active?
var is_vulnerable : bool = false

func _ready() -> void:
	self.visible = false

# Happens every frame
func _process(delta: float) -> void:
	if (fear > 0):
		fear -= current_decay_rate * delta
	else:
		fear = 0

## Initializes a [FearMeter] [br]
## [param _max]: The maximum value for the fear bar [br]
## [param _rate]: The base decay rate for the fear (fear/s) [br]
## [param _fear_gain_to_delay_ratio]: The ratio of fear : time when pausing decay
##                            due to an instance of fear (s/fear) [br]
## [param _kill_window]: The time that the fear bar 
##                       stays full after hitting max (s) [br]
func init_fear_bar(
	_max:float, 
	_rate:float, 
	_fear_gain_to_delay_ratio:float,
	_kill_window:float
	):
	value = 0
	_damage_bar.value = 0
	max_value = _max
	_damage_bar.max_value = _max
	base_decay_rate = _rate
	current_decay_rate = 0
	decay_scale = _fear_gain_to_delay_ratio
	kill_window = _kill_window

## Set fear to new value
func _update_fear(new_fear):
	var prev_fear:float = fear
	# Cap new fear to maximum
	if (new_fear >= max_value):
		new_fear = max_value
		if not has_played_full_sound:
			_fear_meter_full.play()
			has_played_full_sound = true
	else: 
		has_played_full_sound = false
	
	if (new_fear > prev_fear + 0.001 or new_fear < prev_fear - 0.001 ):
		_handle_decay_pause(new_fear, prev_fear)
	
	fear = max(0, new_fear) # Ensure fear is nonnegative
	_damage_bar.value = fear 
	
	# Remove the ui from view if fear <= 0
	if fear <= 0 and prev_fear > 0:
		fade_out()
	elif fear > 0: 
		self.visible = true
		if (prev_fear == 0):
			fade_in()

	# If fear increases, lag increase. If fear decreases, instantly decrease.
	if fear > prev_fear:
		_timer.start()
	elif fear < prev_fear:
		value = fear

# Handle decay pausing based on change in fear
func _handle_decay_pause(new_fear : float, prev_fear : float) -> void:
	# If fear hits the limit, stop adding fear and kill within given window
	if (new_fear >= max_value):
		_animation_player.play("bar_full")
		is_vulnerable = true
		_decay_delay_timer.stop()
		_decay_delay_timer.start(kill_window)
		current_decay_rate = 0
	# If a positive amount of fear was instilled
	elif (new_fear > prev_fear):
		# Temporarily pause the fear decay based on amount of fear and scale
		var time_to_pause : float = (new_fear - prev_fear) * decay_scale
		# If decay not currently paused, pause it
		if (_decay_delay_timer.is_stopped()):
			current_decay_rate = 0
			_decay_delay_timer.start(time_to_pause)
		else: # If decay paused, add time to pause
			var current : float = _decay_delay_timer.get_time_left()
			_decay_delay_timer.stop()
			_decay_delay_timer.start(time_to_pause + current)
			current_decay_rate = 0

## Play a fade out animation on the [FearMeter] and make it invisible
func fade_out():
	_animation_player.play("fade_out")
	await _animation_player.animation_finished
	self.visible = false

## Play a fade in animation on the [FearMeter] and make it visible
func fade_in():
	self.visible = true
	_animation_player.play("fade_in")
	await _animation_player.animation_finished

# When the previously set timer reaches 0, 
# the fear meter UI catches up with the damage bar
func _on_timer_timeout():
	value = fear

func _on_decay_delay_timer_timeout() -> void:
	if (_animation_player.current_animation == "bar_full"):
		is_vulnerable = false
		_animation_player.stop()
	
	current_decay_rate = base_decay_rate
