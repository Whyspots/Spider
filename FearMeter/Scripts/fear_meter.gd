extends ProgressBar

@onready var timer = $Timer
@onready var damage_bar = $DamageBar
@onready var decay_delay_timer: Timer = $DecayDelayTimer

@onready var animation_player: AnimationPlayer = $AnimationPlayer


'''
The Fear Bar representing how much fear the npc is experiencing. 
Consists of a Fear Meter and a Damage Bar. 
The damage bar ui increases when the fear increases. 
The fear meter ui follows suit with a small delay. 
Any decrease in fear results in an instant change for both the damage and fear bars. 
'''

var fear : float = 0 : set = _update_fear
var base_decay_rate : float
var current_decay_rate : float
var decay_scale : float
var kill_window : float

func _ready() -> void:
	self.visible = false

# Happens every frame
func _process(delta: float) -> void:
	if (fear > 0):
		fear -= current_decay_rate * delta
	else:
		fear = 0

## Initializes a fear bar
## _max: The maximum value for the fear bar 
## _rate: The base decay rate for the fear (fear/s)
## _fear_gain_to_delay_ratio: The ratio of fear : time when pausing decay
##                            due to an instance of fear (s/fear)
## _kill_window: The time that the fear bar stays full after hitting max (s)
func init_fear_bar(
	_max:float, 
	_rate:float, 
	_fear_gain_to_delay_ratio:float,
	_kill_window:float
	):
	value = 0
	damage_bar.value = 0
	max_value = _max
	damage_bar.max_value = _max
	base_decay_rate = _rate
	current_decay_rate = 0
	decay_scale = _fear_gain_to_delay_ratio
	kill_window = _kill_window

# Set fear to new value
func _update_fear(new_fear):
	var prev_fear:int = fear
	# Cap new fear to maximum
	if (new_fear > max_value):
		new_fear = max_value
	
	handle_decay_pause(new_fear, prev_fear)
	
	fear = max(0, new_fear) # Ensure fear is nonnegative
	damage_bar.value = fear 
	
	# Remove the ui from view if fear <= 0
	if fear <= 0:
		fade_bar() 
	else: 
		self.visible = true
	
	# If fear increases, lag increase. If fear decreases, instantly decrease.
	if fear > prev_fear:
		timer.start()
	else:
		value = fear

# Handle decay pausing based on change in fear
func handle_decay_pause(new_fear : float, prev_fear : float):
	# If fear hits the limit, stop adding fear and kill within given window
	if (new_fear >= max_value):
		decay_delay_timer.start(kill_window)
	# If a positive amount of fear was instilled
	elif (new_fear > prev_fear):
		# Temporarily pause the fear decay based on amount of fear and scale
		var time_to_pause : float = (new_fear - prev_fear) * decay_scale
		# If decay not currently paused, pause it
		if (decay_delay_timer.is_stopped()):
			decay_delay_timer.start(time_to_pause)
		else: # If decay paused, add time to pause
			var current : float = decay_delay_timer.get_time_left()
			decay_delay_timer.set_wait_time(time_to_pause + current)

# Processes fading the bar out when it reaches zero
func fade_bar():
	animation_player.play()

# When the previously set timer reaches 0, 
# the fear meter UI catches up with the damage bar
func _on_timer_timeout():
	value = fear

func _on_decay_delay_timer_timeout() -> void:
	current_decay_rate = base_decay_rate

# Checks when the animation finishes to make the bar invisible
func _on_fade_animation_finished(anim_name: StringName) -> void:
	self.visible = false
