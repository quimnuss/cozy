extends CanvasLayer

@onready var water_level = %WaterProgressBar
@onready var light_level = %LightProgressBar



func update_meters():
    water_level.custom_minimum_size.x = 100 + Global.player.max_water_level
    light_level.custom_minimum_size.x = 100 + Global.player.max_light_level

func set_water_level(water_level_value):
    water_level.set_value_no_signal(water_level_value)

func set_light_level(light_level_value):
    light_level.set_value_no_signal(light_level_value)

func _on_player_build_changed():
    update_meters()
