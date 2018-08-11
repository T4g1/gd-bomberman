extends KinematicBody2D


# Moving speed of the enemy
export (int) var speed

var screensize
var velocity = Vector2(0, 0)


func _ready():
    screensize = get_viewport_rect().size


func _process(delta):
    var velocity = Vector2()
    # TODO: AI for enemy

    var sprite = $AnimatedSprite

    if velocity.length() > 0:
        if velocity.x > 0:
            sprite.animation = "right"
        elif velocity.x < 0:
            sprite.animation = "left"
        elif velocity.y > 0:
            sprite.animation = "down"
        elif velocity.y < 0:
            sprite.animation = "up"

        sprite.play()

        velocity = velocity.normalized() * speed
    else:
        var current_animation = sprite.animation
        if current_animation == "right":
            sprite.animation = "idle_right"
        elif current_animation == "left":
            sprite.animation = "idle_left"
        elif current_animation == "up":
            sprite.animation = "idle_up"
        elif current_animation == "down":
            sprite.animation = "idle_down"

        sprite.stop()


func _physics_process(delta):
    pass
    #var collision_info = move_and_collide(velocity * delta)


func get_class():
    return "Enemy"


func is_class(type):
    if type == get_class():
        return true
    return .is_type(type)
