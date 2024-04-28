extends Resource

@export var species : String
@export var name : String

### STATS
@export var hp : int
@export var atk : int
@export var def : int
@export var spatk : int # spatk, spdef wasnt in gen 1
@export var spdef : int
@export var speed : int

# ik this is a "GEN 1/2" engine, but gen 3's iv/ev calculations make more sense
var hp_iv : int
var atk_iv : int
var def_iv : int
var spatk_iv : int
var spdef_iv : int
var speed_iv : int

var hp_ev : int
var atk_ev : int
var def_ev : int
var spatk_ev : int
var spdef_ev : int
var speed_ev : int
