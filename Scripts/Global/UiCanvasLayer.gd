extends CanvasLayer

@onready var TransitionUI = preload("res://UI/Transition.tscn")
@onready var TammyUI = preload("res://UI/TammyUI.tscn")
@onready var vignette_ui = preload("res://UI/vignette.tscn")
@onready var TimerUI = preload("res://UI/Timer.tscn")

var transition : Transition = null
var tammy_ui = null
var vignette = null
var timer = null

func add_tammy_ui():
	erase_tammy_ui()
	tammy_ui = TammyUI.instantiate()
	add_child(tammy_ui)

func erase_tammy_ui():
	if tammy_ui != null:
		tammy_ui.queue_free()
		tammy_ui = null

func add_vignette_ui():
	erase_vignette_ui()
	vignette = vignette_ui.instantiate()
	add_child(vignette)

func erase_vignette_ui():
	if vignette != null:
		vignette.queue_free()
		vignette = null

func add_timer_ui():
	erase_timer_ui()
	timer = TimerUI.instantiate()
	add_child(timer)

func erase_timer_ui():
	if timer != null:
		timer.queue_free()
		timer = null

func erase_transition():
	if transition != null:
		transition.queue_free()
		transition = null

func circle_in():
	erase_transition()
	var transitionUI = TransitionUI.instantiate()
	add_child(transitionUI)
	transition = transitionUI
	transition.circlein()

func circle_out():
	if transition != null:
		transition.circleout()
		transition.connect("transition_finished", remove_transition)

func fade_in():
	erase_transition()
	var transitionUI = TransitionUI.instantiate()
	add_child(transitionUI)
	transition = transitionUI
	transition.fadein()

func fade_out():
	if transition != null:
		transition.fadeout()
		transition.connect("transition_finished", remove_transition)

func remove_transition():
	transition.queue_free()
	transition = null

func circle_transition():
	if transition == null:
		var transitionUI = TransitionUI.instantiate()
		add_child(transitionUI)
		transition = transitionUI
		transition.circlein()
		await transition.transition_finished
		transition.circleout()
		await transition.transition_finished
		remove_transition()

func fade_transition():
	if transition == null:
		var transitionUI = TransitionUI.instantiate()
		add_child(transitionUI)
		transition = transitionUI
		transition.fadein()
		await transition.transition_finished
		transition.fadeout()
		await transition.transition_finished
		remove_transition()
