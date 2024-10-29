class_name EnemyState extends Node

## Stores a reference to the enemy that this state belongs to
var enemy : Enemy
var state_machine : EnemyStateMachine

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
func physics( _delta : float ) -> EnemyState:
	return null
