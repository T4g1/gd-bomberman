extends Node
var Wall = load("res://Wall/Wall.tscn")
var Player = load("res://Player/Player.tscn")
var Enemy = load("res://Enemy/Enemy.tscn")


# Level size
export (int, 5, 50) var width = 10          # Width of the level
export (int, 5, 50) var height = 10         # Height of the level

export (int, 0, 100) var free_space = 5     # Amount of free space in percentage


func _ready():
    generate_level(false)


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
                    continue

            var wall_instance = Wall.instance()
            wall_instance.position = Vector2(x, y) * 16
            wall_instance.destroyable = destroyable

            add_child(wall_instance)
            wall_instance.set_owner(
                get_tree().get_edited_scene_root()
            )

    # Spawn player
    var player_instance = Player.instance()

    player_instance.position = Vector2(1, 1) * 16

    add_child(player_instance)
    player_instance.set_owner(
        get_tree().get_edited_scene_root()
    )

    # Center camera
    #camera.position.x = (width * 16) / 2
    #get_viewport().position.y = (height * 16) / 2
