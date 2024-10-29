class_name LevelTileMap extends TileMap


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	LevelManager.change_tilemap_bounds(get_tilemap_bounds())
	
	pass # Replace with function body.

func get_tilemap_bounds() -> Array[ Vector2 ]:
	var bounds : Array[ Vector2 ] = []
	
	# Set top left bound (get_used_rect's posn is always top left)
	bounds.append(Vector2( get_used_rect().position * rendering_quadrant_size ))
	
	# Set bottom right bound (end is bottom right)
	bounds.append(Vector2( get_used_rect().end * rendering_quadrant_size ))

	
	return bounds
