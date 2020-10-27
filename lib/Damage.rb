#encoding:utf-8

require_relative 'WeaponType'
require_relative 'DamageToUI'

module Deepspace
    
    # Esta clase implementa el daño que puede recibir una estación espacial
    
  class Damage
    
    # Constructor con el número de escudos que perder (PRIVADO)
    
    def initialize(s)
      if not nshields_correcto?(s)
        raise ArgumentError.new("Error en los argumentos de Damage")
      end
      @nShields = s
    end
    
    # Decrementa el contador del número de escudos en una unidad
    
    def discardShieldBooster
      if @nShields > 0
        @nShields-=1
      end
    end
    
    # Determina si el daño tiene efecto o no
    
    def hasNoEffect
      @nShields == 0
    end
    
    # Reduce @nShields para que no sea mayor que s
    
    def adjust(s)
      raise "ERROR: This method has not been implemented yet!"
    end
    
    # Devuelve una interfaz de usuario
    
    def getUIversion
      DamageToUI.new(self)
    end
    
    # Crea un string con los datos de la instancia, con objetivos de depuración
    
    def to_s
      resultado = "Número de escudos: #{@nShields}"
      resultado
    end
    
    # Comprueba que el número de escudos es correcto
    
    def nshields_correcto?(s)
      if not s.is_a? Integer
        resultado = false
      elsif not s >= 0
        resultado = false
      else
        resultado = true
      end
      resultado
    end
    
    def argumentos_correctos?(s)
      nshields_correcto? s
    end
    
    # Especificaciones de privacidad
    
    private :argumentos_correctos?, :nshields_correcto?
    private_class_method :new
     
    # Consultores seguros
    
    def nShields
      @nShields.clone
    end
    
  end
   
  
end
