extends CanvasLayer

@onready var water_level = %WaterProgressBar
@onready var light_level = %LightProgressBar

@onready var menu = $Menu

func update_meters():
    water_level.custom_minimum_size.x = 100 + Global.player.max_water_level
    light_level.custom_minimum_size.x = 100 + Global.player.max_light_level

func set_water_level(water_level_value):
    water_level.set_value_no_signal(water_level_value)

func set_light_level(light_level_value):
    light_level.set_value_no_signal(light_level_value)

func _on_player_build_changed():
    update_meters()

func _on_settings_button_pressed():
    menu.visible = not menu.visible


func _on_close_settings_pressed():
    menu.visible = false

func _on_distance_changed(goal_num : int, new_distance : float):
    match goal_num:
        0:
            $MarginContainer/HBoxContainer/VBoxContainer/Goal0._on_goal_distance_changed(new_distance)
        1:
            $MarginContainer/HBoxContainer/VBoxContainer/Goal1._on_goal_distance_changed(new_distance)
        2:
            $MarginContainer/HBoxContainer/VBoxContainer/Goal2._on_goal_distance_changed(new_distance)
        3:
            $MarginContainer/HBoxContainer/VBoxContainer/Goal3._on_goal_distance_changed(new_distance)



func _on_goal_reached(goal_num):
    match goal_num:
        0:
            $MarginContainer/HBoxContainer/VBoxContainer/Goal0._on_goal_reached(goal_num)
        1:
            $MarginContainer/HBoxContainer/VBoxContainer/Goal1._on_goal_reached(goal_num)
        2:
            $MarginContainer/HBoxContainer/VBoxContainer/Goal2._on_goal_reached(goal_num)
        3:
            $MarginContainer/HBoxContainer/VBoxContainer/Goal3._on_goal_reached(goal_num)
