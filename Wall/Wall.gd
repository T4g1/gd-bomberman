tool
extends StaticBody2D


# Can the wall be destroyed
export (bool) var destroyable = false setget set_destroyable


func set_destroyable(value):
    destroyable = value

    if has_node("AnimatedSprite"):
        var sprite = $AnimatedSprite

        if destroyable:
            sprite.animation = "wall"
        else:
            sprite.animation = "block"


func get_class():
    return "Wall"


func is_class(type):
    if type == get_class():
        return true
    return .is_type(type)
