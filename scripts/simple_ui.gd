extends CanvasLayer

@onready var light_label = $VBoxContainer/LightLabel
@onready var water_label = $VBoxContainer/WaterLabel


func _process(delta):
    var player = $"../Player" as Player
    if player:
        light_label.text = str(int(player.light_level))
        water_label.text = str(int(player.water_level))
