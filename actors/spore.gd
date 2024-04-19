extends Node2D
@onready var animation_player = $AnimationPlayer
@onready var camera_2d = $Camera2D


# Called when the node enters the scene tree for the first time.
func _ready():
    camera_2d.make_current()
    animation_player.play('fly_away', -1, 0.5)

