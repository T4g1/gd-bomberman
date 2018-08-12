extends KinematicBody2D
var Splosion = load("res://Splosion/Splosion.tscn")


export (int, 0) var chrono = 5

var BASE_POWER = 2
var L_DIRECTION = [
    Vector2(0, 1),
    Vector2(0, -1),
    Vector2(1, 0),
    Vector2(-1, 0)
]

var CROSS = 0
var H = 1
var H_END = 2
var V = 3
var V_END = 4

# How many tiles will the explosion span accross
var power
var timer


func _ready():
    power = BASE_POWER
    timer = Timer.new()
    timer.connect("timeout", self, "_on_explode")
    timer.set_wait_time(chrono)

    add_child(timer)
    timer.start()


func add_splosion(position, direction, is_end):
    var splosion = Splosion.instance()
    splosion.position = position
    splosion.set_direction(direction, is_end)

    var current_scene = get_tree().get_current_scene()
    current_scene.add_child(splosion)
    splosion.set_owner(current_scene)


func _on_explode():
    add_splosion(position, Vector2(0, 0), false)

    for i in range(power):
        for direction in L_DIRECTION:
            add_splosion(
                position + (direction * (i + 1) * 16),
                direction,
                i == power - 1
            )

    queue_free()

    timer.queue_free()


func destroy(destroyer):
    _on_explode()
