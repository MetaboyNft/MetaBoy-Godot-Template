extends KinematicBody2D

# An example implementation of platformer player controls.

const SNAP = Vector2(0, 12)
onready var speed = 160
onready var jump_speed = -320
onready var velocity = Vector2()
onready var gravity = 640

onready var metaboy = $MetaBoy

func _ready():
	metaboy.part_background.hide()

func set_attributes(attributes: Dictionary) -> void:
	metaboy.set_metaboy_attributes(attributes)

func _physics_process(delta: float) -> void:
	# Gravity
	velocity.y += gravity * delta
	
	# Jump
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = jump_speed
	
	# Movement
	var input_dir = Input.get_axis("ui_left", "ui_right")
	velocity.x = input_dir * speed
	
	if velocity.y < 0:
		velocity.y = move_and_slide(velocity, Vector2.UP, true).y
	else:
		velocity.y = move_and_slide_with_snap(velocity, SNAP, Vector2.UP, true).y
	
	# Animations
	if velocity.x != 0:
		metaboy.animation_player.play("run", -1, 2.0)
	else:
		metaboy.animation_player.play("idle")
	
	if velocity.x < 0:
		metaboy.body_root.scale.x = -1
	elif velocity.x > 0:
		metaboy.body_root.scale.x = 1
