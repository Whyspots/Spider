class_name Enemy extends CharacterBody2D

signal direction_changed( new_direction : Vector2 )
signal enemy_damaged()

const DIR_4 = [ Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP ]


@onready var fear_meter : ProgressBar = $FearMeter

# Fear variables
@export var max_fear : float
@export var base_fear_decay : float

var fear : float  
