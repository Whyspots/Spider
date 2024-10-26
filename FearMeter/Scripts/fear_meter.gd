extends ProgressBar

@onready var timer = $Timer
@onready var damage_bar = $DamageBar

'''
The Fear Bar representing how much fear the npc is experiencing. 
Consists of a Fear Meter and a Damage Bar. 
The damage bar ui increases when the fear increases. 
The fear meter ui follows suit with a small delay. 
Any decrease in fear results in an instant change for both the damage and fear bars. 
'''

var fear:float = 0 : set = _update_fear

# Initializes a fear bar with value 0 and a given max_value
func init_fear_bar(_max:float):
	value = 0
	damage_bar.value = 0
	max_value = _max
	damage_bar.max_value = _max

# Set fear to new value
func _update_fear(new_fear):
	var prev_fear:int = fear
	fear = max(0, new_fear)
	damage_bar.value = fear
	
	# Remove the ui from view if fear <= 0
	if fear <= 0:
		queue_free()
	
	# If fear increases, lag increase. If fear decreases, instantly decrease.
	if fear > prev_fear:
		timer.start()
	else:
		value = fear

# When the previously set timer reaches 0, 
# the fear meter UI catches up with the damage bar
func _on_timer_timeout():
	value = fear
