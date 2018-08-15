extends KinematicBody2D
var Bomb = load("res://Bomb/Bomb.tscn")


# Moving speed of the player
export (int, 1, 5000) var speed = 75

export (int, 1, 500) var max_bomb_count = 1
export (int, 1, 500) var power = 2

enum SICKNESS {
    NONE,
    INVERSED,
    SLOW,
    WEAK,
    SPAM
}

var screensize
var velocity = Vector2()
var alive = true
var controlable = true setget set_controlable
var sickness = SICKNESS.NONE

export (int, 1, 500) var slow_speed = 40

export (bool) var can_kick = false


func _ready():
    screensize = get_viewport_rect().size


func _process(delta):
    animate()


func _physics_process(delta):
    if velocity.length() == 0 or !alive or !controlable:
        return

    var movement_left = move_and_slide(velocity)
    for i in range(get_slide_count()):
        var collider = get_slide_collision(i).collider
        if collider is Node:
            collide(collider)


func _input(event):
    if !controlable or !alive:
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

    if sickness == SICKNESS.SLOW:
        velocity = velocity.normalized() * slow_speed
    else:
        velocity = velocity.normalized() * speed

    if sickness == SICKNESS.INVERSED:
        velocity *= -1

    if event.is_action_pressed("ui_action") or sickness == SICKNESS.SPAM:
        spawn_bomb()


func _on_animation_finished():
    if alive:
        return

    var current_scene = get_tree().get_current_scene()
    current_scene.game_over()

    queue_free()


func set_controlable(value):
    controlable = value

    $AnimatedSprite.stop()


func collide(collider):
    if collider.is_in_group("Enemy"):
        die()
    elif collider.is_in_group("Bomb") and can_kick:
        # Kicking direction
        var delta = Vector2(
            position.x - collider.position.x,
            position.y - collider.position.y
        )

        var direction

        if delta.abs().x > 8:
            if delta.x <= 0:
                direction = Vector2(-1, 0)
            else:
                direction = Vector2(1, 0)
        else:
            if delta.y <= 0:
                direction = Vector2(0, -1)
            else:
                direction = Vector2(0, 1)

        collider.kick(direction)


func destroy(destroyer):
    die()


func die():
    var sprite = $AnimatedSprite
    sprite.animation = "die"
    sprite.play()

    velocity = Vector2(0, 0)

    alive = false


func animate():
    if !has_node("AnimatedSprite") or !alive or !controlable:
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

    if sickness == SICKNESS.WEAK:
        bomb.power = 1
    else:
        bomb.power = power

    var current_scene = get_tree().get_current_scene()
    current_scene.add_child(bomb)
    bomb.set_owner(self)
    bomb.add_to_group("player_bomb")


func power_up(bonus):
    if sickness != SICKNESS.NONE and bonus != "sick":
        sickness = SICKNESS.NONE
        return

    match bonus:
        "power":
            power += 1
        "speed":
            speed += 35
        "bomb":
            max_bomb_count += 1
        "kick":
            can_kick = true
        "punch":
            print("Not implemented yet")
        "sick":
            var l_sickness = [
                SICKNESS.INVERSED,
                SICKNESS.SLOW,
                SICKNESS.WEAK,
                SICKNESS.SPAM
            ]
            sickness = l_sickness[randi() % l_sickness.size()]
        _:
            print("Wrong power up type: ", bonus)
