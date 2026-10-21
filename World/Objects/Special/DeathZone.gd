extends Area3D


func on_enter_death_zone(body: Node3D):
	if body.is_in_group("Player"):
		Signals.player_change_state.emit("CrashState")
		StatController.spend_max_stamina(9999)
