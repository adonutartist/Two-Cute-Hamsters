extends Control

var _music_volume := -10
var _mute_state := 0

var _current_music_player_id := 0
var _current_music := ""

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_mute"):
		_mute_state += 1
		_mute_state = _mute_state % 3
		AudioServer.set_bus_mute(1, _mute_state != 0)
		AudioServer.set_bus_mute(2, _mute_state == 2)

func play_music(music_name: String, fade_previous: bool = false):
	if _current_music == music_name:
		return
	if _current_music != "" and _get_current_music_player().playing:
		if fade_previous:
			await fadeout_music()
		else:
			_get_current_music_player().stop()
		_swap_current_music_player()

	var music_player = _get_current_music_player()
	music_player.stream = load("res://Audio/Music/%s.mp3" % music_name)
	music_player.volume_db = _music_volume
	music_player.play()
	_current_music = music_name
	fadein_music()

func stop_music():
	if _current_music != "" and _get_current_music_player().playing:
		_get_current_music_player().stop()
		_current_music = ""

func fadeout_music():
	await _fade_music_to(-80)

func fadein_music():
	await _fade_music_to(_music_volume)

func _fade_music_to(target_volume: float):
	if _current_music != "":
		if _get_current_music_player().playing:
			var tween = get_tree().create_tween()
			tween.tween_property(_get_current_music_player(), "volume_db", target_volume, 1.0)
			await tween.finished

func _get_current_music_player() -> AudioStreamPlayer:
	return $MusicPlayers.get_node_or_null("MusicPlayer%s" % _current_music_player_id)

func _swap_current_music_player():
	_current_music_player_id = 1 - _current_music_player_id

func set_audio_pitch(speed: float):
	for soundEffect in $Sfx.get_children():
		soundEffect.pitch_scale = speed

func set_sfx_pitch(sfx_channel: String, pitch: float):
	var sfx_node: AudioStreamPlayer = _get_sfx_player(sfx_channel)
	if sfx_node:
		sfx_node.pitch_scale = pitch

func _add_sfx(sfx_name: String, sfx_channel := "", replace: bool = false) -> AudioStreamPlayer:
	var sfx_node: AudioStreamPlayer
	if sfx_channel != "":
		sfx_node = _get_sfx_player(sfx_channel)
	if sfx_node:
		sfx_node.volume_db = 0
	else:
		sfx_node = AudioStreamPlayer.new()
		sfx_node.bus = "SFX"
		if sfx_channel != "":
			sfx_node.name = sfx_channel
		$Sfx.add_child(sfx_node)
		sfx_node.finished.connect(sfx_node.queue_free)
	var new_sfx_path = "res://Audio/SFX/%s.mp3" % sfx_name
	if replace or !sfx_node.playing or sfx_node.stream == null or sfx_node.stream.resource_path != new_sfx_path:
		sfx_node.stream = load(new_sfx_path)
		return sfx_node
	return null

func play_sfx(sfx_name: String, sfx_channel := "", replace: bool = false):
	var sfx_node: AudioStreamPlayer = _add_sfx(sfx_name, sfx_channel, replace)
	if sfx_node:
		sfx_node.play()

func stop_sfx(sfx_channel: String, fade: bool = false):
	var sfx_node: AudioStreamPlayer = _get_sfx_player(sfx_channel)
	if sfx_node and sfx_node.playing:
		if fade:
			var tween = get_tree().create_tween()
			tween.tween_property(sfx_node, "volume_db", -80, 0.5)
			await tween.finished
		if sfx_node:
			sfx_node.stop()

func _get_sfx_player(sfx_channel: String) -> AudioStreamPlayer:
	return $Sfx.get_node_or_null(sfx_channel) as AudioStreamPlayer
