extends Node2D

onready var metaboy_character = $MetaBoyTopDown

func _ready():
	# Set the MetaBoy character to the one the player selected.
	metaboy_character.set_attributes(MetaBoyGlobals.selected_metaboy.get_attributes_as_dictionary())

func _on_ExitButton_pressed():
	get_tree().change_scene("res://UI/LoginScreen.tscn")
