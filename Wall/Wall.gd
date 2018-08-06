tool
extends Area2D


signal hit

# Can the wall be destroyed
export (bool) var destroyable = false setget set_destroyable


func _ready():
    if get_tree().is_editor_hint():
        return

    pass


func _on_area_entered(body):
    print("Wall collide")


func set_destroyable(value):
    var sprite = $AnimatedSprite
    destroyable = value
    if destroyable:
        sprite.animation = "wall"
    else:
        sprite.animation = "block"
