extends Node2D

export (MetaBoyGlobals.Collection) var collection = MetaBoyGlobals.Collection.OG

onready var metaboy_data = MetaBoyData.new({
	"Body": "Schoolboy",
	"Collection": MetaBoyGlobals.Collection.OG
})

onready var animation_player = $AnimationPlayer
onready var body_root = $MainBody

# MetaBoy parts
onready var part_background = $MainBody/Background
onready var part_back = $MainBody/Back
onready var part_body = $MainBody/Body
onready var part_body_02 = $MainBody/Body2
onready var part_face = $MainBody/Face
onready var part_hat = $MainBody/Hat
onready var part_neck = $MainBody/Neck
onready var part_waist = $MainBody/Waist
onready var part_weapon = $MainBody/Weapon

func _ready():
	update_attributes()

# Updates the MetaBoyData object to match the current sprite textures.
func update_attributes() -> void:
	var attributes = {
		"Background": get_attribute_from_sprite(part_background),
		"Back": get_attribute_from_sprite(part_back),
		"Body": get_attribute_from_sprite(part_body),
		"Face": get_attribute_from_sprite(part_face),
		"Hat": get_attribute_from_sprite(part_hat),
		"Neck": get_attribute_from_sprite(part_neck),
		"Waist": get_attribute_from_sprite(part_waist),
		"Weapon": get_attribute_from_sprite(part_weapon),
		"Collection": collection
	}
	set_metaboy_attributes(attributes)

func set_metaboy_attributes(attributes: Dictionary) -> void:
	var collection = attributes.get("Collection", MetaBoyGlobals.Collection.OG)
	metaboy_data.collection = collection
	var path_root = ""
	if collection == MetaBoyGlobals.Collection.OG:
		path_root = "res://MetaBoy/spritesheets_og/"
	elif collection == MetaBoyGlobals.Collection.STX:
		path_root = "res://MetaBoy/spritesheets_stx/"
	var show_back = false
	var show_hat = false
	var show_neck = false
	var show_waist = false
	for key in attributes.keys():
		if key == "Collection":
			continue
		
		var value = attributes.get(key).replace(" ", "-")
		var path = path_root + str(key) + "/" + value + ".png"
		if ResourceLoader.exists(path):
			if key == "Back":
				part_back.texture = load(path)
				metaboy_data.back = value
				show_back = true
			elif key == "Background":
				metaboy_data.background = value
				part_background.texture = load(path)
				# NOTE: Some backgrounds have a different number of frames, so
				# they won't loop properly with the rest of the sprites.
				part_background.vframes = MetaBoyGlobals.get_vframes_count(part_background.texture)
			elif key == "Body":
				part_body.texture = load(path)
				metaboy_data.body = value
				# For the STX collection, Monster Suit has the teeth as an additional layer
				if collection == MetaBoyGlobals.Collection.STX and \
						(value.replace(" ", "-") == "Monster-Suit"):
					var path_teeth = path_root + "/Teeth/Monster-Suit-Teeth.png"
					part_body_02.texture = load(path_teeth)
			elif key == "Face":
				part_face.texture = load(path)
				metaboy_data.face = value
			elif key == "Hat":
				part_hat.texture = load(path)
				metaboy_data.hat = value
				show_hat = true
			elif key == "Neck":
				part_neck.texture = load(path)
				metaboy_data.neck = value
				show_neck = true
			elif key == "Waist":
				part_waist.texture = load(path)
				metaboy_data.waist = value
				show_waist = true
			elif key == "Weapon":
				part_weapon.texture = load(path)
				metaboy_data.weapon = value
	
	part_back.visible = show_back
	part_hat.visible = show_hat
	part_neck.visible = show_neck
	part_waist.visible = show_waist
	
	# Bodies with dark screens need the light version of the face
	var body_type = attributes.get("Body", "").replace(" ", "-")
	if MetaBoyGlobals.is_dark_screen_body(body_type, collection):
		var face_type = attributes.get("Face").replace(" ", "-")
		var face_light_version_texture = MetaBoyGlobals.get_face_light_version(face_type, collection)
		if face_light_version_texture:
			part_face.texture = face_light_version_texture

# Get the attribute from the given sprite's texture path.
func get_attribute_from_sprite(sprite: Sprite) -> String:
	if sprite.texture == null:
		return ""
	
	var path = sprite.texture.resource_path
	if sprite.texture.resource_path.empty():
		return ""
	
	var path_split = path.split("/")
	var attribute = path_split[path_split.size() - 1].replace(".png", "").replace("-White", "")
	return attribute
