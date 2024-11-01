class_name EnemyStateInvestigate extends EnemyState

## The name of the idle animation
@export var anim_name : String = "walk"
@export var investigate_speed : float = 100

@export_category("AI")
@export var next_state : EnemyState

var player : Player = PlayerManager.player
var _finished = false

## What happens when we initialize this [EnemyState]?
func init() -> void:
	
	pass

## What happens when enemy enters [EnemyState]?
func enter() -> void:
	
	pass

## What happens when enemy exits [EnemyState]?
func exit() -> void:
	pass

## What happens during the _process update in this [EnemyState]
func process( _delta : float ) -> EnemyState:
	
	return null

## What happens during _physics_process update in this [EnemyState]?
func physics( delta : float ) -> EnemyState:
	if (not _finished):
		# Destination point for the navigation
		var destination : Vector2 = enemy.navigation_agent.get_next_path_position()
		# Start point for navigation
		var start : Vector2 = $"../../CollisionShape2D".global_position

		# Get the direction needed
		enemy.set_direction((destination - start).normalized())
		enemy.update_animation(anim_name)
		enemy.translate(enemy.direction * investigate_speed * delta)
		
		return null
	
	_finished = false
	
	return next_state

func _on_navigation_agent_navigation_finished() -> void:
	_finished = true
	
	pass # Replace with function body.
