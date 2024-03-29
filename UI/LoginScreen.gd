extends Node2D

# Loopring wallet buttons
onready var button_metamask = $"%ButtonMetamask"
onready var button_walletconnect = $"%ButtonWalletConnect"

# Stacks wallet buttons
onready var button_leather = $"%ButtonLeather"

onready var loopring_wallet_connector = $LoopringWalletConnector
onready var stacks_wallet_connector = $StacksWalletConnector

onready var login_ui = $LoginUI
onready var loading_rect = $LoginUI/LoadingRect
onready var loading_label = $LoginUI/LoadingLabel
onready var loading_cancel_button = $LoginUI/LoadingCancelButton

const WALLETS = ["Loopring", "Stacks"]
onready var wallet_dropdown = $"%WalletDropdown"
onready var wallet_info_label = $"%WalletInfoLabel"
onready var disconnect_wallet_button = $"%DisconnectWalletButton"
onready var loopring_menu = $LoginUI/LoopringMenu
onready var stacks_menu = $LoginUI/StacksMenu

onready var login_prompt_ui = $LoginPromptUI
onready var login_process_button = $"%LoginProcessButton"

onready var animation_player = $AnimationPlayer

func _ready():
	wallet_info_label.text = "No wallet connected."
	hide_loading_ui()
	login_ui.hide()
	login_prompt_ui.show()
	login_process_button.grab_focus()
	
	var account = LoopringGlobals.wallet
	if account != null and account != "":
		# Wallet detected
		wallet_info_label.text = "Wallet Connected:\n" + account
		disconnect_wallet_button.disabled = false
	else:
		wallet_info_label.text = "No wallet connected."
		disconnect_wallet_button.disabled = true
	
	# Set up the dropdown menu for different wallets
	for item in WALLETS:
		wallet_dropdown.add_item(item)
	wallet_dropdown.select(0)
	
	# Connect the buttons to their respective callbacks
	button_metamask.connect("pressed", self, "Button_Metamask")
	button_walletconnect.connect("pressed", self, "Button_Metamask")
	
	button_leather.connect("pressed", self, "Button_Leather")
	
	# Connect the WalletConnector signal to handle wallet sign ins
	loopring_wallet_connector.connect("wallet_connected", self, "_on_loopring_wallet_connected")
	stacks_wallet_connector.connect("wallet_connected", self, "_on_stacks_wallet_connected")

func _process(_delta):
	if button_metamask.has_focus():
		if !animation_player.current_animation == "select_first":
			animation_player.play("select_first")
	elif button_walletconnect.has_focus():
		if !animation_player.current_animation == "select_second":
			animation_player.play("select_second")
	
	if Input.is_action_just_pressed("ui_cancel"):
		if loading_rect.visible:
			hide_loading_ui()
		else:
			if login_ui.visible:
				# Go back to the "Login or Guest" menu
				login_ui.hide()
				login_prompt_ui.show()
				login_process_button.grab_focus()

func Button_Metamask():
	show_loading_ui()
	loopring_wallet_connector.connect_to_web3_wallet("m")
	LoopringGlobals.set_wallet_type(LoopringGlobals.WalletType.METAMASK)

func Button_WalletConnect():
	# NOTE: QR code login not implemented.
	show_loading_ui()
	LoopringGlobals.set_wallet_type(LoopringGlobals.WalletType.WALLETCONNECT)

func _on_loopring_wallet_connected(wallet: String):
	if wallet == null or wallet.empty():
		print("Failed to connect wallet.")
		LoopringGlobals.clear_wallet()
		hide_loading_ui()
		return
	
	# At this point, LoopringGlobals.wallet should be set.
	print("Connected with Loopring wallet: " + wallet)
	save_loopring_login()
	get_tree().change_scene("res://UI/CharacterSelectScreen.tscn")

func Button_Leather():
	show_loading_ui()
	
	var account = StacksGlobals.wallet
	var wallet_type = StacksGlobals.current_wallet_type
	if account != null and account != "" and wallet_type != null and StacksGlobals.is_valid_wallet_type(wallet_type):
		# Wallet account detected
		get_tree().change_scene("res://UI/CharacterSelectScreen.tscn")
	else:
		stacks_wallet_connector.connect_to_wallet("stacks")
		StacksGlobals.set_wallet_type(StacksGlobals.WalletType.STACKS)

func _on_stacks_wallet_connected(wallet: String):
	if wallet == null or wallet.empty():
		print("Failed to connect wallet.")
		StacksGlobals.clear_wallet()
		hide_loading_ui()
		return
	
	# At this point, StacksGlobals.wallet should be set.
	print("Connected with Stacks wallet: " + wallet)
	save_stacks_login()
	get_tree().change_scene("res://UI/CharacterSelectScreen.tscn")

func save_loopring_login() -> void:
	var user_config = ConfigFile.new()
	var err = user_config.load(LoopringGlobals.USER_DATA_SAVE_PATH)
	if err != OK:
		user_config = ConfigFile.new()
	user_config.set_value(LoopringGlobals.DATA_SECTION, "LoopringAccount", LoopringGlobals.wallet)
	user_config.set_value(LoopringGlobals.DATA_SECTION, "LoopringWalletType", LoopringGlobals.current_wallet_type)
	user_config.save(LoopringGlobals.USER_DATA_SAVE_PATH)

func save_stacks_login() -> void:
	var user_config = ConfigFile.new()
	var err = user_config.load(StacksGlobals.USER_DATA_SAVE_PATH)
	if err != OK:
		user_config = ConfigFile.new()
	user_config.set_value(StacksGlobals.DATA_SECTION, "StacksAccount", StacksGlobals.wallet)
	user_config.set_value(StacksGlobals.DATA_SECTION, "StacksWalletType", StacksGlobals.current_wallet_type)
	user_config.save(StacksGlobals.USER_DATA_SAVE_PATH)

func show_loading_ui() -> void:
	loading_rect.show()
	loading_label.show()
	loading_cancel_button.show()

func hide_loading_ui() -> void:
	loading_rect.hide()
	loading_label.hide()
	loading_cancel_button.hide()

func _on_LoadingCancelButton_pressed():
	hide_loading_ui()

func _on_LoginProcessButton_pressed():
	login_prompt_ui.hide()
	login_ui.show()
	loopring_menu.show()
	stacks_menu.hide()
	button_metamask.grab_focus()

func _on_DisconnectWalletButton_pressed():
	var item = wallet_dropdown.get_item_text(wallet_dropdown.selected)
	if item == "Loopring":
		var account = LoopringGlobals.wallet
		if account != null and account != "":
			# Wallet detected
			Loopring.logout()
			MetaBoyGlobals.clear_loopring_data()
			wallet_info_label.text = "No wallet connected."
			disconnect_wallet_button.disabled = true
	elif item == "Stacks":
		var account = StacksGlobals.wallet
		if account != null and account != "":
			# Wallet detected
			Stacks.logout()
			MetaBoyGlobals.clear_stx_data()
			wallet_info_label.text = "No wallet connected."
			disconnect_wallet_button.disabled = true

func _on_WalletDropdown_item_selected(index):
	if index == 0:
		loopring_menu.show()
		disconnect_wallet_button.focus_neighbour_left = disconnect_wallet_button.get_path_to(button_metamask)
		var account = LoopringGlobals.wallet
		if account != null and account != "":
			# Wallet detected
			wallet_info_label.text = "Wallet Connected:\n" + account
			disconnect_wallet_button.disabled = false
		else:
			wallet_info_label.text = "No wallet connected."
			disconnect_wallet_button.disabled = true
		
		stacks_menu.hide()
	elif index == 1:
		loopring_menu.hide()
		stacks_menu.show()
		animation_player.play("select_first")
		disconnect_wallet_button.focus_neighbour_left = disconnect_wallet_button.get_path_to(button_leather)
		var account = StacksGlobals.wallet
		if account != null and account != "":
			# Wallet detected
			wallet_info_label.text = "Wallet Connected:\n" + account
			disconnect_wallet_button.disabled = false
		else:
			wallet_info_label.text = "No wallet connected."
			disconnect_wallet_button.disabled = true
