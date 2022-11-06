extends Control

var swoopSpeed = 4

func _ready():
	# Cause all the UI elements to swoop into the scene from outside the screen,
	# to their original positions. (Making it so that they go to where they are already
	# means that I don't have to do the work to figure out where I want them,
	# I can just move them around and it will automatically work.)
	$Title.swoop(Vector2(0, -300), $Title.rect_position, swoopSpeed)
	$PlayButton.swoop(Vector2($PlayButton.rect_position.x, -300), $PlayButton.rect_position, swoopSpeed)
	$ChangeIconButton.swoop(Vector2($ChangeIconButton.rect_position.x, 720+300), $ChangeIconButton.rect_position, swoopSpeed)

# Called when the "play" button is pressed
func startGame():
	get_tree().change_scene("res://scenes/World.tscn")

# Hides all the elements of the main menu screen, and shows all the elements of
# the icon select screen.
func loadChangeIconScreen():
	# Swoop all UI elements up one screen width
	swoopAllUIElements(Vector2(0, -720))

# Swoops every necessary UI element to the offset relative to its current position.
func swoopAllUIElements(offset:Vector2):
	# Loop over every UI object that is in the "swoop" group,
	# and swoop it 
	for element in get_tree().get_nodes_in_group("swoop"):
		element.swoop(element.rect_position, element.rect_position + offset, 5)
