extends CanvasLayer

func update_health(new_value : int):
	$MarginContainer/HBoxContainer/PlayerHealth.text = new_value
	
func show_power_up(type):
	match type :
		1: $MarginContainer/HBoxContainer/PlayerPowerUps/Damage.show()
		2: $MarginContainer/HBoxContainer/PlayerPowerUps/Speed.show()
		3: $"MarginContainer/HBoxContainer/PlayerPowerUps/Life".show()

func hide_power_up(type):
	match type :
		1: $MarginContainer/HBoxContainer/PlayerPowerUps/Damage.hide()
		2: $MarginContainer/HBoxContainer/PlayerPowerUps/Speed.hide()
		3: $"MarginContainer/HBoxContainer/PlayerPowerUps/Life".hide()
