extends ProgressBar

@onready var timer = $Timer
@onready var damage_bar = $DamageBar



var fear = 0 : set = _update_fear

func init_fear_bar(_max:float):
	value = 0
	max_value = _max

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

func _on_timer_timeout():
	value = fear
