extends Area2D


var L_BONUS_TYPE = [
    "power",
    "bomb",
    "sick",
    "kick",
    "speed",
    "punch"
]

var bonus_type = "bomb" setget set_bonus_type


func set_bonus_type(value):
    if !has_node("AnimatedSprite"):
        return

    var sprite = $AnimatedSprite

    if value in L_BONUS_TYPE:
        bonus_type = value
        sprite.animation = bonus_type

    sprite.play()


func _on_body_entered(body):
    print(body)
    if body.is_in_group("Player"):
        body.power_up(bonus_type)


func destroy(destroyer):
    queue_free()
