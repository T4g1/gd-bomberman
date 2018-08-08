extends AnimatedSprite


signal hit

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

    if velocity.length() > 0:
        if velocity.x > 0:
            animation = "right"
        elif velocity.x < 0:
            animation = "left"
        elif velocity.y > 0:
            animation = "down"
        elif velocity.y < 0:
            animation = "up"

        play()

        velocity = velocity.normalized() * speed
    else:
        var current_animation = animation
        if current_animation == "right":
            animation = "idle_right"
        elif current_animation == "left":
            animation = "idle_left"
        elif current_animation == "up":
            animation = "idle_up"
        elif current_animation == "down":
            animation = "idle_down"

        stop()

    position += velocity * delta
    position.x = clamp(position.x, 0, screensize.x)
    position.y = clamp(position.y, 0, screensize.y)


func _on_area_entered(body):
    print("Player collide")
