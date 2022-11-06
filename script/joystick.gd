extends Node2D

onready var center = Vector2(500/2, 500/2) * self.scale

# Allows this script to send signals (call functions, basically) to other scripts, whenever 
signal useMoveVector

# The vector that the joystick is being pulled in
var moveVector:Vector2

# Whether the player should be moving right now
var joystickActive = false

func _input(event):
	# If the user has either begun touching the screen, or
	# moved their finger on the screen, respectively
	if event is InputEventScreenTouch or event is InputEventScreenDrag:
		# If the button is pressed (this will only be true if the touch STARTED on the button,
		# regardless of where their finger is now)
		if $Button.is_pressed():
			
			# Find the direction that the player has dragged the joystick in, and put that
			# vector to an appropriate length for moving the player
			var moveDirection = event.position - (self.global_position + center)
			moveVector        = (moveDirection / 100).limit_length(1)
			
			# If this is true, the player will be continually moved in _physics_process()
			joystickActive = true
	
	# If the player takes their finger off the screen, deactivate the button
	if event is InputEventScreenTouch and event.pressed == false:
		joystickActive = false

func _physics_process(_delta):
	# If the joystick is currently being moved, then always send out the movement vector.
	# If this was not here, it would only update the movement of the player when the user
	# moved their finger or started pressing, and of course it should also be moving if
	# the player's finger is stationary but pulling the joystick.
	if joystickActive:
		# This can be connected to other scripts, and it passes
		# moveVector as an argument to the function it's connected to
		emit_signal("useMoveVector", moveVector)
		
		offsetJoystick(moveVector)
	else:
		# If the joystick is not active, put it back to the original position
		offsetJoystick(Vector2(0, 0))

func offsetJoystick(offset):
	$Inside.position = offset*90 # 90 is the largest amount of pixels that it can be offset
