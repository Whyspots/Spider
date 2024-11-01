class_name Trash extends Node2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var sprite_2d_toppled: Sprite2D = $Sprite2D_toppled
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready():
	$HitBox.Damaged.connect( TakeDamage )
	sprite_2d_toppled.visible = false
	pass
	
func TakeDamage( _damage : int ) -> void:
	topple()
	pass
	
func topple() -> void:
	animation_player.play("toppling")
	animation_player.animation_finished.connect(_on_animation_finished)
	
func _on_animation_finished(name: String) -> void:
	if name == "toppling":
		sprite_2d.visible = false
		sprite_2d_toppled.visible = true
		
func get_pulled_to(target_position):
		await get_tree().create_timer(0.2).timeout
		var tween = get_tree().create_tween()
		print(target_position)
		tween.tween_property(self, "position", target_position, 0.75)
