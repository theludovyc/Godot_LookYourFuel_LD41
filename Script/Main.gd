extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

export (String) var nextLvlName

var isStart=false

var Level

var level_index = 1

var level

var player:Player

func _ready():
	var Level = load("res://Scene/Lvl_"+str(level_index)+".tscn")
	
	level = Level.instance()
	
	add_child(level)
	
	player = $Player
	
	pass

func newGame():
	$Player.start($StartPosition.position)
	$Player.show()

	for body in $Fuels.get_children():
		body.get_node("CollisionShape2D").disabled=false
		body.show()

	$Player.setCanMove()

	$HUD.hideMessage()
	pass

func _process(delta):
	if isStart==false && Input.is_key_pressed(KEY_SPACE):
		player.start($Main/StartPosition.position)
		player.show()
		
		player.canMove = true
		
		$HUD.showMessage(false)
		
		isStart=true

	if(Input.is_key_pressed(KEY_ESCAPE)):
		get_tree().quit()
	pass

func gameOver():
	$Player.canMove = false

	$HUD.showMessage(true)

	isStart=false

func onTimerTimeout():
	if !isStart:
		$HUD.showMessage("PRESS SPACE KEY TO START!")
	pass

func onPlayerHitPortal():
	get_tree().change_scene("res://Scene/"+nextLvlName+".tscn")
	pass

func onPlayerNoFuel():
	$Player.setCantMove()

	$HUD.showMessage("NO FUEL!")

	isStart=false

	$Timer.start()
	pass

func onPlayerHitFuel():
	$Player.canMove=true

	$HUD.hideMessage()

	isStart=true
	pass
