extends Node2D


func picked_up(player):
    player.water()
    queue_free()

func _on_area_2d_body_entered(body):
    if body is Player:
        picked_up(body)
