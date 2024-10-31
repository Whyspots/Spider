class_name Trash extends Node2D

signal finished

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready():
	$HitBox.Damaged.connect( TakeDamage )
	pass
	
func TakeDamage( _damage : int ) -> void:
	topple()
	pass
	
func topple() -> void:
	animation_player.play("toppling")
	animation_player.animation_finished.connect(_on_animation_finished)
	
func _on_animation_finished(name: String) -> void:
	finished.emit()
