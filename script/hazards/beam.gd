extends Area2D

# If this is true, the beam will go horizontally across the screen: --
# If false, it will be vertical: |
var beamIsHorizontal:bool

# The maximum offset from the center of the arena is
# half the width of the arena, minus the width of the beam.
onready var maxOffset = (500/2) - (300 * $Sprite.scale.y)

func run(hazardCount):
	# Randomly flip the laser upside down, just so that the indicators don't
	# ALWAYS come from the right or bottom.
	if randf() > 0.5:
		self.scale.x *= -1
	
	beamIsHorizontal = randf() > 0.5
	
	# This if/else just sets the position of the beam correctly
	if beamIsHorizontal:
		# Go to the middle of the screen horizontally
		self.position.x = Global.screenCenter.x
		
		# Find a random offset within the confines of the bounds of the arena
		self.position.y = findPositionToStrike()
	
	else: # If the beam is vertical
		self.rotation = PI/2 # Rotate 90°
		# Go to the middle of the screen vertically
		self.position.y = Global.screenCenter.y
		
		# Find a random offset within the confines of the bounds of the arena
		self.position.x = findPositionToStrike()
	
	# Prevent run() from executing any further until the zoomTg() function 
	# has finished running. 
	yield(zoomTelegraphClose(), "completed")
	
	# Now that the telegraph is in position, flicker it a bit
	var initial  = 0.1
	var flickers = 6
	var step     = -(initial/flickers)
	
	yield(flickerTelegraph(initial, step, flickers), "completed")
	
	# Shake the screen violently for 2s!
	# (seconds, frequency in ms, max amplitude in px, decrease amplitude over time
	self.get_parent().get_parent().get_node("Camera").shake(2, 600, 4, false)
	
	# Show the laser and activate the hitbox
	$Sprite.show()
	$Hitbox.disabled = false
	
	# Wait 2 seconds for the beam to exist
	yield(get_tree().create_timer(2), "timeout")
	
	# Then just delete the beam. TODO: add fancy effects to this
	self.queue_free()

func findPositionToStrike()->float:
	var centerPos:float
	
	# Get the center of the screen on the appropriate axis
	if beamIsHorizontal:
		centerPos = Global.screenCenter.y
	else:
		centerPos = Global.screenCenter.x
	
	# Random offset between -1 and 1
	var randomOffset:float = (randf() - 0.5) * 2
	
	var finalPosition:float = centerPos + (randomOffset * maxOffset)
	
	return finalPosition

func zoomTelegraphClose():
	# The location at which the indicator will stop after zooming in
	var finalOffset = 335
	
	# The current distance away from the final position that it is at 
	var currentOffset = (1280/2) + (344/2)
	
	# For 60 frames:
	for i in range(0, 60):
		# Move it closer
		currentOffset *= 0.93
		$TelegraphSprite.position.x = finalOffset + currentOffset
		
		yield(get_tree(), "idle_frame") # Wait one frame before continuing

# Flickers the background sprite on and off quickly
func flickerTelegraph(initial, step, count, hideAfter=true):
	var currentTime = initial
	
	if step < 0:
		$TelegraphSprite.hide()
	
	for i in range(0, count*2):
		$TelegraphSprite.hide()
		yield(get_tree().create_timer(currentTime), "timeout")
		currentTime += step
		
		$TelegraphSprite.show()
		yield(get_tree().create_timer(currentTime), "timeout")
	
	if hideAfter:
		$TelegraphSprite.hide()

func gameOver():
	print("game over from in beam\n")
	
	# Stop making new hazards
	self.get_parent().continueHazards = false
