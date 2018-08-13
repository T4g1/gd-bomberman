extends KinematicBody2D
var Splosion = load("res://Splosion/Splosion.tscn")


var PLAYER_LAYER_BIT = 1

# Only the Wll and other splosion should be checked
var SPLOSION_MASK = 1 + 16 + 32

var CROSS = 0
var H = 1
var H_END = 2
var V = 3
var V_END = 4

# How many tiles will the explosion span accross
export (int, 1, 5000) var chrono = 5
var power
var timer

export (int, 1, 5000) var speed = 150

# List self created explosions
var l_splosion = []

var velocity = Vector2(0, 0)


func _ready():
    timer = Timer.new()
    timer.connect("timeout", self, "_on_explode")
    timer.set_wait_time(chrono)

    add_child(timer)
    timer.start()


func _physics_process(delta):
    var movement_left = move_and_slide(velocity)
    if get_slide_count():
        velocity = Vector2(0, 0)


func add_splosion(position, direction, is_end):
    var splosion = Splosion.instance()
    splosion.position = position
    splosion.set_direction(direction, is_end)

    var current_scene = get_tree().get_current_scene()
    current_scene.add_child(splosion)
    splosion.set_owner(current_scene)

    l_splosion.append(splosion)

    return splosion


func get_level_position():
    var x = floor((position.x + 8) / 16)
    var y = floor((position.y + 8) / 16)

    return Vector2(x, y)


func _on_explode():
    var space_state = get_world_2d().direct_space_state
    var base_position = get_level_position()

    add_splosion(position, Vector2(0, 0), false)

    # Direction is set to Vector2(0, 0) when expansion in
    # that direction should stop
    var l_direction = [
        Vector2(0, 1),
        Vector2(0, -1),
        Vector2(1, 0),
        Vector2(-1, 0)
    ]

    for i in range(power):
        for j in range(l_direction.size()):
            var direction = l_direction[j]
            if direction.length() == 0:
                continue

            var from = Vector2(
                base_position.x + (direction.x * i),
                base_position.y + (direction.y * i)
            ) * 16
            var to = Vector2(
                base_position.x + (direction.x * (i + 1)),
                base_position.y + (direction.y * (i + 1))
            ) * 16

            var result = space_state.intersect_ray(
                from,
                to,
                l_splosion,
                SPLOSION_MASK
            )

            if result and result.collider:
                var collider = result.collider
                if collider.is_in_group("Destroyable"):
                    collider.destroy(self)

                # Do not add Splosion because there was collision
                l_direction[j] = Vector2(0, 0)
                continue

            var splosion = add_splosion(
                position + (direction * (i + 1) * 16),
                direction,
                i == power - 1
            )
            splosion.add_to_group("splosion power:%d direction:%d" % [i, j])

    queue_free()

    timer.queue_free()


func _on_body_exited(body):
    if body.is_in_group("Player"):
        $CollisionShape2D.disabled = false


func destroy(destroyer):
    _on_explode()


func kick(direction):
    if velocity.x != 0 or velocity.y != 0:
        return

    velocity = direction * -speed
