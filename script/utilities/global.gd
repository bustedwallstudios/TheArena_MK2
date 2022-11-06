extends Node

# Various handy utilities for this; tidies up a lot of code that would
# otherwise involve this math and look messier
const screenCenter:Vector2 = Vector2(1280/2, 720/2)

# The player's last round score, set in the world, and used in the mainmenu for
# the scorebaord.
var lastScore = 0
