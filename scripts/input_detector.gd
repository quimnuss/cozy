extends Node

class_name InputDetector

enum InputType {NONE, KEYBOARD, JOY, MOUSE}

var input_type : InputType = InputType.NONE

signal input_type_changed(new_input_type : InputType)

func _input(event):
    if not event.is_action_pressed("initial_sprout"):
        return

    if event is InputEventKey:
        input_type = InputType.KEYBOARD
    elif event is InputEventJoypadButton:
        input_type = InputType.JOY
    elif event is InputEventMouseButton:
        input_type = InputType.MOUSE
    else:
        return

    if input_type == InputType.MOUSE:
        Global.mouse_movement = true
    else:
        Global.mouse_movement = false

    input_type_changed.emit(input_type)

