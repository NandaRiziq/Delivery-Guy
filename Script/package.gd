extends Node2D

@onready var sprite = $Sprite2D
@onready var label= $Label

@export var follow_lerp_speed: float = 10.0

var texture_regions: Dictionary = {
    1: Rect2i(112, 0, 16, 16), # normal
    2: Rect2i(128, 16, 16, 16), # blue
    3: Rect2i(128, 0, 16, 16), # green 
    4: Rect2i(112, 16, 16, 16), # purple
}
var package_id : int = 0
var follow_target: Node2D = null


# assign package id and color based on the randomized value from package_giver
func set_package_type(type: int) -> void:
    package_id = type
    print("package_id: ", package_id)
    var rect: Rect2i = texture_regions.get(type, Rect2i(112, 0, 16, 16))
    sprite.region_enabled = true
    sprite.region_rect = rect
    sprite.modulate = Color(1, 1, 1)
    label.text = "id: " + str(package_id)


# package follow player
func start_follow(target: Node2D) -> void:
    follow_target = target


func stop_follow() -> void:
    follow_target = null


func _process(delta: float) -> void:
    if follow_target != null:
        # interpolate package position to target using lerp
        var target_pos: Vector2 = follow_target.global_position
        var weight: float = clamp(follow_lerp_speed * delta, 0.0, 1.0)
        global_position = global_position.lerp(target_pos, weight)