extends Control

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	pass

func setMessage(text):
	$MessageLabel.text=text

func showMessage(var b:bool):
	if b:
		$MessageLabel.show()
		return
	$MessageLabel.hide()

func onPlayerMove(a):
	$FuelBar.scale.x = 0.16*a
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
