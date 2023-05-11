extends KinematicBody2D

# An example implementation of top-down player controls.

onready var speed = 160
onready var velocity = Vector2()

onready var metaboy = $MetaBoy

func _ready():
	metaboy.part_background.hide()

func set_attributes(attributes: Dictionary) -> void:
	metaboy.set_metaboy_attributes(attributes)

func _physics_process(_delta: float) -> void:
	# Movement
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if input_dir.length_squared() > 1.0:
		input_dir = input_dir.normalized()
	velocity = input_dir * speed
	move_and_slide(velocity)
	
	# Animations
	if velocity.x != 0 or velocity.y != 0:
		metaboy.animation_player.play("run", -1, 2.0)
	else:
		metaboy.animation_player.play("idle")
	if velocity.x < 0:
		metaboy.body_root.scale.x = -1
	elif velocity.x > 0:
		metaboy.body_root.scale.x = 1
