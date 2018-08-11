extends Area2D


var HORIZONTAL = Vector2(1, 0)
var VERTICAL = Vector2(0, 1)


func set_direction(direction, is_end):
    if !has_node("AnimatedSprite"):
        return
    var sprite = $AnimatedSprite

    if direction == HORIZONTAL or direction == -HORIZONTAL:
        if is_end:
            sprite.animation = "horizontal_end"
        else:
            sprite.animation = "horizontal"

    if direction == VERTICAL or direction == -VERTICAL:
        if is_end:
            sprite.animation = "vertical_end"
        else:
            sprite.animation = "vertical"
    else:
        sprite.animation = "cross"

    sprite.play()


func _on_animation_finished():
    queue_free()

