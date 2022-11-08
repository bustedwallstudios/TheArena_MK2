extends Node

# As soon as the game is loaded, load the save data
func _ready():
	loadGame()

# Various handy utilities for this; tidies up a lot of code that would
# otherwise involve this math and look messier
const screenCenter:Vector2 = Vector2(1280/2, 720/2)

# This is where all the save data is stored, such as high score, balls owned,
# etc etc etc. To use the information here somewhere else in the code, the
# following line can be used:
# var dataValue = Global.data["valueName"]
var data:Dictionary = {
	# The value of any item in this dictionary will only have any effect the first
	# time the game is run. Subsequent runs will simply load the values already
	# saved on the device, overwriting the values shown here immediately.
	"highScore": 0,
}

# Called when any notification happens. In this case the only concern is if
# the game is being closed. If it is, save the game, and then close.
func _notification(notif):
	# If it is closed on Windows or Android, respectively (different notifications
	# are thrown when closing the app on different platforms)
	if notif == MainLoop.NOTIFICATION_WM_QUIT_REQUEST or notif == MainLoop.NOTIFICATION_WM_GO_BACK_REQUEST:
		print("Game closing, saving data")
		# When we close, save the game.
		saveGame()

# These allow us to save information between restarts
func saveGame():
	print("Saving game...")
	# Open a new file
	var saveFile = File.new()
	
	# Link this file to the location in quotes, in write mode 
	saveFile.open("user://thearenasave.save", File.WRITE) #  "user://thearenasave.save"
	
	# Store the save dictionary as a new line in the save file.
	saveFile.store_line(to_json(data))
	saveFile.close()
	
	print("Game saved!")

# Load the game save file, and put the saved values in the data[] dictionary
func loadGame():
	print("Loading save data...")
	
	# Open a new file
	var saveFile = File.new()
	
	# If there is not already a save file for this game
	if not saveFile.file_exists("user://thearenasave.save"):
		print("Save file does not exist! Loaded game with default values.")
		return # Error! We don't have a save to load.
	
	# Open the save file in read mode, to get all the data out
	saveFile.open("user://thearenasave.save", File.READ)
	
	# Get the saved dictionary from the next line in the save file
	var loadedData = parse_json(saveFile.get_line())
	
	# Print the loaded information for debugging purposes.
	print("Game save: " + str(loadedData))
	
	# Put the data we just loaded into the variable that the rest of the game
	# looks at.
	Global.data = loadedData
	
	saveFile.close()
	
	print("Save data loaded!")
