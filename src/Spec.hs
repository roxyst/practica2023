module Spec where
import PdePreludat
import Library
import Test.Hspec

juli = Persona {nombre = "Julian", edad = 25, nivelStress = 10, amigues = [joni,charly], preferencias = []}
joni = Persona {nombre = "Jonathan", edad = 41, nivelStress = 20, amigues = [juli], preferencias = []}
rigoberta = Persona {nombre = "Rigoberta", edad = 31, nivelStress = 40, amigues = [joni], preferencias = [] }
paulina = Persona {nombre = "Paulina", edad = 18, nivelStress = 50, amigues = [juli, joni], preferencias = []}
paulina' = Persona {nombre = "Paulina", edad = 18, nivelStress = 15, amigues = [juli, joni], preferencias = []}
juan = Persona {nombre = "Juan", edad = 37, nivelStress = 80, amigues = [], preferencias = []}
charly = Persona {nombre = "Carlos", edad = 45, nivelStress = 50, amigues = [juli,juan,joni], preferencias = []}
fer = Persona {nombre = "Fernando", edad = 50, nivelStress = 75, amigues = [juan], preferencias = [] }
david = Persona {nombre = "David", edad = 32, nivelStress = 40, amigues = [], preferencias = []}

correrTests :: IO ()
correrTests = hspec $ do
  describe "Test de funcion puntosDeScoring" $ do
    it "para una persona con cantidad par de amigues" $ do
      puntosDeScoring juli `shouldBe` 250
    it "para una persona mayor a cierta edad" $ do
      puntosDeScoring joni `shouldBe` 41
    it "para una persona que no cumple con ninguna condicion" $ do
      puntosDeScoring rigoberta `shouldBe` 18

  describe "Test de funcion nombreFirme" $ do
    it "para una persona con nombre firme" $ do
      paulina `shouldSatisfy` nombreFirme
    it "para una persona que no tiene nombre firme" $ do
      rigoberta `shouldNotSatisfy` nombreFirme

  describe "Test de funcion personaInteresante" $ do
    it "para una persona que no es interesante" $ do
      rigoberta `shouldNotSatisfy` personaInteresante
    it "para una persona interesante" $ do
      juli `shouldSatisfy` personaInteresante

  describe "Test para el destino Mar del Plata" $ do
    it "para una persona que se va a Mar Del Plata en temporada" $ do
      (nivelStress . marDelPlata 1) joni `shouldBe` 30
    it "para una persona que se va a Mar Del Plata fuera de temporada, sin llegar al minimo del nivel de stress" $ do
      (nivelStress . marDelPlata 3) paulina `shouldBe` 32
    it "para una persona que se va a Mar Del Plata fuera de temporada, llegando al minimo del nivel de stress" $ do
      (nivelStress . marDelPlata 3) paulina' `shouldBe` 0
    it "para una persona que se va a Mar Del Plata fuera de temporada, llegando al maximo de lo que resta el destino" $ do
      (nivelStress . marDelPlata 3) charly `shouldBe` 30

  describe "Test para el destino Las Toninas" $ do
    it "para una persona que se va a las Toninas con plata, cambia su nivel de stress" $ do
      (nivelStress . lasToninas True) fer `shouldBe` 37
    it "para una persona que se va a las Toninas sin plata, cambia su nivel de stress" $ do
      (nivelStress . lasToninas False) fer `shouldBe` 55

  describe "Test para el destino Puerto Madryn" $ do
    it "para una persona que se va a Puerto Madryn, cambia su stress" $ do
      (nivelStress . puertoMadryn juan) david `shouldBe` 0
    it "para una persona que se va a Puerto Madryn, agrega un amigue" $ do
      (cantidadDeAmigues . puertoMadryn juan) david `shouldBe` 1

  describe "Test para el destino La Adela" $ do
    it "para una persona que se va a la Adela, no cambia su stress" $ do
      (nivelStress . laAdela) juan `shouldBe` 80

  describe "Tests para preferencias" $ do
    it "para la preferencia desenchufarse, cuando no se cumple la condición" $ do
      juan `shouldNotSatisfy` desenchufarse (marDelPlata 1)
    it "para la preferencia desenchufarse, cuando se cumple la condición" $ do
      juan `shouldSatisfy` desenchufarse (marDelPlata 3)
    it "para la preferencia enchufarse especial, cuando se cumple la condición" $ do
      rigoberta `shouldSatisfy` enchufarseEspecial 20 (marDelPlata 3)
    it "para la preferencia socializar, cuando se cumple la condición" $ do
      david `shouldSatisfy` socializar (puertoMadryn juan)
    it "para la preferencia socializar, cuando no se cumple la condición" $ do
      david `shouldNotSatisfy` socializar laAdela
    it "para la preferencia sin pretensiones, siempre se cumple la condición" $ do
      paulina `shouldSatisfy` sinPretensiones (marDelPlata 8)