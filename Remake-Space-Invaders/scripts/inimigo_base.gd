extends Area2D
class_name Inimigo_base #Criando uma class base 

@export_group("Movimentação") #para ficar bonitinho quando a gente for mexer 
@export var velocidade: float = 80.0
@export var tempo_para_virar: float = 2.0 # Segundos andando para um lado antes de voltar
@export var descida: float = 20. # Quanto desce quando ele voltar  

@export var direcao: int = 1 # 1 = direita, -1 = esquerda
var cronometro: float = 0.0 # em float pq da para contar melhor 

func _physics_process(delta: float) -> void:
	position.x += direcao * velocidade * delta # Movimenta de lado 
	cronometro += delta # Conta o tempo 
	if cronometro >= tempo_para_virar: # Quando for igual ao tempo de virar vai zerar o cronômetro, inverter o lado e descer
		cronometro = 0.0
		direcao *= -1
		position.y += descida
