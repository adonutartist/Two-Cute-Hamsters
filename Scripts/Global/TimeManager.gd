extends Node

const MAXTIME := 2000
const LOOPAPPROACHPOINT := 100


signal time_changed
signal looped
var time:= 0.0

func add_time(amount: float):
	time += amount
	if time > MAXTIME:
		time -= MAXTIME
		emit_signal("looped")
	if time < 0:
		time += MAXTIME
		emit_signal("looped")
	emit_signal("time_changed")

func set_time(amount: float):
	time = amount
	if time > MAXTIME:
		time -= MAXTIME
	if time < 0:
		time += MAXTIME
	emit_signal("time_changed")

func get_current_time() -> float:
	return time

func get_point_in_time(value) -> float:
	return time/MAXTIME * value

func get_distance_from_loop_point() -> float:
	return min(abs(TimeManager.MAXTIME - TimeManager.get_current_time()), TimeManager.get_current_time())

func is_approaching_loop() -> bool:
	return get_distance_from_loop_point() < LOOPAPPROACHPOINT
