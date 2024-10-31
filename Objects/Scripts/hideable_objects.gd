extends Area2D

@onready var objectdarken: AnimationPlayer = $objectdarken

# Called when the node enters the scene tree for the first time.
func _ready():
	# Connect the body_entered signal to the _on_Area2D_body_entered function
	connect("body_entered", Callable(self, "_on_Area2D_body_entered"))
	connect("body_exited", Callable(self, "_on_Area2D_body_exited"))

# Function to handle the body_entered signal
func _on_Area2D_body_entered(body):
	# Check if the body is in the "Player" group
	if body is Player:
		objectdarken.play("fade_out")

func _on_Area2D_body_exited(body):
	if body is Player:
		objectdarken.play("fade_in")
