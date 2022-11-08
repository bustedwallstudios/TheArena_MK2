extends Node2D

# Reference to all the hazards, so they can be instanced when needed
export (PackedScene) var AxeScene
export (PackedScene) var BeamScene

var allHazards = [
	"axe",
	"beam",
]

# Set to false when the player dies
var continueHazards = true

# This will be used to make each hazard harder to survive in the future
var hazardsSurvived = 0

# Called by World whenever it decides that a hazard should occur
func beginRandomHazard():
	# Update the score text at the top of the screen (it will also
	# deal with fancy shit)
	self.get_parent().get_node("UI/ScoreText").updateText(str(hazardsSurvived))
	
	# If this score is a new record, save it as a highscore
	var prevHighScore = Global.data["highScore"]
	if hazardsSurvived > prevHighScore:
		print("new high score! ////////////////////////")
		Global.data["highScore"] = hazardsSurvived
	
	# Update the timer, so that the more hazards that have spawned, the faster
	# new hazards will come
	$HazardTimer.wait_time = speedUp(hazardsSurvived)
	
	# This will be false if the player dies; the hazards should stop occuring
	if !continueHazards:
		return
	
	#print("Spawning random hazard...")
	
	# A random disaster name in disasters[]
	var currentHazard = allHazards[floor(rand_range(0, len(allHazards)))]
	
	match currentHazard:
		"axe": axe()
		"beam": beam()
	
	hazardsSurvived += 1

func axe():
	#print("Spawning Axe...")
	
	# Create an axe...
	var axe = AxeScene.instance()
	
	# ...and add it to the world
	self.add_child(axe)
	
	# The axe will deal with its own initiation and stuff
	axe.run(hazardsSurvived)

func beam():
	#print("Spawning Beam...")
	
	# Create a beam...
	var beam = BeamScene.instance()
	
	# ...and add it to the world
	self.add_child(beam)
	
	# The beam will deal with its own initiation and stuff
	beam.run(hazardsSurvived)

func speedUp(x):
	# Transformations of a function
	var a = 3
	var k = -0.1
	var d = 0
	var c = 0.5
	
	var y = a*pow(2, k * (x-d)) + c # Find the value of the function at x
	
	# Solved for y
	return y
