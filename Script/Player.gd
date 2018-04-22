extends Area2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

signal hit
signal hitPortal
signal hitFuel

signal onMove(a)

signal noFuel

var moveSpeed=10.0
var maxSpeed=200.0
var stopSpeed=0.5

var move

var screenSize

var canMove=false
var moveX=false
var moveY=false

var fuel=200

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	move=Vector2()

	screenSize=get_viewport_rect().size

	hide()
	pass

func _process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	if canMove==true && fuel>0:
		if Input.is_action_pressed("ui_left"):
			move.x-=moveSpeed
			if move.x<-maxSpeed:
				move.x=-maxSpeed
			moveX=true
			fuel-=1
			emit_signal("onMove", fuel)
		elif Input.is_action_pressed("ui_right"):
			move.x+=moveSpeed
			if move.x>maxSpeed:
				move.x=maxSpeed
			moveX=true
			fuel-=1
			emit_signal("onMove", fuel)
		else:
			moveX=false

		if Input.is_action_pressed("ui_up"):
			move.y-=moveSpeed
			if move.y<-maxSpeed:
				move.y=-maxSpeed
			moveY=true
			fuel-=1
			emit_signal("onMove", fuel)
		elif Input.is_action_pressed("ui_down"):
			move.y+=moveSpeed
			if move.y>maxSpeed:
				move.y=maxSpeed
			moveY=true
			fuel-=1
			emit_signal("onMove", fuel)
		else:
			moveY=false

		if moveX or moveY:
			fuel-=1
			if fuel <= 0:
				fuel=0
				emit_signal("noFuel")
			emit_signal("onMove", fuel)

	if moveX==false:
		if move.x>0:
			move.x-=stopSpeed
			if move.x<0:
				move.x=0
		elif move.x<0:
			move.x+=stopSpeed
			if move.x>0:
				move.x=0

	if moveY==false:
		if move.y>0:
			move.y-=stopSpeed
			if move.y<0:
				move.y=0
		elif move.y<0:
			move.y+=stopSpeed
			if move.y>0:
				move.y=0

	position+=move*delta
	position.x = clamp(position.x, 0, screenSize.x)
	position.y = clamp(position.y, 0, screenSize.y)
	pass

func setCanMove():
	canMove=true
	move.x=0
	move.y=0
	pass

func setCantMove():
	canMove=false
	moveX=false
	moveY=false
	pass

func start(pos):
	position=pos
	move.x=0
	move.y=0
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
