extends Area2D
class_name attack_base
@export_group("Dano e Movimento") # Deixar mais bonito 
@export var velocidade: float = 500.0
@export var dano: int = 1
@export var direcao: int  =  -1 # 1 = baixo , -1 = cima pq no godot o y cresce para baixo ai fica trocado assim 

func _physics_process(delta: float) -> void:
	position.y += direcao * velocidade * delta #Só y pq o x vai ser o proprio player movendo que vai mudar ele 
