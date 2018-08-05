extends Area2D

# Moving speed of the player
export (int) var speed

var screensize

func _ready():
    screensize = get_viewport_rect().size

func _process(delta):
    var velocity = Vector2()
    if Input.is_action_pressed("ui_right"):
        velocity.x += 1
    if Input.is_action_pressed("ui_left"):
        velocity.x -= 1
    if Input.is_action_pressed("ui_down"):
        velocity.y += 1
    if Input.is_action_pressed("ui_up"):
        velocity.y -= 1

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
            sprite.animation = "iddle_right"
        elif current_animation == "left":
            sprite.animation = "iddle_left"
        elif current_animation == "up":
            sprite.animation = "iddle_up"
        elif current_animation == "down":
            sprite.animation = "iddle_down"

        sprite.stop()

    position += velocity * delta
    position.x = clamp(position.x, 0, screensize.x)
    position.y = clamp(position.y, 0, screensize.y)
