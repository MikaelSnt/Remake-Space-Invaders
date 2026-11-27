extends Area2D
class_name attack_base
@export_group("Dano e Movimento") # Deixar mais bonito 
@export var velocidade: float = 500.0
@export var dano: int = 1
@export var direcao: int  =  -1 # 1 = baixo , -1 = cima pq no godot o y cresce para baixo ai fica trocado assim 


func _ready() -> void:
	area_entered.connect(_on_area_entered)
	body_entered.connect(_on_body_entered)

func _physics_process(delta: float) -> void:
	position.y += direcao * velocidade * delta #Só y pq o x vai ser o proprio player movendo que vai mudar ele 
	
func _on_area_entered(area: Area2D) -> void: # Para dar dano nos inimigos
	if area.is_in_group("inimigo") or area.is_in_group("escudos"):
		area.receber_dano(dano)
		queue_free()
	if area.is_in_group("limites_tela") or area.is_in_group("tiros") :
		queue_free()
func _on_body_entered(body: Node2D) -> void:#Para inimigos que atiram dps 
	if body.is_in_group("player"):
			body.receber_dano_player(dano)
			queue_free()
