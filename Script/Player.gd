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
const maxSpeed= moveSpeed*1000.0
const stopSpeed= moveSpeed*0.03

var speed:Vector2

var screenSize

var canMove=false

var fuel=200

func _ready():
	speed=Vector2()

	screenSize=get_viewport_rect().size

	hide()
	pass

func consumeFuel():
	fuel-=1
			
	emit_signal("onMove", fuel)
	
	if fuel <= 0:
		fuel=0
		emit_signal("noFuel")

func getAxis(inputA, inputB):
	return int(Input.is_action_pressed(inputA))-int(Input.is_action_pressed(inputB))

func getSpeed(dir:float, speed:float) -> float:
	if dir != 0:
		consumeFuel()
		
		return clamp(speed+dir*moveSpeed, -1, 1)
	return sign(speed)*clamp(abs(speed)-stopSpeed, 0, 1)

func _process(delta):
	if canMove==true && fuel>0:
		var dir:Vector2
		dir.x = getAxis("ui_right", "ui_left")
		dir.y = getAxis("ui_down", "ui_up")
		
		dir = dir.normalized()
		
		speed.x = getSpeed(dir.x, speed.x)
			
		speed.y = getSpeed(dir.y, speed.y)
		
		if speed.length() > 1:
			speed = speed.normalized()

		position += speed*maxSpeed*delta
		position.x = clamp(position.x, 0, screenSize.x)
		position.y = clamp(position.y, 0, screenSize.y)
	pass

func start(pos):
	position=pos
	
	speed = Vector2()
	
	$Particles2D.amount = 8
	
	fuel=200
	
	emit_signal("onMove", fuel)

	call_deferred("disableColShape", false)
	pass

func disableColShape(b:bool):
	$CollisionShape2D.disabled=b

func reset():
	canMove = false
	
	$Particles2D.amount = 1
	
	call_deferred("disableColShape", true)

func onPlayerBodyEntered(body):
	if body.name[0] == 'F':
		fuel=200
		body.get_node("CollisionShape2D").disabled=true
		body.hide()
		emit_signal("onMove", fuel)
		emit_signal("hitFuel")
	elif body.name[0] == 'E':
		emit_signal("hitPortal")
		reset()
	else:
		emit_signal("hit")
		reset()
	pass # replace with function body
