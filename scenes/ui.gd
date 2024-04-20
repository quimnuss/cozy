extends CanvasLayer

@onready var water_progress_bar = %WaterProgressBar



func update_meters():
    water_progress_bar.custom_minimum_size.x = 300


func _on_player_build_changed():
    update_meters()
