extends Node

@export var transition_duration = 1.00
@export var transition_type = 1 # TRANS_SINE



func fade_out(stream_player : AudioStreamPlayer):
    var tween : Tween = get_tree().create_tween()
    # tween music volume down to 0
    var old_volume = stream_player.volume_db
    tween.tween_property(stream_player, "volume_db", -80, transition_duration).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_IN)
    tween.play()
    # when the tween ends, the music will be stopped
    tween.finished.connect(self.stop.bind(stream_player, old_volume))

func fade_in(stream_player : AudioStreamPlayer):
    var tween : Tween = get_tree().create_tween()
    # tween music volume down to 0
    var final_volume = stream_player.volume_db
    stream_player.volume_db = -80
    tween.tween_property(stream_player, "volume_db", final_volume, transition_duration).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_IN)
    tween.play()


func stop(stream_player : AudioStreamPlayer, old_volume : int = 0):
    stream_player.stop()
    stream_player.volume_db = old_volume
