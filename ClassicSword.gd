extends Sprite


func _ready():
	pass # Replace with function body.

var zone = false
func _process(delta):
	if zone == true:
		if Input.is_action_pressed("Equip"):
			$"/root/CharacterEquipments".main_weapon = "Classic Sword"
			self.visible = false

func _on_Area2D_body_entered(body):
	
	if(body.name == "FatBoyBody"):
		$Label.visible = true	
		zone = true
		
		
			
	 


func _on_Area2D_body_exited(body):
	$Label.visible = false
	zone = false
	
