extends Sprite2D
@onready var ray_cast = $RayCast2D
var distance: float = 150.0
@onready var shoot_web_sound: AudioStreamPlayer2D = $ShootWeb
signal hooked(hooked_position)
 
func interpolate(length, duration = 0.2):
	var tween_offset = get_tree().create_tween()
	var tween_rect_h = get_tree().create_tween()
 
	tween_offset.tween_property(self, "offset",Vector2(0,length/2.0), duration)
	tween_rect_h.tween_property(self, "region_rect", Rect2(0,0,16,length), duration)
 
func _input(event):
	if event.is_action_pressed("hook"):
		shoot_web_sound.play()
		interpolate(await check_collision(), 0.2)
		await get_tree().create_timer(0.2).timeout
		reverse_interpolate()
 
func reverse_interpolate():
	interpolate(0,0.75)
 
func check_collision():
	await get_tree().create_timer(0.1).timeout
	var collision_point
	if ray_cast.is_colliding():
		var collided_object = ray_cast.get_collider()
		var collision_parent = collided_object.get_parent()
		if collided_object is StaticBody2D and collision_parent.has_method("get_pulled_to"):
			collided_object.get_parent().get_pulled_to(self.get_parent().get_parent().position)
		elif collided_object is TileMap:
			collision_point = ray_cast.get_collision_point()
			distance = (global_position - collision_point).length()
			hooked.emit(collision_point)
	else:
		distance = 150.0
	return distance
