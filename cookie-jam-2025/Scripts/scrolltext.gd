extends RichTextLabel

# Ustawienie referencji do paska postępu (Musisz dostosować ścieżkę do swojego drzewa scen)
# Assuming the ProgressBar is a sibling (a common setup)
@onready var luck_bar: ProgressBar = $"../LuckBar" # <-- Zmień na właściwą ścieżkę!

# Stałe do sterowania wyglądem i efektem pulsowania
const MIN_ALPHA: float = 0.3  # Minimalna przezroczystość (nie znika całkowicie)
const MAX_ALPHA: float = 1.0  # Maksymalna przezroczystość
const BASE_SPEED: float = 1.5 # Podstawowa prędkość pulsowania
@export var appear_time = 30
func _ready() -> void:
	# Ukryj na początku, jeśli wartość jest wysoka
	self.modulate.a = 0.0

func _process(delta: float) -> void:
	# 1. Sprawdzenie, czy pasek istnieje
	if not is_instance_valid(luck_bar):
		return

	var current_value = luck_bar.value
	var max_value = luck_bar.max_value
	
	# 2. Logika widoczności i pulsowania
	if current_value < appear_time:
		# Normalizacja wartości, gdzie 50 = 0.0 (wolno), a 0 = 1.0 (szybko)
		# Im bliżej 0, tym "factor" jest większy
		var danger_factor: float = (appear_time - current_value) / appear_time
		
		# Obliczanie bieżącej prędkości pulsowania
		# Prędkość będzie od BASE_SPEED (przy 50) do BASE_SPEED * 5 (przy 0)
		var pulse_speed = BASE_SPEED + (danger_factor * BASE_SPEED * 4.0) 
		
		# Użycie funkcji sinus do uzyskania efektu fali (pulsowania)
		# Time.get_ticks_msec() zwraca czas w milisekundach
		var sine_wave = sin(Time.get_ticks_msec() / 1000.0 * pulse_speed)
		
		# Mapowanie fali sinusoidalnej (od -1 do 1) na zakres przezroczystości (od MIN_ALPHA do MAX_ALPHA)
		var new_alpha = lerp(MIN_ALPHA, MAX_ALPHA, (sine_wave + 1.0) / 2.0)
		
		# Ustawienie przezroczystości
		self.modulate.a = new_alpha
		
	else:
		# Pasek jest powyżej 50, stopniowo ukrywamy tekst
		# Używamy lerp, aby płynnie zanikał
		self.modulate.a = lerp(self.modulate.a, 0.0, 5.0 * delta)
