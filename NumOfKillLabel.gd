extends Label

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.text = String($"/root/PlayerStats".num_of_kill_points)

