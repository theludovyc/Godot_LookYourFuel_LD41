extends Control

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	$MessageLabel.hide()
	pass

func showMessage(text):
	$MessageLabel.text=text
	$MessageLabel.show()
	pass

func hideMessage():
	$MessageLabel.hide()
	pass

func onPlayerMove(a):
	$FuelBar.scale.x = 0.16*a
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
