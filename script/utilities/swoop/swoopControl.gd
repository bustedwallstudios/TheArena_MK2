extends Control

# The position that the control node will lerp to
var end:Vector2 = self.rect_position
var speed  = 1

# This function will move the control node towards a point. If called from
# somewhere else in the project, endPos will be set from there, specifying a
# new destination.
func swoop(startPos:Vector2, endPos:Vector2, speedScale=1):
	end = endPos
	speed = speedScale
	
	self.rect_position = startPos
	
	# Move part of the way to the end every frame
	# The higher speed scale, the faster it will converge on the end position
	var vectorToMove = (end - startPos) / (10*speed)
	self.rect_position += vectorToMove

# Sync the lerping to the physics loop
func _physics_process(_delta):
	# Every frame, get a little closer to the end position
	swoop(self.rect_position, end, speed)
	

