extends Node2D
## Handles functionality for the title menu
##
## This script handles button presses on the title screen
## and redirects the player to the game, an option screen
## or quits the game.

# Add start level scene directory here
const START_LEVEL : String = "res://playground.tscn" 

# These variables can be imported from the Inspector tab for TitleScene
@export var music : AudioStream
@export var button_hover_sound : AudioStream
@export var button_select_sound : AudioStream

# Various paths
@onready var music_player: AudioStreamPlayer = $MusicPlayer
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var quit_popup: ConfirmationDialog = $CanvasLayer/Control/QuitPopup

# Buttons
@onready var button_new_game: Button = $CanvasLayer/Control/VBoxContainer/NewGame
@onready var button_continue: Button = $CanvasLayer/Control/VBoxContainer/Continue
@onready var button_settings: Button = $CanvasLayer/Control/VBoxContainer/Settings
@onready var button_quit: Button = $CanvasLayer/Control/VBoxContainer/Quit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setup_title_screen()
	
	pass 

# Driver to set up the title scene
func setup_title_screen() -> void:
	music_player.play()
	
	button_new_game.grab_focus()
	
	
	button_new_game.focus_entered.connect(play_audio.bind(button_hover_sound))
	button_new_game.mouse_entered.connect(play_audio.bind(button_hover_sound))
	button_continue.focus_entered.connect(play_audio.bind(button_hover_sound))
	button_continue.mouse_entered.connect(play_audio.bind(button_hover_sound))
	button_settings.focus_entered.connect(play_audio.bind(button_hover_sound))
	button_settings.mouse_entered.connect(play_audio.bind(button_hover_sound))
	button_quit.focus_entered.connect(play_audio.bind(button_hover_sound))
	button_quit.mouse_entered.connect(play_audio.bind(button_hover_sound))
	
	pass


func _on_new_game_pressed() -> void:
	play_audio(button_select_sound)
	
	# Change scene to the start level after a brief pause
	await get_tree().create_timer(0.3).timeout
	get_tree().change_scene_to_file(START_LEVEL)
	pass # Replace with function body.


func _on_continue_pressed() -> void:
	play_audio(button_select_sound)
	pass # Replace with function body.


func _on_settings_pressed() -> void:
	play_audio(button_select_sound)
	pass # Replace with function body.

func _on_quit_pressed() -> void:
	play_audio(button_select_sound)
	
	# Confirm with user whether or not they want to quit
	quit_popup.popup()
	pass 

# If the user confirms quit, quit
func _on_quit_popup_confirmed() -> void:
	get_tree().quit()
	pass 

# Helper function to play audio
func play_audio(_a : AudioStream) -> void:
	audio_stream_player.stream = _a
	audio_stream_player.play()
	pass
