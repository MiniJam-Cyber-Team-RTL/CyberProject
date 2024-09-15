extends CanvasLayer

func show_power_up(type, value = null):
	match type :
		1: $MarginContainer/HBoxContainer/PlayerPowerUps/Damage.show(); if value: update_damage(value)
		2: $MarginContainer/HBoxContainer/PlayerPowerUps/Speed.show(); if value: update_speed(value)
		3: $"MarginContainer/HBoxContainer/PlayerPowerUps/Life".show(); if value: update_life(value)

func hide_power_up(type):
	match type :
		1: $MarginContainer/HBoxContainer/PlayerPowerUps/Damage.hide()
		2: $MarginContainer/HBoxContainer/PlayerPowerUps/Speed.hide()
		3: $"MarginContainer/HBoxContainer/PlayerPowerUps/Life".hide()

func update_health(value : int):
	$MarginContainer/HBoxContainer/PlayerHealth/HBoxContainer/PlayerHealthLabel.text = str(value)

func update_damage(value : int):
	$MarginContainer/HBoxContainer/PlayerPowerUps/Damage/HBoxContainer/DamageLabel.text = str(value)

func update_speed(value : int):
	$MarginContainer/HBoxContainer/PlayerPowerUps/Speed/HBoxContainer/SpeedLabel.text = str(value)
	
func update_life(value : int):
	$MarginContainer/HBoxContainer/PlayerPowerUps/Life/HBoxContainer/LifeLabel.text = str(value);
