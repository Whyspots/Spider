class_name EnemyStateSearch extends EnemyState

## The name of the idle animation
@export var anim_name : String = "idle"

@export_category("AI")
@export var state_duration_min : float = 4
@export var state_duration_max : float = 6
@export var look_time_min : float = 0.5
@export var look_time_max : float = 1
@export var next_state : EnemyState

var _timer : float = 0.0
var _look_timer : float = 0.0
var directions = enemy.DIR_4 

@onready var question_mark: Sprite2D = $"../../QuestionMark"

## What happens when we initialize this [EnemyState]?
func init() -> void:
	pass

## What happens when enemy enters [EnemyState]?
func enter() -> void:
	
	enemy.velocity = Vector2.ZERO
	_timer = randf_range(state_duration_min, state_duration_max)
	_look_timer = randf_range(look_time_min, look_time_max)
	
	enemy.update_animation(anim_name)
	pass
	

## What happens when enemy exits [EnemyState]?
func exit() -> void:
	question_mark.visible = false
	pass

## What happens during the _process update in this [EnemyState]
func process( _delta : float ) -> EnemyState:
	_timer -= _delta
	_look_timer -= _delta
	
	if (_look_timer <= 0):
		enemy.set_direction(directions[randi_range(0,3)])
		_look_timer = randf_range(look_time_min, look_time_max)
	
	enemy.update_animation(anim_name)
	
	if _timer <= 0:
		return next_state
	
	return null

## What happens during _physics_process update in this [EnemyState]?
func physics( _delta : float ) -> EnemyState:
	return null
