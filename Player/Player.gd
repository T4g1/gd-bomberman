extends KinematicBody2D


# Moving speed of the player
export (int) var speed

var screensize
var velocity = Vector2()
var alive = true
var timer


func _ready():
    screensize = get_viewport_rect().size


func _physics_process(delta):
    get_input()
    var movement_left = move_and_slide(velocity)
    for i in range(get_slide_count()):
        var collision = get_slide_collision(i)
        if collision.collider.get_class() == "Enemy":
            die()


func die():
    var sprite = $AnimatedSprite
    sprite.animation = "die"
    sprite.play()

    alive = false


func _on_animation_finished():
    timer = Timer.new()
    timer.connect("timeout", self, "_on_dead")
    timer.set_wait_time(0.1)

    add_child(timer)
    timer.start()


func _on_dead():
    timer.queue_free()

    if alive:
        return

    queue_free()


func get_input():
    if !alive:
        return

    velocity = Vector2()
    if Input.is_action_pressed("ui_right"):
        velocity.x += 1
    if Input.is_action_pressed("ui_left"):
        velocity.x -= 1
    if Input.is_action_pressed("ui_down"):
        velocity.y += 1
    if Input.is_action_pressed("ui_up"):
        velocity.y -= 1

    velocity = velocity.normalized() * speed

    # animation
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


func get_class():
    return "Player"


func is_class(type):
    if type == get_class():
        return true
    return .is_type(type)

