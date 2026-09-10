extends Control

func _ready() -> void:
	$AnimationPlayer.play("FadeIn")
	$AnimationPlayer.queue("FadeOut")
	$AnimationPlayer.queue("CreditsFadeIn")
	$AnimationPlayer.queue("CreditsFadeOut")
	
var skio = false


func _process(_delta: float) -> void:
	if !skio and (Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("ui_cancel")):
		goto_game()

func goto_game():
	if !skio:
		skio = true
		UiCanvasLayer.circle_transition()
		await UiCanvasLayer.transition.transition_finished
		Global.change_scenes("Title Screen")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "CreditsFadeOut":
		goto_game()
