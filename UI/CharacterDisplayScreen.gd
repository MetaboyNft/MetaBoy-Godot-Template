extends Node2D

onready var metaboy = $"%MetaBoy"
onready var attributes_container = $Control/BackPanel/AttributesValues
onready var speed_label = $Control/BackPanel/SpeedLabel
onready var speed_slider = $Control/BackPanel/SpeedSlider
onready var collection_label = $"%CollectionLabel"

func _ready():
	var attributes = MetaBoyGlobals.selected_metaboy.get_attributes_as_dictionary()
	metaboy.set_metaboy_attributes(attributes)
	
	var collection = attributes.get("Collection", MetaBoyGlobals.Collection.OG)
	if collection == MetaBoyGlobals.Collection.OG:
		collection_label.text = "Collection: OG"
	elif collection == MetaBoyGlobals.Collection.STX:
		collection_label.text = "Collection: STX"
	else:
		collection_label.text = "Collection: unknown"
	
	for key in attributes.keys():
		var attribute_label = get_node_or_null("Control/BackPanel/AttributesValues/" + key)
		var key_label = get_node_or_null("Control/BackPanel/Attributes/" + key)
		if attribute_label != null:
			var value = attributes.get(key, "")
			attribute_label.text = value
		if key_label != null:
			var value = attributes.get(key, "")
			if value.empty():
				key_label.self_modulate.a = 0.5 # Transparent
	
	metaboy.animation_player.play("run", -1, speed_slider.value)

func _on_BackButton_pressed():
	get_tree().change_scene("res://UI/CharacterSelectScreen.tscn")

func _on_IdleButton_pressed():
	metaboy.animation_player.play("idle", -1, speed_slider.value)

func _on_RunButton_pressed():
	metaboy.animation_player.play("run", -1, speed_slider.value)

func _on_SpeedSlider_value_changed(value):
	speed_label.text = "Speed: x" + str(value)
	if metaboy.animation_player.is_playing():
		metaboy.animation_player.play(metaboy.animation_player.current_animation, -1, value)

func _on_PlayTopDownButton_pressed():
	get_tree().change_scene("res://TopDownExample/TopDownScene.tscn")

func _on_PlayPlatformerButton_pressed():
	get_tree().change_scene("res://PlatformerExample/PlatformerScene.tscn")
