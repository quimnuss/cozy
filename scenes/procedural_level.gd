extends Node2D

@onready var start_point = $StartPoint
@onready var player = $Player
@onready var trail_man = $TrailMan


func _ready():
    player.global_position = start_point.global_position

func _process(delta):
    if Input.is_action_just_pressed("respawn"):
        player.global_position = start_point.global_position
        player.respawn()
        trail_man.to_freezer()
