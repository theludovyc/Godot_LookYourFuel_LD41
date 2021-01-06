extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

export (String) var nextLvlName

var isStart=false

var level_index = 1

var level

var player:Player

func loadLevel():
	var Level = load("res://Scene/Lvl_"+str(level_index)+".tscn")
	
	level = Level.instance()
	
	add_child(level)

func _ready():
	loadLevel()
	
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

func _process(_delta):
	if Input.is_key_pressed(KEY_SPACE):
		player.start(level.get_node("StartPosition").position)
		player.show()
		
		for body in level.get_node("Fuels").get_children():
			body.get_node("CollisionShape2D").disabled=false
			body.show()
		
		player.canMove = true
		
		$HUD.showMessage(false)
		
		isStart=true

	if(Input.is_key_pressed(KEY_ESCAPE)):
		get_tree().quit()
	pass

func gameOver():
	$HUD.showMessage(true)

func onTimerTimeout():
	pass

func nextLevel():
	level.queue_free()
	
	level_index += 1
	
	if level_index > 10:
		level_index = 1
	
	loadLevel()

func onPlayerHitPortal():
	$Player.hide()
	$Player.position = Vector2()
	
	call_deferred("nextLevel")

func onPlayerNoFuel():
	$HUD.showMessage(true)

func onPlayerHitFuel():
	pass
