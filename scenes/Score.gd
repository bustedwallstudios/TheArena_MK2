extends Label


# ADD SCORE FROM LAST GAME
func _process(delta):
	self.text = str(GlobalScore.score)
