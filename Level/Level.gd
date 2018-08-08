tool
extends Node


# Level size
export (int, 5, 50) var width = 10
export (int, 5, 50) var height = 10

export (int, 0, 100) var free_space = 5

export (bool) var generate_level_button = false setget generate_level

export (String, FILE) var wall_path
export (String, FILE) var player_path
export (String, FILE) var enemy_path


func _ready():
    if Engine.editor_hint:
        return

    generate_level(false)


func generate_level(value):
    """
    Generate a whole new level based on width and height
    """
    if !wall_path:
        return
    if !player_path:
        return
    if !enemy_path:
        return

    # Remove existing level
    for node in get_children():
        node.queue_free()

    var wall_class = load(wall_path)
    var player_class = load(player_path)
    var enemy_class = load(enemy_path)

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
                (x == 1 and y == 2)
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

            var wall_instance = wall_class.instance()
            wall_instance.position.x = (x + 1) * 16
            wall_instance.position.y = (y + 1) * 16

            wall_instance.destroyable = destroyable

            add_child(wall_instance)
            wall_instance.set_owner(
                get_tree().get_edited_scene_root()
            )

    # Spawn player
    var player_instance = player_class.instance()

    player_instance.position.x = 16 * 2
    player_instance.position.y = 16 * 2 - 8

    add_child(player_instance)
    player_instance.set_owner(
        get_tree().get_edited_scene_root()
    )
