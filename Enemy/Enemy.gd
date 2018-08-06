extends Area2D


signal hit

# Moving speed of the enemy
export (int) var speed

var screensize


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

    position += velocity * delta
    position.x = clamp(position.x, 0, screensize.x)
    position.y = clamp(position.y, 0, screensize.y)


func _on_area_entered(body):
    print("Enemy collide")
