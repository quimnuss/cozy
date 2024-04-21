extends Node


func fade_out(stream_player : AudioStreamPlayer, transition_duration = 1):
    var tween : Tween = get_tree().create_tween()
    var old_volume = stream_player.volume_db
    tween.tween_property(stream_player, "volume_db", -80, transition_duration).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_IN)
    tween.play()
    tween.finished.connect(self.stop.bind(stream_player, old_volume))

func fade_in(stream_player_in : AudioStreamPlayer, transition_duration = 1):
    var tween : Tween = get_tree().create_tween()
    # tween music volume down to 0
    var final_volume = stream_player_in.volume_db
    stream_player_in.volume_db = -80
    stream_player_in.play()
    tween.tween_property(stream_player_in, "volume_db", final_volume, transition_duration).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
    tween.play()


func stop(stream_player : AudioStreamPlayer, old_volume : int = 0):
    stream_player.stop()
    stream_player.volume_db = old_volume
