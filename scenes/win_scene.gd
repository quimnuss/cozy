extends CanvasLayer

@onready var animation_player = $SceneModulate/AnimationPlayer

func play_win():
    animation_player.play("fade_in")
    await get_tree().create_timer(6).timeout
    #get_viewport().get_camera_2d().global_position = %StartPosition.global_position

