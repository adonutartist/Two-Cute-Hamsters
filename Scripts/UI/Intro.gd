extends Control

const STARTTIME = 1.0
const INTERVAL = 3.0
const SHOWTIME = 0.5

var panel1Shown = false
var panel2Shown = false
var panel3Shown = false



var animationList = [
	"Panel1", "Panel2", "Panel3"
]

@onready var  strips = [$Strip1, $Strip2, $Strip3]
@onready var panelCovers = [$Panel1Cover,$Panel2Cover,$Panel3Cover,$Panel4Cover]


signal next

func _ready() -> void:
	
	for i in get_children():
		if i.is_class("Timer"):
			i.connect("timeout", _next_signal)
	
	for cover in panelCovers:
		cover.modulate = Color.WHITE
	
	$StartTimer.start()
	await next
	for i in strips.size():
		
		for strip in strips:
			strip.hide()
		strips.get(i).show()
		print(strips.get(i).name)
		
		for cover in panelCovers:
			var tween = create_tween()
			tween.tween_property(cover, "modulate", Color.TRANSPARENT, SHOWTIME)
			tween.play()
			print("showing: " + cover.name)
			if cover != $Panel4Cover:
				$PanelIntervalTimer.start()
			await next
		
		if i != 2:
			for cover in panelCovers:
				var tween = create_tween()
				tween.tween_property(cover, "modulate", Color.WHITE, SHOWTIME)
				tween.play()
			await get_tree().create_timer(1).timeout
	await next
	UiCanvasLayer.circle_transition()
	await UiCanvasLayer.transition.transition_finished
	Global.goto_next_level()
	
	

func _next_signal():
	emit_signal("next")

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		for i in get_children():
			if i.is_class("Timer"):
				i.stop()
		_next_signal()
