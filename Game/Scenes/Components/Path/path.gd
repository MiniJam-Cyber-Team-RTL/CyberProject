extends Path2D

var progress = true

func _ready() -> void:
	var c = $PathFollow2D.get_child(0)
	if c:
		c.switch_progression.connect(_on_child_switch_progression)

func _process(delta: float) -> void:
	if progress:
		$PathFollow2D.progress += delta * $PathFollow2D.get_child(0).SPEED * 40

func _on_child_switch_progression(value : bool) -> void:
	progress = value
