extends Sprite2D

func get_pulled_to(target_position):
		await get_tree().create_timer(0.2).timeout
		var tween = get_tree().create_tween()
		print(target_position)
		tween.tween_property(self, "position", target_position, 0.75)
