@tool
extends Sprite2D


#var water_pickup_scene = preload('res://actors/WaterPickup.tscn')
#@onready var sprite_2d = $Sprite2D

@export var produced = true

func _ready():
    pass

func spawn():
    var node = Node2D.new()
    var start_position : Vector2 = Vector2(500,1000)
    
    var light_pickup_scene : PackedScene = preload('res://actors/light_pickup.tscn')
    
    ###var start_position = start_point.global_position
    var light_pickup = light_pickup_scene.instantiate()
    #var water_pickup = water_pickup_scene.instantiate()
    #
    light_pickup.global_position = start_position
    #water_pickup.global_position = light_pickup.global_position + Vector2(0,-100)
    #
    #add_child(water_pickup)
    add_child(node)
    node.add_child(light_pickup)
    #
    node.set_owner(get_tree().get_edited_scene_root())
    light_pickup.set_owner(get_tree().get_edited_scene_root())
    #water_pickup.owner = get_tree().edited_scene_root
    pass


func _process(delta):
    #if not produced:
        #produced = true
        #print('yo')
        #spawn()
        #pass
    rotation += PI * delta
