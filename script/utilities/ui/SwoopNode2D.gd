extends Node2D

var end:Vector2 = self.position

var fadeOut = false
var currentOpacity = 1

func swoop(origin:Vector2, destination:Vector2):
	end = destination # We use the global end here because we need to pass it in in _process()
	self.position = origin # Go directly to the start position

	var vectorToMove = (end - origin) / 10 # Get the location that is 1/10th of the way to endPos

	self.position += vectorToMove # Move that distance

func _process(_delta):
	# We can always swoop no matter what, because end starts as our position so we just don't move
	swoop(self.position, end)

	if self.fadeOut: # If this element shoult start fading out
		self.currentOpacity *= 0.93 # Decrease the current opacity (my variable)

		set_modulate(Color(1, 1, 1, self.currentOpacity)) # Set the actual opacity to currentOpacity

		if self.currentOpacity < 0.01: # If it is extremely transparent
			self.hide() # Hide it outright
			self.fadeOut = false # Stop fading out
			currentOpacity = 1 # Set the currentOpacity back to fully opaque

			# Set the actual opacity to fully opaque (because self.currentOpacity is 1)
			# (It's hidden, so it won't show up anyway)
			set_modulate(Color(1, 1, 1, self.currentOpacity))
