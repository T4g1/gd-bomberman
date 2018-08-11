extends KinematicBody2D


func get_class():
    return "Bomb"


func is_class(type):
    if type == get_class():
        return true
    return .is_type(type)
