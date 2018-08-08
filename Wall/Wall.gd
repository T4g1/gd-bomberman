tool
extends AnimatedSprite


signal hit

# Can the wall be destroyed
export (bool) var destroyable = false setget set_destroyable


func _ready():
    if Engine.editor_hint:
        return

    pass


func _on_area_entered(body):
    pass
    #print("Wall collide")


func set_destroyable(value):
    destroyable = value
    if destroyable:
        animation = "wall"
    else:
        animation = "block"
