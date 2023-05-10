extends Node

const API_ENV_PATH = "res://Configs/env.cfg"
var loopring_api_key = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	# Read Loopring API key
	var env_config = ConfigFile.new()
	var err = env_config.load(API_ENV_PATH)
	if err == ERR_FILE_NOT_FOUND:
		printerr("env.cfg file is missing")
	elif err != OK:
		printerr("Error when attempting to load env.cfg")
	else:
		loopring_api_key = env_config.get_value("API_KEYS", "loopring")
