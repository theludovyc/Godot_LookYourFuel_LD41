class_name Player

extends Area2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

signal hit
signal hitPortal
signal hitFuel

signal onMove(a)

signal noFuel

const moveSpeed=0.1
const maxSpeed=200.0
const stopSpeed=0.01

var move:Vector2

var screenSize

var canMove=false

var fuel=200

func _ready():
	move=Vector2()

	screenSize=get_viewport_rect().size

	hide()
	pass

func consumeFuel():
	fuel-=1
			
	emit_signal("onMove", fuel)
	
	if fuel <= 0:
		fuel=0
		emit_signal("noFuel")

func _process(delta):
	if canMove==true && fuel>0:
		var dirX = int(Input.is_action_pressed("ui_right"))-int(Input.is_action_pressed("ui_left"))
		var dirY = int(Input.is_action_pressed("ui_down"))-int(Input.is_action_pressed("ui_up"))
		
		if dirX != 0:
			consumeFuel()
			
			move.x = lerp(move.x, dirX * maxSpeed, moveSpeed)
		else:
			move.x = lerp(move.x, 0, stopSpeed)
			
		if dirY != 0:
			consumeFuel()
			
			move.y = lerp(move.y, dirY * maxSpeed, moveSpeed)
		else:
			move.y = lerp(move.y, 0, stopSpeed)

		position+=move*delta
		position.x = clamp(position.x, 0, screenSize.x)
		position.y = clamp(position.y, 0, screenSize.y)
	pass

func start(pos):
	position=pos
	move = Vector2()
	fuel=200
	emit_signal("onMove", fuel)

	$CollisionShape2D.disabled=false
	pass

func onPlayerBodyEntered(body):
	if body.name[0] == 'F':
		fuel=200
		body.get_node("CollisionShape2D").disabled=true
		body.hide()
		emit_signal("onMove", fuel)
		emit_signal("hitFuel")
	elif body.name[0] == 'E':
		emit_signal("hitPortal")
		$CollisionShape2D.disabled=true
	else:
		emit_signal("hit")
		$CollisionShape2D.disabled=true
	pass # replace with function body
