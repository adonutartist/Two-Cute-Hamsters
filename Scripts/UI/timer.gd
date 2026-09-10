extends Control

const MAXTIME = 120
var time = 0.0
var counting = true
@onready var fontColor = $Node2D/Label2.get_theme_color("font_color")
@onready var outColor = $Node2D/Label2.get_theme_color("font_outline_color")

func _ready() -> void:
	time = MAXTIME
	Shaker.new($Node2D, "position", Vector2.ZERO, 10, 1.0, 0.01, Vector2.ONE, false)
	for i in 5:
		$Node2D/Label2.add_theme_color_override("font_color", outColor)
		$Node2D/Label2.add_theme_color_override("font_outline_color", fontColor)
		await  get_tree().create_timer(0.1).timeout
		$Node2D/Label2.add_theme_color_override("font_color", fontColor)
		$Node2D/Label2.add_theme_color_override("font_outline_color", outColor)
		await  get_tree().create_timer(0.1).timeout
	$Node2D/Label2.hide()


func _process(delta: float) -> void:
	if counting and Global.current_hammy.is_active():
		if time > 0:
			time -= delta
		else:
			time = 0
			counting = false
			Global.current_hammy._die(true)
			Global.got_cheese = false
			UiCanvasLayer.erase_timer_ui()
		update_time_label()
		
func stop_count():
	counting = false

func continue_count():
	counting = true

func update_time_label():
	$Label.text = "Time: " + get_time()

func get_time():
	#var minutes = str(int(time/60))
	var seconds = str(int(time))
	var milliseconds = str(int((time - int(time)) * 100))
	#if len(minutes) < 2:
		#minutes = "0" + minutes
	if len(seconds) < 2:
		seconds = "0" + seconds
	if len(milliseconds) < 2:
		milliseconds = milliseconds + "0"
	var timer = seconds + "." + milliseconds
	return timer
