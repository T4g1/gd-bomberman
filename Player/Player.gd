extends KinematicBody2D
var Bomb = load("res://Bomb/Bomb.tscn")


# Moving speed of the player
export (int) var speed

export (int) var max_bomb_count = 1

var screensize
var velocity = Vector2()
var alive = true


func _ready():
    screensize = get_viewport_rect().size


func _process(delta):
    animate()


func _physics_process(delta):
    var movement_left = move_and_slide(velocity)
    for i in range(get_slide_count()):
        var collider = get_slide_collision(i).collider
        if collider is Node:
            collide(collider)


func _input(event):
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

    if event.is_action_pressed("ui_action"):
        spawn_bomb()


func _on_animation_finished():
    if alive:
        return

    queue_free()


func collide(collider):
    if collider.is_in_group("Enemy"):
        die()


func destroy(destroyer):
    die()


func die():
    var sprite = $AnimatedSprite
    sprite.animation = "die"
    sprite.play()

    alive = false


func animate():
    if !has_node("AnimatedSprite") or !alive:
        return

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


func get_level_position():
    var x = floor((position.x + 8) / 16)
    var y = floor((position.y + 8) / 16)

    return Vector2(x, y)


func spawn_bomb():
    var bomb_count = get_tree().get_nodes_in_group("player_bomb").size()
    if bomb_count >= max_bomb_count:
        return

    var bomb = Bomb.instance()

    bomb.position = get_level_position() * 16

    var current_scene = get_tree().get_current_scene()
    current_scene.add_child(bomb)
    bomb.set_owner(self)
    bomb.add_to_group("player_bomb")
