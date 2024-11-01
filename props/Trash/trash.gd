class_name Trash extends Node2D

signal finished

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hit_box: HitBox = $HitBox
@export var fear_radius = 250
@export var fear = 25


func _ready():
	hit_box.Damaged.connect( TakeDamage )
	pass
	
func TakeDamage( _damage : int ) -> void:
	hit_box.queue_free()
	topple()
		
	pass

func apply_fear_to_nearby_enemies():
	var enemies = get_tree().get_nodes_in_group("Enemies")
	for enemy in enemies:
		if enemy and enemy.has_method("get_scared"):
			var distance_to_enemy = global_position.distance_to(enemy.global_position)
			if distance_to_enemy <= fear_radius:
				enemy.get_scared(fear)

func topple() -> void:
	animation_player.play("toppling")
	animation_player.animation_finished.connect(_on_animation_finished)
	apply_fear_to_nearby_enemies()
	
func _on_animation_finished(name: String) -> void:
	finished.emit()
		
func get_pulled_to(target_position):
		await get_tree().create_timer(0.2).timeout
		var tween = get_tree().create_tween()
		print(target_position)
		tween.tween_property(self, "position", target_position, 0.75)
