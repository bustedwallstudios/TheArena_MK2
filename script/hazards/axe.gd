extends Area2D

export (PackedScene) var TelegraphParticleScene

# The radius of the circle that the axe can spawn around, in px
const circleRadius = 350

var spinAxe = false

# Seconds that the axe will exist / take to spin around half a circle
var speed = 2
# The amount the speed changes based on how many hazards the player has survived so 
const speedModifier = 5

# When the axe is added to the world, this is called. The axe is charged with ensuring
# its own initiation, telegraphing, etc etc.
func run(hazardCount):
	speed = speedUp(hazardCount)
	
	$Sprite.hide() # Immediately make the axe sprite itself invisible
	$BackgroundSprite.hide()
	
	# Find the position that the circle will start at
	var angle = randf() * TAU
	var positionAroundCircle = determineOffsetFromCenter(angle)
	self.position = Global.screenCenter + positionAroundCircle
	self.rotation = angle + PI
	
	# Telegraph the axe, but put the particles closer to the center
	# of the screen, so that they're inside the arena.
	$TelegraphParticleBurst.global_position = Global.screenCenter + positionAroundCircle*0.65
	$TelegraphParticleBurst.emitting = true
	
	flickerBG()
	
	# Wait 1.5 seconds for the telegraph
	yield(get_tree().create_timer(1.5), "timeout")
	
	# The axe exists!
	$Sprite.show()
	$HitboxHandle.disabled = false
	$HitboxHead.disabled   = false
	
	# Begin rotating the axe to kill the player
	spinAxe = true
	
	# Shake the camera when the axe appears
	self.get_parent().get_parent().get_node("Camera").shake(0.4, 300, 5)
	
	# Wait speed seconds for the axe to disappear
	# The rotation code will ensure that it spins 180°
	yield(get_tree().create_timer(speed), "timeout")
	
	# Shake the screen when the axe disappears
	self.get_parent().get_parent().get_node("Camera").shake(0.4, 300, 5)
	spinAxe = false # Stop rotating,
	$Sprite.hide()  # and hide the sprite so all that can be seen is the background
	flickerBG(0.075, 0, 2, true)
	
	# Wait another second for the background to flicker out of existence
	yield(get_tree().create_timer(1.0), "timeout")
	
	# After the axe has existed, delete the axe
	self.queue_free()

func _physics_process(delta):
	# If the axe should be spinning around, and the player is still alive
	# (I want the axe to stop spinning once the player is dead, for aesthetic reasons)
	if spinAxe:
		# Spins halfway around a circle, in the amount of time the axe exists for.
		self.rotation += (PI * delta) / speed

# Flickers the background sprite on and off quickly
func flickerBG(initial=0.1, step=0, count=2, hideAfter=false):
	var currentTime = initial
	
	if step < 0:
		$BackgroundSprite.hide()
	
	for i in range(0, count*2):
		$BackgroundSprite.hide()
		yield(get_tree().create_timer(currentTime), "timeout")
		currentTime += step
		
		$BackgroundSprite.show()
		yield(get_tree().create_timer(currentTime), "timeout")
	
	if hideAfter:
		$BackgroundSprite.hide()

# Find the spot that the axe should be placed at, that it will be rotated around
# (This is not where the particles are spawned; they are closer to the center of the map)
# s is the scale of the circle relative to circleRadius
func determineOffsetFromCenter(angle:float):
	var offsetX = cos(angle) * circleRadius
	var offsetY = sin(angle) * circleRadius
	
	return Vector2(offsetX, offsetY)

func gameOver():
	print("game over from in axe\n")
	
	# This will stop spinning the axe as soon as it kills the player
	spinAxe = false
	
	# Stop making new hazards
	self.get_parent().continueHazards = false

func speedUp(x):
	# Transformations of a function
	var a = 1
	var k = -0.15
	var d = 8
	var c = 0.2
	
	var y = pow(2, k * (x-d)) + c # Find the value of the function at x
	
	# Solved for y
	return y
