extends Node2D
@onready var player = $Player
@onready var water_level : ProgressBar = $UI/CenterContainer/GridContainer/WaterProgressBar
@onready var light_level : ProgressBar = $UI/CenterContainer/GridContainer/LightProgressBar
@onready var start_position = $StartPosition
@onready var trail_man = $TrailMan


# Called when the node enters the scene tree for the first time.
func _ready():
    #player.water_changed.connect(water_level.set_value_no_signal)
    #player.light_changed.connect(light_level.set_value_no_signal)
    pass


func _process(delta):
    water_level.set_value_no_signal(player.water_level)
    light_level.set_value_no_signal(player.light_level)

func respawn():
    trail_man.to_freezer()
    player.global_position = start_position.global_position
    player.respawn()

func _on_player_death():
    respawn()
