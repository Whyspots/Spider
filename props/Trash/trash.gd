class_name Trash extends Node2D

signal finished

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hit_box: HitBox = $HitBox


func _ready():
	hit_box.Damaged.connect( TakeDamage )
	pass
	
func TakeDamage( _damage : int ) -> void:
	hit_box.queue_free()
	topple()
		
	pass
	
func topple() -> void:
	animation_player.play("toppling")
	animation_player.animation_finished.connect(_on_animation_finished)
	
func _on_animation_finished(name: String) -> void:
	finished.emit()
