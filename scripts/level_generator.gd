@tool
extends Node2D

@export var produced = true

func clean():
    for child in $Holder.get_children():
        child.queue_free()

func spawn():
    var start_position : Vector2 = Vector2(500,500)
    
    var light_pickup_scene : PackedScene = preload('res://actors/light_pickup.tscn')
    var water_pickup_scene : PackedScene = preload('res://actors/WaterPickup.tscn')
    
    var light_pickup = light_pickup_scene.instantiate()
    light_pickup.name = 'Light'
    var water_pickup = water_pickup_scene.instantiate()
    water_pickup.name = 'Water'
    
    light_pickup.global_position = start_position + Vector2(0, -100)
    water_pickup.global_position = light_pickup.global_position + Vector2(0,-100)

    $Holder.add_child(light_pickup)
    $Holder.add_child(water_pickup)
    
    light_pickup.set_owner(get_tree().get_edited_scene_root())
    water_pickup.set_owner(get_tree().get_edited_scene_root())

func _process(delta):
    if not produced:
        produced = true
        print('yoo')
        clean()
        spawn()
        pass

    if $Sprite2D:
        $Sprite2D.rotation += PI * delta

