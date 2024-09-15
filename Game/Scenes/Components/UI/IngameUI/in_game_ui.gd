extends MarginContainer

func show_power_up(type, value = null):
	match type :
		1: $HBoxContainer/PlayerPowerUps/Damage.show(); if value: update_damage(value)
		2: $HBoxContainer/PlayerPowerUps/Speed.show(); if value: update_speed(value)

func hide_power_up(type):
	match type :
		1: $HBoxContainer/PlayerPowerUps/Damage.hide()
		2: $HBoxContainer/PlayerPowerUps/Speed.hide()

func update_health(value : int):
	$HBoxContainer/PlayerHealth/HBoxContainer/PlayerHealthLabel.text = str(value)

func update_damage(value : int):
	$HBoxContainer/PlayerPowerUps/Damage/HBoxContainer/DamageLabel.text = str(value)

func update_speed(value : int):
	$HBoxContainer/PlayerPowerUps/Speed/HBoxContainer/SpeedLabel.text = str(value)
