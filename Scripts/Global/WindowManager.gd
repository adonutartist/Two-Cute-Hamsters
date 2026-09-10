extends Node

var win_dim := Vector2i(320, 180)
var win_size := _get_win_size()

func _ready():
	_set_win_size(4)

func _input(event):
	if event.is_action_pressed("ui_F4"):
		_increase_win_size(1)
	if event.is_action_pressed("ui_F5"):
		match DisplayServer.window_get_mode():
			DisplayServer.WINDOW_MODE_WINDOWED:
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
			DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN:
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _increase_win_size(amount: int):
	var newWinSize = win_size + amount

	if newWinSize < 1:
		@warning_ignore("integer_division")
		newWinSize = int(DisplayServer.screen_get_size().x / win_dim.x)

	if Vector2(DisplayServer.screen_get_size()) < Vector2(win_dim.x * newWinSize, win_dim.y * newWinSize):
		newWinSize = 1
	
	_set_win_size(newWinSize)

func _set_win_size(newSizeNum: int):
	# Everything here needs to happen asynchronously: sometimes resizing the window hangs the system for a few milliseconds, causing issues
	await get_tree().process_frame
	
	var oldSize := DisplayServer.window_get_size()
	var newSize := Vector2i(win_dim.x * newSizeNum, win_dim.y * newSizeNum)
	win_size = newSizeNum
	if newSize != oldSize:
		#DisplayServer.border = false
		var newPos = DisplayServer.window_get_position() - (newSize - oldSize) / 2
		# We don’t want the title bar to be out of screen
		var topLeft = Vector2(DisplayServer.screen_get_position()) + Vector2(DisplayServer.screen_get_size().x * .1, 0)
		var bottomRight = DisplayServer.screen_get_position() + Vector2i(DisplayServer.screen_get_size() * .9)
		newPos.x = clamp(newPos.x, topLeft.x - newSize.x, bottomRight.x)
		newPos.y = clamp(newPos.y, topLeft.y, bottomRight.y)
		DisplayServer.window_set_size(newSize)
		DisplayServer.window_set_position(newPos)

func _get_win_size() -> int:
	var vector_size = DisplayServer.window_get_size()
	return int(vector_size.x / win_dim.x)
