extends CanvasLayer

@onready var animation_player = $SceneModulate/AnimationPlayer

func play_win():
    animation_player.play("fade_in")
