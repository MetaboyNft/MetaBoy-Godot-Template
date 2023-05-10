extends Control

signal metaboy_selected(attributes)

onready var metaboy = $MetaBoy
onready var animation_player = $MetaBoy/AnimationPlayer
onready var name_label = $Name
onready var button = $Button

func _ready():
	animation_player.play("run", -1, 2)

func select() -> void:
	button.grab_focus()

func set_metaboy_name(metaboy_name: String) -> void:
	name_label.text = metaboy_name

func set_metaboy_attributes(attributes: Dictionary) -> void:
	metaboy.set_metaboy_attributes(attributes)

func _on_Button_pressed():
	emit_signal("metaboy_selected", metaboy.metaboy_data)
