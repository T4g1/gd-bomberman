tool
extends StaticBody2D
var PowerUp = load("res://PowerUp/PowerUp.tscn")


# Can the wall be destroyed
export (bool) var destroyable = false setget set_destroyable

export (int) var power_up_chance = 25


func set_destroyable(value):
    destroyable = value

    if has_node("AnimatedSprite"):
        var sprite = $AnimatedSprite

        if destroyable:
            sprite.animation = "wall"
        else:
            sprite.animation = "block"


func destroy(destroyer):
    if !destroyable:
        return

    if randi() % 100 < power_up_chance:
        var power_up = PowerUp.instance()
        power_up.bonus_type = power_up.get_random()
        power_up.position = position

        var current_scene = get_tree().get_current_scene()
        current_scene.add_child(power_up)
        power_up.set_owner(current_scene)

    queue_free()
