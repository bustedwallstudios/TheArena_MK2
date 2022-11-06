extends Area2D

var leftBound
var rightBound
var upperBound
var lowerBound

# ADDED BY HUNTER NO IDEA WHAT IT DOES
onready var trail = get_parent().get_node("Trail")

# DELTA VALUE FOR TAIL
var trail_delta = 0.0 


# The maximum speed that the player can move around the map
var maxSpeed = 5

# The current speed that the player is moving (for use
# in determining the particle behaviour when the player dies)
var currentSpeed:Vector2

# Screen width and height
var w  = 1280
var h = 720

# Arena size
var a = 500

# Radius of the player ball
var r = (80/2) - 5 # -5 just to make it feel better imo

# Dead
var dead = false

func _ready():
	# HUNTER: CLEARS TAIL POINTS
	trail.clear_points()
	
	leftBound  = (w/2) - (a/2) + r
	rightBound = (w/2) + (a/2) - r
	
	upperBound = (h/2) - (a/2) + r
	lowerBound = (h/2) + (a/2) - r
	
# ADDS POINTS FOR TAIL
func _process(delta):
	trail_delta += delta
	
	# NUMBER OF POINTS ON THE TRAIL PER SECOND
	if trail_delta > 1.0/30.0:
		trail.add_point(global_position, len(trail.points))
		
		# ERASES TRAIL AFTER 20 UNITS
		if len(trail.points)>20:
			trail.remove_point(0)
		trail_delta = 0.0
	# STOPS THE TAIL FROM FLICKERING AT HIGH SPEEDS
	else:
		trail.set_point_position(len(trail.points)-1, global_position)

func move(direction:Vector2):
	if dead:
		return
	
	currentSpeed = direction * maxSpeed
	
	self.position += currentSpeed
	
	if self.position.x <  leftBound:
		self.position.x = leftBound
	
	if self.position.x >  rightBound:
		self.position.x = rightBound
	
	if self.position.y <  upperBound:
		self.position.y = upperBound
	
	if self.position.y >  lowerBound:
		self.position.y = lowerBound

# When a body is collided
func collision(body):
	# If the body has a property called "hazard" (if body.hazard exists, basically)
	if body.is_in_group("hazards"):
		body.gameOver()
		
		die()

func die():
	dead = true
	
	$Sprite.hide()
	
	# The particles will have this spread if the player is moving at max speed
	var minSpread = 33
	
	# Aim the death particles in the direction of the player's movement (if stationary, the particles randomly explode from the center)
	$DeathParticles.process_material.direction.x = self.currentSpeed.x
	$DeathParticles.process_material.direction.y = self.currentSpeed.y
	$DeathParticles.emitting = true
	
	get_parent().get_node("Camera").shake(2, 80, 7.5)
	
	# Delay the changing of scenes for the camera shake to complete
	yield(get_tree().create_timer(3), "timeout")
	
	# Change the scene to the main menu because user died 
	get_tree().change_scene("res://scenes/ui/MainMenu.tscn")
