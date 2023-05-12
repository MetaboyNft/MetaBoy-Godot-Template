# MetaBoy-Godot-Template
A 2D game template for MetaBoy web games in Godot.

## Getting Started
This project contains examples on how a MetaBoy web3 game can be set up. It uses the following tools:
- Godot 3.5.2 C# Mono version
- Godot Loopring SDK (https://github.com/svntax/godot-loopring-sdk)
- Godot Stacks SDK (https://github.com/svntax/godot-stacks-sdk)

### Setup
Download or clone this repository, and then import the project into Godot. You should see the project with the name `MetaBoyGameTemplate`. Feel free to change this name later on.

The project comes with an example login screen, character select screen, and a platformer scene and top-down scene.

## Project Settings
In order to export to the web, the project needs the following settings.

- In `Project -> Export`, for the HTML5 export settings, go to the `Resources` tab and make sure that the filters for non-resource files/folders has the following: `Configs/*,MetaBoy/Metadata/*.json`.
This filter will export the metadata jsons for the collections, and it will export the config files inside of the `Configs/` folder (see the section on Loopring for more info).

- Make sure the Loopring and Stacks SDKs are enabled in `Project -> Project Settings -> Plugins`

## Loopring Setup
While the Loopring SDK itself has an example test screen you can check out (`addons/godot-loopring-sdk/tests/TestLogin.tscn`), it requires users to sign with their wallet for the game to do a read-only call. This template project skips the signing step by using a dummy wallet's API key to make read-only API calls. A dummy wallet is just a Loopring wallet with nothing in it except for the activation fee needed to use it, so you will need to fund at least a tiny amount of ETH/LRC to use this setup.

#### **SECURITY NOTE:** Do **NOT** use your own wallet's API key in this setup. The point of making a dummy wallet is so if the API key is leaked, there's nothing of value that's lost besides the activation fee in the wallet.

To set up the dummy API key:
- Create a new Loopring wallet and activate it. You'll need to use a wallet compatible with https://exchange.loopring.io (e.g. MetaMask)
- Go to https://exchange.loopring.io, connect the new wallet, and unlock the account.
- In the wallet account menu, go to `Export Account` and sign the transaction. This will reveal the API key for the wallet.
- Back in the Godot project, create a new file in the `Configs` folder called `env.cfg`, and inside it, add the following:
```
[API_KEYS]

loopring="your API key here"
```
The game can now read the Loopring API key from this file. See `Globals.gd` for how the code works.

**Note:** Make sure to exclude the `Configs` folder from your commits. The `.gitignore` file for this project should already do this.

## MetaBoy Features
Most of the essential MetaBoy features can be found in the `MetaBoy` folder.

### MetaBoy.tscn
The main scene you'll be working with is `MetaBoy/MetaBoy.tscn`. It contains all the setup necessary to make a MetaBoy with any attributes. It also has an editor property called `Collection`, which is used to set the collection the MetaBoy belongs to.

Functions:
- `set_metaboy_attributes(attributes: Dictionary)`: Use this function to set the attributes for a MetaBoy instance. For example:
```GDScript
var attributes = {
    "Background": "Kingdom",
    "Body": "Schoolboy",
    "Face": "Whatever",
    "Hat": "Hat-Blue",
    "Weapon": "Snail-Shell"
    "Collection": MetaBoyGlobals.Collection.OG
}
var metaboy_instance = $Path/To/The/MetaBoy/Instance
metaboy_instance.set_metaboy_attributes(attributes)
```
- `update_attributes()`: This function will update the data for a MetaBoy instance so that it matches the sprite textures.

**Note:** You can always edit `MetaBoy.tscn` or any of the other scenes and scripts yourself in any way you want. For example, if you want a specific STX MetaBoy in a level, you can add a `MetaBoy.tscn` instance to that level, change its `Collection` property from OG to STX, and right click it and toggle `Editable Children` to change the sprite textures manually. You can also make a new scene that inherits `MetaBoy.tscn` and change the sprite textures there instead. Feel free to edit any part of this project in whatever way best suits your own work.

### MetaBoyData.gd
This script is used as a data model to represent what a MetaBoy is. It contains the attributes and collection type of a MetaBoy, and it's used in `MetaBoy.tscn`.

### MetaBoyDisplay.tscn
This scene is an example UI scene for how you may want to display a MetaBoy character in a menu.

### MetaBoyGlobals.gd
This script is a global singleton accessible from anywhere in the project. It contains several useful variables and functions for handling MetaBoy logic and data. See `LoginScreen.gd` and `CharacterSelectScreen.gd` for some examples on how it's used.

### LoginScreen.tscn
An example login screen.

### CharacterSelectScreen.tscn
An example screen for how a player would pick a MetaBoy to use in the game. There's a lot going on in the script for reading the wallet connection, fetching the player's NFTs owned and displaying them, and so on.

### CharacterDisplayScreen.tscn
An example screen for showing the data of a MetaBoy that the player selected.

### MetaBoyPlatformer.tscn
An example implementation of a MetaBoy character for a platformer game.

### PlatformerScene.tscn
An example platformer level for testing `MetaBoyPlatformer.tscn`

### MetaBoyTopDown.tscn
An example implementation of a MetaBoy character for a top-down game.

### TopDownScene.tscn
An example top-down level for testing `MetaBoyTopDown.tscn`

## Other Notes
- You can delete the platformer and top-down folders if you won't use them.
- It's up to the developer to decide how to add more animations to a MetaBoy character. The only animations made by default are the running animation, and an idle animation that simply changes the run animation to a specific frame.
