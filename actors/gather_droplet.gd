extends Node2D

class_name GatherDroplet

var third_quarters_point : Vector2
var initial_position : Vector2
var target_position : Vector2

const DURATION = 0.7
var elapsed = 0.0

var is_target_in_screen_coords : bool = true

static var gather_droplet_scene = preload('res://actors/gather_droplet.tscn')

static func New(_initial_position, _target_position) -> GatherDroplet:
    var droplet : GatherDroplet = GatherDroplet.new()
    droplet.initial_position = _initial_position
    droplet.global_position = _initial_position
    droplet.target_position = _target_position
    var ortogonal_offset : Vector2 = -_initial_position.direction_to(_target_position).orthogonal()*150
    droplet.third_quarters_point = _initial_position + ortogonal_offset + Vector2(randi_range(-75,75),randi_range(-75, 75))
    droplet.modulate = Color(0.369, 0.808, 0.973)
    return droplet

static func Instantiate(_initial_position : Vector2, _target_position : Vector2) -> GatherDroplet:
    var droplet : GatherDroplet = gather_droplet_scene.instantiate()
    droplet.initial_position = _initial_position
    droplet.global_position = _initial_position
    droplet.target_position = _target_position
    var ortogonal_offset : Vector2 = -_initial_position.direction_to(_target_position).orthogonal()*150
    droplet.third_quarters_point = _initial_position + ortogonal_offset + Vector2(randi_range(-75,75),randi_range(-75, 75))
    droplet.modulate = Color(0.369, 0.808, 0.973)
    return droplet

func _physics_process(delta):
    if elapsed/DURATION > 1:
        #elapsed = 0
        queue_free()
        return
    elapsed += delta
    var target_global_position : Vector2 = target_position
    if is_target_in_screen_coords:
        var screen_tranformer : Transform2D = (get_viewport().get_screen_transform() * get_viewport().get_canvas_transform()).affine_inverse()
        target_global_position = screen_tranformer*target_position
    self.global_position = _quad_beizer(initial_position, third_quarters_point, target_global_position, elapsed/DURATION)

func _quad_beizer(start_vector:Vector2, height_vector:Vector2, end_vector:Vector2, t:float):
    var q0 = start_vector.lerp(height_vector, t)
    var q1 = height_vector.lerp(end_vector, t)
    var r = q0.lerp(q1, t)
    return r
