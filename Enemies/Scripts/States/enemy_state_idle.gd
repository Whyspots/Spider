class_name EnemyStateIdle extends EnemyState

## The name of the idle animation
@export var anim_name : String = "idle"

@export_category("AI")
@export var state_duration_min : float = 0.5
@export var state_duration_max : float = 1.5
@export var next_possible_state_1 : EnemyState
@export var next_possible_state_2 : EnemyState

var _timer : float = 0.0

## What happens when we initialize this [EnemyState]?
func init() -> void:
	pass

## What happens when enemy enters [EnemyState]?
func enter() -> void:
	enemy.velocity = Vector2.ZERO
	_timer = randf_range(state_duration_min, state_duration_max)
	enemy.update_animation(anim_name)
	pass
	

## What happens when enemy exits [EnemyState]?
func exit() -> void:
	pass

## What happens during the _process update in this [EnemyState]
func process( _delta : float ) -> EnemyState:
	_timer -= _delta
	
	if _timer <= 0:
		if (randi_range(0, 1) == 0):
			return next_possible_state_2
		else:
			return next_possible_state_1
		
	return null

## What happens during _physics_process update in this [EnemyState]?
func physics( _delta : float ) -> EnemyState:
	return null
