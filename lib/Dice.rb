#encoding:utf-8

require_relative 'GameCharacter'

module Deepspace

  # Esta clase implementa todo lo que tiene que ver con el azar

  class Dice
    
    # Constructor. Sin parámetros
    
    def initialize
       @NHANGARSPROB = 0.25
       @NSHIELDSPROB = 0.25
       @NWEAPONSPROB = 0.33
       @FIRSTSHOTPROB = 0.5
       @EXTRAEFFICIENCYPROB = 0.8
       @LOSECOLLABORATORPROB = 0.05
       @generator = Random.new
    end
    
    # Decide el número de hangares con probabilidad de tener 1 
    # igual a @NHANGARSPROB
    
    def initWithNHangars
      r = @generator.rand(0.0..1.0)
      if r < @NHANGARSPROB
        return 0
      else
        return 1
      end
    end
    
    # Decide el número de armas con probabilidades @NWEAPONSPROB de tener 1 
    # y 2@NWEAPONSPROB de tener 2. En otro caso, tendrá 3
    
    def initWithNWeapons
      r = @generator.rand(0.0..1.0)
      if r < @NWEAPONSPROB
        return 1
      elsif r < 2 * @NWEAPONSPROB
        return 2
      else
        return 3
      end
    end
    
    # Decide el número de escudos con probabilidad @FIRSTSHOTPROB
    
    def initWithNShields
      r = @generator.rand(0.0..1.0)
      if r < @NSHIELDSPROB
        return 0
      else
        return 1
      end
    end
    
    def whoStarts(nPlayers)
      @generator.rand(nPlayers)
    end
    
    # Decide si la estación dispara primero con probabilidad 
    # @FIRSTSHOTPROB. En otro caso dispara primero la nave enemiga
    
    def firstShot
      r = @generator.rand(0.0..1.0)
      if r < @FIRSTSHOTPROB
        return GameCharacter::SPACESTATION
      else
        return GameCharacter::ENEMYSTARSHIP
      end
    end
    
    # Decide con probabilidad speed si la estación se mueve
    
    def spaceStationMoves(speed)
      r = @generator.rand(0.0..1.0)
      if r < speed
        return true
      else
        return false
      end
    end
    
    # Decide si la estacion beta va a actuar con potencia extra o no
    
    def extraEfficiency
      r = @generator.rand(0.0..1.0)
      if r < @EXTRAEFFICIENCYPROB
        return true
      else
        return false
      end
    end
    
    def loseCollaborator
      r = @generator.rand(0.0..1.0)
      if r < @LOSECOLLABORATORPROB
        return true
      else
        return false
      end
    end
    
    def whatCollaboratorLose(collaborators)
      @generator.rand(collaborators.size)
    end
    
    
    # Crea un string con los datos de la instancia, con objetivos de depuración
    
    def to_s
       resultado = "NHANGARSPROB = #{@NHANGARSPROB}\t"
       resultado += "NSHIELDSPROB = #{@NSHIELDSPROB}\t"
       resultado += "NWEAPONSPROB = #{@NWEAPONSPROB}\t"
       resultado += "FIRSTSHOTPROB = #{@FIRSTSHOTPROB}\t"
       resultado += "EXTRAEFFICIENCYPROB = #{@EXTRAEFFICIENCYPROB}\t"
       #resultado += "generator = #{@generator}"
       resultado
    end
    
    
  end
=begin
    # pruebas
    dado = Dice.new
    puts dado
    puts dado.extraEfficiency
    puts dado.initWithNHangars
    puts dado.initWithNWeapons
    puts dado.initWithNShields
    puts dado.whoStarts(24)
    puts dado.firstShot
    puts dado.spaceStationMoves(0.8)
=end
  
  
  
end
