extends CanvasLayer

@onready var water_progress_bar = %WaterProgressBar
@onready var light_progress_bar = %LightProgressBar



func update_meters():
    water_progress_bar.custom_minimum_size.x = 100 + Global.player.max_water_level
    light_progress_bar.custom_minimum_size.x = 100 + Global.player.max_light_level

func _on_player_build_changed():
    update_meters()
