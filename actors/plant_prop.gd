extends Node2D

class_name PlantProp

@onready var sprite_2d : Sprite2D = $Sprite2D

@export var PROP_VARIATIONS : int = 8

func _ready():
    randomize()
    #num_frames = sprite_2d.hframes*sprite_2d.vframes
    sprite_2d.frame = randi_range(0,PROP_VARIATIONS)
