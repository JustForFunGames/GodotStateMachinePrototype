extends Timer


func _on_timeout():
	get_tree().call_group("Wait", "on_timeout_wait")