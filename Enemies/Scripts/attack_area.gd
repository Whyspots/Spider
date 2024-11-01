extends Area2D

func _ready() -> void:
	body_entered.connect(_on_body_enter)
	pass

func _on_body_enter(_b : Node2D) -> void:
	if (_b is Player):
		LevelManager.load_new_level("res://gameover/gameover.tscn", Vector2.ZERO)
	pass
	
