extends Node2D

var current_stream 

var sfx_2_priority = false

func play_sfx(sfx, volume_db, mute_music):
	if !sfx_2_priority:
		var og_db = $music.volume_db
		if mute_music:
			$music.volume_db = -80
		$sfx.stream = sfx
		$sfx.volume_db = volume_db
		$sfx.play()
		if mute_music:
			while $sfx.playing:
				await get_tree().create_timer(0.1).timeout
			$music.volume_db = og_db
		
func play_sfx_track2(sfx, volume_db, mute_music):
	sfx_2_priority = true
	var og_db = $music.volume_db
	if mute_music:
		$music.volume_db = -80
	$sfx2.stream = sfx
	$sfx2.volume_db = volume_db
	$sfx2.play()
	if mute_music:
		while $sfx2.playing:
			await get_tree().create_timer(0.1).timeout
		$music.volume_db = og_db
	sfx_2_priority = false
	
func play_music(music, volume_db):
	$music.stream = music
	$music.volume_db = volume_db
	$music.play()
	
func stop_music():
	$music.stop()
	$music.stream = null
	$music.volume_db = 0

func _process(delta):
	current_stream = $music.stream
	
func is_playing_sfx():
	return $sfx.playing
