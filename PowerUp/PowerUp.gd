tool
extends Area2D


var L_BONUS_TYPE = [
    "bomb",
    "power",
    "sick",
    "kick",
    #"punch",
    "speed"
]
var L_PROBABILITY = [
    50,
    50,
    10,
    25,
    #25,
    35
]

export (String) var bonus_type = "bomb" setget set_bonus_type


func get_random():
    var total = 0
    for probability in L_PROBABILITY:
        total += probability

    var number = randi() % total

    for i in range(L_PROBABILITY.size()):
        var probability = L_PROBABILITY[i]
        if probability >= number:
            return L_BONUS_TYPE[i]

        number -= probability

    return L_BONUS_TYPE[0]


func set_bonus_type(value):
    if has_node("AnimatedSprite"):
        var sprite = $AnimatedSprite

        if value in L_BONUS_TYPE:
            bonus_type = value
            sprite.animation = bonus_type

        sprite.play()


func _on_body_entered(body):
    if body.is_in_group("Player"):
        body.power_up(bonus_type)
        queue_free()


func destroy(destroyer):
    queue_free()
