extends Node
var Wall = load("res://Wall/Wall.tscn")
var Player = load("res://Player/Player.tscn")
var Enemy = load("res://Enemy/Enemy.tscn")
var GameOver = load("res://UI/GameOver.tscn")


# Level size
export (int, 5, 50) var width = 10          # Width of the level
export (int, 5, 50) var height = 10         # Height of the level

export (int, 0, 100) var free_space = 5     # Amount of free space in percentage
export (int, 0, 100) var enemy_rate = 50    # Amount of enemy in percentage


func _ready():
    generate_level(false)


func _process(delta):
    var l_enemy = get_tree().get_nodes_in_group("Enemy")
    if l_enemy.size() <= 0:
        game_over()


func game_over():
    if $GameOver:
        return

    $Player.controlable = false

    $Camera2D.make_current()

    $AudioStreamPlayer.stop()

    add_child(GameOver.instance())


func clear_level():
    """
    Remove all Player, Wall from the scene
    """
    var L_REMOVE_GROUP = [
        "Player",
        "Wall"
    ]

    # Remove existing level
    for node in get_children():
        for group_name in L_REMOVE_GROUP:
            if node.is_in_group(group_name):
                node.queue_free()
                break


func generate_level(value):
    """
    Generate a whole new level based on width and height
    """
    clear_level()

    for x in range(width):
        for y in range(height):
            var destroyable = false

            if x == 0 or x == width - 1:
                pass
            elif y == 0 or y == height - 1:
                pass
            # Player spawn
            elif (
                (x == 1 and y == 1) or
                (x == 2 and y == 1) or
                (x == 1 and y == 2) or
                (x == 1 and y == 3)
            ):
                continue
            elif (x % 2) == 0 and (y % 2) == 0:
                pass
            # Free space !
            else:
                destroyable = true

                # Stay free my dear
                if randi() % 100 < free_space:
                    if randi() % 100 < enemy_rate:
                        spawn(Enemy, Vector2(x, y) * 16)
                    continue

            var wall = spawn(Wall, Vector2(x, y) * 16)
            wall.destroyable = destroyable

    # Spawn player
    var player = spawn(Player, Vector2(1, 1) * 16)


func spawn(type, position):
    var instance = type.instance()
    instance.position = position

    add_child(instance)
    instance.set_owner(
        get_tree().get_edited_scene_root()
    )

    return instance
