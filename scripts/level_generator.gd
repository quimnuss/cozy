@tool
extends Node2D

@export var produced = true

@export var num_branches : Vector2i = Vector2i(1, 2)

@export var num_iterations : int = 1

func clean():
    for child in $Holder.get_children():
        child.queue_free()

func spawn(is_light : bool, num_iterations, spawn_position : Vector2 = Vector2(500,500)):

    var holder : Node2D = $Holder

    var pickup_scene : PackedScene = preload('res://actors/light_pickup.tscn') if is_light else preload('res://actors/WaterPickup.tscn')
    var pickup_name : String = ('Light' if is_light else 'Water') + '_' + str(num_iterations) + '_' + str($Holder.get_child_count())

    var pickup = pickup_scene.instantiate()
    pickup.name = pickup_name

    pickup.global_position = spawn_position

    $Holder.add_child(pickup)

    pickup.set_owner(get_tree().get_edited_scene_root())

    pickup.get_node('PickupName').set_text(pickup.name)

func spawn_light(num_iterations, start_position):
    spawn(true, num_iterations, start_position)

func spawn_water(num_iterations, start_position):
    spawn(false, num_iterations, start_position)

func spawn_chain(num_iterations, start_position : Vector2):
    spawn_light(num_iterations, start_position)
    var last_position : Vector2 = start_position + Vector2(200,-100)
    spawn_water(num_iterations, last_position)
    return last_position

# recursive
func spawn_branch(num_iterations : int, branch_start_position : Vector2):

    if num_iterations <= 0:
        return

    num_iterations -= 1

    #for branch in range(randi() % num_branches[1] + num_branches[0]):
    for branch in range(2):
        branch_start_position = spawn_chain(num_iterations, branch_start_position)
        var sign : int = -1 if branch == 1 else 1
        var angle : float = PI/3 * sign # randf_range(-PI/4, -PI/8)*sign
        prints(num_iterations, branch, rad_to_deg(angle), Vector2(0,-800).rotated(angle), $Holder.get_child_count())
        branch_start_position += Vector2(0,-800).rotated(angle)

        spawn_branch(num_iterations, branch_start_position)

    return branch_start_position


func _process(delta):
    if not produced:
        produced = true
        seed(12345)

        clean()
        spawn_branch(num_iterations, Vector2(500, 500))

    if $Sprite2D:
        $Sprite2D.rotation += PI * delta
