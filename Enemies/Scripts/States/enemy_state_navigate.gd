class_name EnemyStateNavigate extends EnemyState

## The name of the idle animation
@export var anim_name : String = "walk"
@export var navigate_speed : float = 20.0

@export_category("AI")
@export var next_state : EnemyState

var _finished = false
var _room_index = 0
var _room_iteration_constant = 1
var navigation_rooms : Array[String] = []

## What happens when we initialize this [EnemyState]?
func init() -> void:
	navigation_rooms = enemy.navigation_rooms
	pass

## What happens when enemy enters [EnemyState]?
func enter() -> void:
	enemy.navigate_to_room(navigation_rooms[_room_index])
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
		enemy.translate(enemy.direction * navigate_speed * delta)
		
		return null
	
	_finished = false
	
	return next_state

func _on_navigation_agent_navigation_finished() -> void:
	_finished = true
	
	pass # Replace with function body.


func _on_navigation_agent_target_reached() -> void:
	# If at end of navigation path, reverse the path
	if (_room_index == navigation_rooms.size() - 1):
		_room_iteration_constant = -1
	
	# If at the beginning of the nav path, reset to not reverse
	if (_room_index == 0):
		_room_iteration_constant = 1
		
	_room_index += _room_iteration_constant
	
	pass # Replace with function body.
