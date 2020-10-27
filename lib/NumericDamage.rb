#encoding:utf-8

require_relative 'Damage'
require_relative 'NumericDamageToUI'

module Deepspace
  
    # Esta clase implementa el daño que puede recibir una estación espacial, siempre de tipo numérico
    
  class NumericDamage < Damage
    
    # Constructor con el número de armas y escudos que perder
    
    def initialize(nWeapons, nShields)
      if not argumentos_correctos?(nWeapons, nShields)
        raise ArgumentError.new("Error en los argumentos de NumericDamage")
      end
      super(nShields)
      @nWeapons = nWeapons
    end
    
    # Método que copia el daño
    
    def copy
      self.class.new(self.nWeapons, self.nShields)
    end
    
    # Reduce @nWeapons y @nShields para que no sean mayor que w y s
    
    def adjust(w, s)
      newNWeapons = [w.size, @nWeapons].min
      newNShields = [s.size, @nShields].min
      self.class.new(newNWeapons, newNShields)
    end
    
    
    # Decrementamos en una 
    # unidad el contador del número de armas @nWeapons si es positivo
    
    def discardWeapon(w)
      if @nWeapons > 0
        @nWeapons-=1
      end
    end
    
    
    # Determina si el daño tiene efecto o no
    
    def hasNoEffect
      super and (@nWeapons == 0)
    end
    
    
    
    # Comprueba que los parámetros son correctos
    
    def argumentos_correctos?(w, s)
      if not super s
        resultado = false
      elsif not nweapons_correcto? w
        resultado = false
      else
        resultado = true
      end
      resultado
    end
    
    # Comprueba si el número de armas es correcto
    
    def nweapons_correcto?(w)
      if not w.is_a? Integer
        resultado = false
      elsif not w >= 0
        resultado = false
      else
        resultado = true
      end
      resultado
    end
    
    # Devuelve una interfaz de usuario
    
    def getUIversion
      NumericDamageToUI.new(self)
    end
    
    # Crea un string con los datos de la instancia, con objetivos de depuración
    
    def to_s
      resultado = super
      resultado += "\tNúmero de armas: #{@nWeapons}"
      resultado
    end
    
    public_class_method :new
    private :argumentos_correctos?, :nweapons_correcto?
     
    # Consultores seguros
    
    def nWeapons
      @nWeapons.clone
    end
    
    # Devuelve una copia del objeto
    
    def clone
      self.copy
    end
    
=begin
    #pruebas
    D = NumericDamage.new(3, 5)
    A = D.copy
    A.discardWeapon
    D.discardShieldBooster
    puts D
    puts A
    puts D.hasNoEffect
    puts NumericDamage.new(0,0).hasNoEffect
    puts D.getUIversion
    B = A.adjust(1,1)
    puts A
    puts B
=end
    
  end
end
