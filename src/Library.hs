module Library where
import PdePreludat

data Persona = Persona {
    nombre :: String,
    edad :: Number,
    nivelStress :: Number,
    preferencias :: [Preferencia],
    amigues :: [Persona]
} deriving (Eq,Show)

-- Punto 1

cantidadDeAmigues :: Persona -> Number
cantidadDeAmigues = length . amigues

puntosDeScoring :: Persona -> Number
puntosDeScoring persona
    | even . cantidadDeAmigues $ persona = nivelStress persona * edad persona
    | (>40) . edad $ persona = cantidadDeAmigues persona * edad persona
    | otherwise = (*2) . length . nombre $ persona

-- Punto 2a

nombreFirme :: Persona -> Bool
nombreFirme = (=='P') . head . nombre

-- Punto 2b

personaInteresante :: Persona -> Bool
personaInteresante = (>=2) . length . amigues

-- Punto 3

type Destino = Persona -> Persona
type Mes = Number

cambiarStress :: Number -> Persona -> Number
cambiarStress deltaStress = max 0 . min 100 . (+ deltaStress) . nivelStress

marDelPlata :: Mes -> Destino
marDelPlata mes persona
    | mes == 1 || mes == 2 = persona {
        nivelStress = cambiarStress 10 persona
    }
    | otherwise = persona {
        nivelStress = cambiarStress (max (negate 20) . negate . edad $ persona) persona
    }

lasToninas :: Bool -> Destino
lasToninas tienePlata persona
    | tienePlata = persona {
        nivelStress = nivelStress persona `div` 2
    }
    | otherwise = marDelPlata 7 persona

puertoMadryn :: Persona -> Destino
puertoMadryn nuevoAmigue persona = persona {
    nivelStress = 0,
    amigues = amigues persona ++ [nuevoAmigue]
}

laAdela :: Destino
laAdela = id

-- Punto 4

type Preferencia = Destino -> Persona -> Bool

desenchufarse :: Preferencia
desenchufarse destino persona = (< nivelStress persona) . nivelStress . destino $ persona

enchufarseEspecial :: Number -> Preferencia
enchufarseEspecial nivelStressEsperado destino = (== nivelStressEsperado) . nivelStress . destino

socializar :: Preferencia
socializar destino persona = (> cantidadDeAmigues persona) . cantidadDeAmigues . destino $ persona

sinPretensiones :: Preferencia
sinPretensiones destino persona = True