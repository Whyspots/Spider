class_name EnemyStateChase extends EnemyState

signal kill()

## The name of the idle animation
@export var anim_name : String = "walk"
@export var chase_speed : float = 150

@export_category("AI")
@export var vision_area : VisionArea
@export var state_aggro_duration : float = 5
@export var next_state : EnemyState

@onready var exclamation_mark: Sprite2D = $"../../ExclamationMark"

var _timer : float = 0.0
var _direction : Vector2
var _can_see_player : bool = false
var _finished : bool = false

## What happens when we initialize this [EnemyState]?
func init() -> void:
	if (vision_area):
		vision_area.player_entered.connect(_on_player_enter)
		vision_area.player_exited.connect(_on_player_exit)
	pass

## What happens when enemy enters [EnemyState]?
func enter() -> void:
	_timer = state_aggro_duration
	
	enemy.update_animation(anim_name)
	exclamation_mark.visible = true
	enemy.navigation_agent.navigation_finished.emit()
	_finished = false
	
	
	enemy.navigation_agent.set_target_position(PlayerManager.player.global_position)
	
	pass

## What happens when enemy exits [EnemyState]?
func exit() -> void:
	_can_see_player = false
	exclamation_mark.visible = false
	pass

## What happens during the _process update in this [EnemyState]
func process( _delta : float ) -> EnemyState:
	if _can_see_player == false:
		_timer -= _delta
		if _timer <= 0:
			_finished = true
			return next_state
	else:
		_timer = state_aggro_duration
	
	
	
	return null

## What happens during _physics_process update in this [EnemyState]?
func physics( _delta : float ) -> EnemyState:
	if (not _finished):
		enemy.navigation_agent.set_target_position(PlayerManager.player.global_position)
		
		# Destination point for the navigation
		var destination : Vector2 = enemy.navigation_agent.get_next_path_position()
		# Start point for navigation
		var start : Vector2 = $"../../CollisionShape2D".global_position

		# Get the direction needed
		enemy.set_direction((destination - start).normalized())
		enemy.update_animation(anim_name)
		enemy.translate(enemy.direction * chase_speed * _delta)
		
		return null
	
	
	return next_state

func _on_player_enter() -> void:
	_can_see_player = true
	
	state_machine.change_state(self)
	pass
	
func _on_player_exit() -> void:
	_can_see_player = false
	pass


func _on_navigation_agent_navigation_finished() -> void:
	_finished = true
	pass # Replace with function body.
