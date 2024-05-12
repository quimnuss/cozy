extends Control

@onready var tutorial_message_dying = $TutorialMessageDying

func _input(event):
    if is_instance_valid(tutorial_message_dying) and tutorial_message_dying.visible:
        if event.is_action_pressed("main_action") or event.is_action_pressed("move_up"):
            tutorial_message_dying.queue_free()

func _on_player_death():
    tutorial_message_dying.visible = true
