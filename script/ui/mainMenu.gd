extends Control

var swoopSpeed = 4

var swoopTopY = -300
var swoopLowY = 720+300

func _ready():
	# Cause all the UI elements to swoop into the scene from outside the screen,
	# to their original positions. (Making it so that they go to where they are
	# means that I don't have to do the work to figure out where I want them,
	# I can just move them around and it will automatically work.)
	
	$Title.swoop(Vector2(0, swoopTopY), $Title.rect_position, swoopSpeed)
	$PlayButton.swoop(Vector2($PlayButton.rect_position.x, swoopTopY), $PlayButton.rect_position, swoopSpeed)
	
	$ChangeIconButton.swoop(Vector2($ChangeIconButton.rect_position.x, swoopLowY), $ChangeIconButton.rect_position, swoopSpeed)
	$HighScore.swoop(Vector2($HighScore.rect_position.x, swoopLowY), $HighScore.rect_position, swoopSpeed)
	
	# Set the high score text TO the high score
	$HighScore/Score.set_text(str(Global.data["highScore"]))

func startGame():
	get_tree().change_scene("res://scenes/World.tscn")

# Move the camera down to focus the change icon screen
func loadChangeIconScreen():
	# Swoop all UI elements up one screen width
	$FocusCamera.swoop($FocusCamera.position, Vector2($FocusCamera.position.x, $FocusCamera.position.y+720))

# Move the camera back up to focus the main screen
func loadMainScreen():
	$FocusCamera.swoop($FocusCamera.position, Vector2($FocusCamera.position.x, $FocusCamera.position.y-720))
