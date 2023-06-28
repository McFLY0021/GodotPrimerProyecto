extends Node
export (PackedScene) var Mot
var score
signal ga


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func game_over():
	$Music.stop()
	$GameOverSound.play()
	get_tree().call_group("nuevo","queue_free")
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	
	emit_signal("ga")
	
func new_game():
	$Music.play()
	score=0
	$HUD/ScoreLabel.show()
	
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_mensaje("Preparate perrrrro")


func _on_StartTimer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()


func _on_ScoreTimer_timeout():
	score+=1
	if emit_signal("ga")==true:
		score=0
	$HUD.update_score(score)
	


func _on_MobTimer_timeout():
	#seleccionar una localizacion random en el path 2D
	$MobPath/MobSpawnLocation.offset=randi()
	#crear una instancia de mob y añadirla a la escena
	var mob= Mot.instance()
	add_child(mob)
	#poner la direccion de mob perpendicular a la direccion del path
	var direction=$MobPath/MobSpawnLocation.rotation + PI/2
	#poner la posicion del mob en una localizacion random
	mob.position= $MobPath/MobSpawnLocation.position
	#agregar direcciones random
	direction+= rand_range(-PI/4,PI/4)
	mob.rotation=direction
	mob.linear_velocity = Vector2(rand_range(mob.min_speed,mob.max_speed),0)
	mob.linear_velocity = mob.linear_velocity.rotated(direction)
	
	
	
