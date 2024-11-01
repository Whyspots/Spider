extends Area2D

signal kill()

func _ready() -> void:
	body_entered.connect(_on_body_enter)
	pass

func _on_body_enter(_b : Node2D) -> void:
	if (_b is Player):
		kill.emit()
		
	pass
	
