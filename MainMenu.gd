extends Control


#Quit 
func _on_quit_pressed():
	
	get_tree().quit()

#Options 
func _on_options_pressed():
	print("Yet to be implemented")

#Play 
func _on_play_pressed():
	get_tree().change_scene_to_file("res://Scenes/Main.tscn")


