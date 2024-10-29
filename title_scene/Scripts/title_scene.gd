extends Node2D
## Handles functionality for the title menu
##
## This script handles button presses on the title screen
## and redirects the player to the game, an option screen
## or quits the game.

# Add start level scene directory here
const START_LEVEL : String = "res://Levels/Level_00/level_00.tscn"

# Audio players
@onready var press_sound: AudioStreamPlayer = $PressSound
@onready var music_player: AudioStreamPlayer = $MusicPlayer
@onready var hover_sound: AudioStreamPlayer = $HoverSound

# Confirmation dialog for quitting
@onready var quit_popup: ConfirmationDialog = $CanvasLayer/Control/QuitPopup

# Buttons
@onready var button_new_game: Button = $CanvasLayer/Control/VBoxContainer/NewGame
@onready var button_continue: Button = $CanvasLayer/Control/VBoxContainer/Continue
@onready var button_settings: Button = $CanvasLayer/Control/VBoxContainer/Settings
@onready var button_quit: Button = $CanvasLayer/Control/VBoxContainer/Quit

# Title screen anim
@onready var animation_player: AnimationPlayer = $CanvasLayer/Control/Sprite2D/AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().paused = true
	PlayerManager.player.visible = false # Make player invisible
	
	setup_title_screen()
	
	LevelManager.level_load_started.connect( exit_title_screen )
	
	pass 

# Driver to set up the title scene
func setup_title_screen() -> void:
	# Start with focus on the new game button
	button_new_game.grab_focus()
	
	# Play sounds when focus entered on any button 
	# There is definitely a better way but uhh....
	button_new_game.focus_entered.connect(func(): hover_sound.play())
	button_new_game.mouse_entered.connect(func(): hover_sound.play())
	button_continue.focus_entered.connect(func(): hover_sound.play())
	button_continue.mouse_entered.connect(func(): hover_sound.play())
	button_settings.focus_entered.connect(func(): hover_sound.play())
	button_settings.mouse_entered.connect(func(): hover_sound.play())
	button_quit.focus_entered.connect(func(): hover_sound.play())
	button_quit.mouse_entered.connect(func(): hover_sound.play())
	
	pass

func _on_new_game_pressed() -> void:
	press_sound.play()
	# Change scene to the start level
	LevelManager.load_new_level(START_LEVEL, Vector2.ZERO)
	
	LevelManager.level_loaded.connect( self.queue_free )
	
	pass # Replace with function body.


func _on_continue_pressed() -> void:
	press_sound.play()
	pass # Replace with function body.


func _on_settings_pressed() -> void:
	press_sound.play()
	pass # Replace with function body.

func _on_quit_pressed() -> void:
	press_sound.play()
	
	# Confirm with user whether or not they want to quit
	quit_popup.popup()
	pass 

# If the user confirms quit, quit
func _on_quit_popup_confirmed() -> void:
	get_tree().quit()
	pass 


func exit_title_screen() -> void:
	PlayerManager.player.visible = true

	pass
