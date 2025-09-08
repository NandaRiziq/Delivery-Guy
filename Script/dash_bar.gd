extends ProgressBar

@export var max_energy := 100.0
@export var regen_rate := 20.0
@export var dash_threshold := 50.0
@export var disabled_alpha := 0.3
@export var enabled_alpha := 1.0

var dashes_used_since_full := 0
var is_locked := false


func _ready():
	max_value = max_energy
	value = max_energy
	update_alpha()


func set_energy(new_energy: float) -> void:
	value = clamp(new_energy, 0.0, max_value)
	if value >= max_value:
		# Reset lock when fully refilled via external set
		dashes_used_since_full = 0
		is_locked = false
	update_alpha()


func is_ready_to_dash() -> bool:
	# Ready when not locked
	return (not is_locked) and value >= dash_threshold


func can_consume(amount: float) -> bool:
	# Only allow consumption when enough energy
	return is_ready_to_dash() and value >= amount


func consume(amount: float) -> bool:
	if not is_ready_to_dash() or value < amount:
		return false
	value = clamp(value - amount, 0.0, max_value)
	dashes_used_since_full += 1
	if dashes_used_since_full >= 2:
		is_locked = true
	update_alpha()
	return true


func _process(delta: float) -> void:
	if value < max_value:
		value = min(max_value, value + regen_rate * delta)
		if value >= max_value:
			# Fully recovered: reset lock and dash count
			dashes_used_since_full = 0
			is_locked = false
	update_alpha()


func update_alpha() -> void:
	modulate.a = enabled_alpha if is_ready_to_dash() else disabled_alpha


