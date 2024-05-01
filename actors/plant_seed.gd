extends Node2D
class_name PlantSeed

func _ready():
    if OS.is_debug_build() and self == get_tree().current_scene:
        self.position = Vector2(200,200)

