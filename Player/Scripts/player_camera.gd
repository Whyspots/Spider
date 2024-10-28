class_name PlayerCamera extends Camera2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Connect bounds change to update camera limits
	LevelManager.tilemap_bounds_changed.connect( update_limits )
	
	# Ensure this runs on initial run through via brute force
	update_limits( LevelManager.current_tilemap_bounds )
	
	pass # Replace with function body.

# Set the camera limits to the given input bounds
## Format for bounds: 2-element array of Vector2
func update_limits( bounds : Array[ Vector2 ]) -> void:
	if (bounds != []):
		limit_left = int( bounds[0].x )
		limit_right = int( bounds[1].x )
		limit_top = int( bounds[0].y )
		limit_bottom = int( bounds[1].y )
	
	pass
