#encoding:utf-8

require_relative 'ShieldToUI'
  

module Deepspace

  # Esta clase representa los potenciadores de escudo que pueden tener las
  # estaciones espaciales

  class ShieldBooster
    
    # Constructor con tres parámetros
    
    def initialize(name, boost, uses)
      if !argumentos_correctos?(name, boost, uses)
        raise ArgumentError.new("Error en los argumentos de ShieldBooster")
      end

      @name = name
      @boost = boost
      @uses = uses
    end

    # Crea un nuevo shield booster a partir de otro
    
    def self.newCopy(old_one)
      new(old_one.name, old_one.boost, old_one.uses)
    end



    # Usa el potenciador de escudo, devolviendo su potencia y decrementando 
    # en una unidad sus usos
    
    def useIt
      if @uses > 0
        @uses -= 1
        return @boost
      else
        return 1.0
      end
    end


    # Comprueba que los argumentos tengan el formato correcto
    
    def argumentos_correctos?(name, boost, uses)
      if not name_correcto? name
        resultado = false
      elsif not boost_correcto? boost
        resultado = false
      elsif not uses_correcto? uses
        resultado = false
      else
        resultado = true
      end
      resultado
    end
    
    def name_correcto?(name)
      name.is_a? String
    end
    
    def boost_correcto?(boost)
      boost.is_a? Numeric
    end
    
    def uses_correcto?(uses)
      if not uses.is_a? Integer
        resultado = false
      elsif not uses >= 0
        resultado = false
      else
        resultado = true
      end
    end
    
    # Devuelve un string con información de depuración
    
    def to_s
      resultado =  "name = #{@name}\t"
      resultado += "boost = #{@boost}\t"
      resultado += "uses = #{@uses}"
      resultado
    end
    
    # Devuelve una interfaz de usuario
    
    def getUIversion
      ShieldToUI.new(self)
    end

    # Visibilidad de los métodos
    
    private :uses_correcto?, :boost_correcto?, :name_correcto?
    private :argumentos_correctos?

    # Consultores seguros
    
    def name
      @name.clone
    end
    
    def boost
      @boost.clone
    end
    
    def uses
      @uses.clone
    end
    
  end

=begin
  # Pruebas
  s = ShieldBooster.new("w",2.3,1)
  s2 = ShieldBooster.newCopy(s)
  s.useIt
  puts s
  puts s2
  s = ShieldBooster.new("w",2.3,1)
  puts s.getUIversion
  puts s.uses
=end
  
  
end